<?php

namespace App\Http\Controllers\Api;

use App\Constants\OutletConstants;
use App\Constants\SalesActivityConstants;
use App\Constants\VisibilityConstants;
use App\Http\Controllers\Controller;
use App\Http\Resources\Product\CategoryCollection;
use App\Http\Resources\Product\ProductCollection;
use App\Http\Resources\SalesActivity\SalesActivityCollection;
use App\Http\Requests\SalesActivity\GetProductListByCategoryIdRequest;
use App\Http\Requests\SalesActivity\SaveAvailabilityRequest;
use App\Http\Requests\SalesActivity\SaveVisibilityRequest;
use App\Http\Requests\Visibility\CreateVisibilityRequest;
use App\Http\Resources\PosmType\PosmTypeCollection;
use App\Http\Resources\Visibility\VisibilityCollection;
use App\Http\Resources\Visibility\VisibilityResource;
use App\Http\Resources\VisualType\VisualTypeCollection;
use App\Models\Category;
use App\Models\City;
use App\Models\Outlet;
use App\Models\PosmType;
use App\Models\Product;
use Illuminate\Support\Arr;
use App\Models\SalesActivity;
use App\Models\SalesAvailability;
use App\Models\SalesVisibility;
use App\Models\Visibility;
use App\Models\VisualType;
use App\Traits\HasAuthUser;
use App\Traits\ProductTrait;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Http\JsonResponse;
use Symfony\Component\HttpFoundation\Response;

class SalesActivityController extends Controller
{
    use HasAuthUser, ProductTrait;
    public function getSalesAcitivityList()
    {
        $activities = SalesActivity::completeRelation()
            ->where('user_id', $this->getAuthUserId())
            ->whereDate('checked_in', Carbon::now())
            ->get();
        return new SalesActivityCollection($activities);
    }


    public function categoryList(Request $request): CategoryCollection
    {
        $categories = Category::query();

        $categories = $categories->get();
        return new CategoryCollection($categories);
    }


    public function productByCategoryList(GetProductListByCategoryIdRequest $request): ProductCollection
    {
        $products = $this->getProductsWithAv3mFromOutletProduct($request->ids, $request->outlet_id);
        return new ProductCollection($products);
    }

    public function saveAvailability(SaveAvailabilityRequest $request): JsonResponse
    {
        $data = $request->validated();
        foreach ($data['products'] as $product) {
            SalesAvailability::create([
                'outlet_id' => $data['outlet_id'],
                'product_id' => $product['id'],
                'availability_stock' => $product['availability_stock'],
                'average_stock' => $product['average_stock'],
                'ideal_stock' => $product['ideal_stock'],
                'status' => true,
                'detail' => SalesAvailability::getDetail((int) $product['ideal_stock'] ?? 0)
            ]);
        }

        return $this->successResponse(SalesActivityConstants::SAVE_AVAILABILITY, Response::HTTP_OK);
    }

    public function getVisibilityList(Request $request, string $outlet_id): VisibilityCollection
    {
        $now = Carbon::now();
        $visibilities = Visibility::query()
            ->where('outlet_id', $outlet_id)
            ->where('started_at', '<=', $now)
            ->where('ended_at', '>=', $now);

        $visibilities = $visibilities->get();
        return new VisibilityCollection($visibilities);
    }

    public function saveVisibility(SaveVisibilityRequest $request): JsonResponse
    {
        $data = $request->validated();
        foreach ($data['visibilities'] as $key => $visibility) {
            $newVis = SalesVisibility::create([
                'visibility_id' => $visibility['id'],
                'condition' => $visibility['condition'],
            ]);

            if ($request->hasFile("visibilities.$key.image")) {
                $file = $request->file("visibilities.$key.image");
                $media = saveFile($file, "sales-visbilities/$newVis->id");

                $newVis->filename = $media['filename'];
                $newVis->path = $media['path'];
                $newVis->save();
            }
        }

        return $this->successResponse(SalesActivityConstants::SAVE_VISIBILITY, Response::HTTP_OK);
    }

    public function storeVisibility(CreateVisibilityRequest $request)
    {
        $data = Arr::except($request->validated(), 'banner_img');
        $visibility = new Visibility($data);
        $visibility->save();

        if ($request->hasFile('banner_img')) {
            $file = $request->file('banner_img');
            $media = saveFile($file, "visibilities/$visibility->id");

            $visibility->filename = $media['filename'];
            $visibility->path = $media['path'];
            $visibility->save();
        }

        return $this->successResponse(VisibilityConstants::CREATE, Response::HTTP_OK, new VisibilityResource($visibility));
    }

    public function getProductByCategory(string $id)
    {
        $categories = Product::query()->where('category_id', $id);

        $categories = $categories->get();
        return new ProductCollection($categories);
    }

    public function getCityList(): JsonResponse
    {
        $cities = City::select('id', 'name')->get();
        return $this->successResponse(VisibilityConstants::GET_CITY, Response::HTTP_OK, $cities);
    }

    public function getOutletList()
    {
        $outlets = Outlet::query()->select('id', 'user_id', 'name', 'category');

        $outlets = $outlets->get();
        return $this->successResponse(OutletConstants::GET_LIST, Response::HTTP_OK, $outlets);
    }

    public function getVisualTypeList(Request $request): VisualTypeCollection
    {
        $visual_types = VisualType::query();

        $visual_types = $visual_types->get();
        return new VisualTypeCollection($visual_types);
    }

    public function getPosmTypeList(Request $request): PosmTypeCollection
    {
        $posm_types = PosmType::query();

        $posm_types = $posm_types->get();
        return new PosmTypeCollection($posm_types);
    }
}
