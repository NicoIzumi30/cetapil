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
use App\Http\Requests\SalesActivity\SaveActivityRequest;
use App\Http\Requests\SalesActivity\SaveAvailabilityRequest;
use App\Http\Requests\SalesActivity\SaveVisibilityRequest;
use App\Http\Requests\Visibility\CreateVisibilityRequest;
use App\Http\Resources\PosmType\PosmTypeCollection;
use App\Http\Resources\Channel\ChannelCollection;
use App\Http\Resources\Product\ProductChannelCollection;
use App\Http\Resources\SalesActivity\DetailSalesActivityResource;
use App\Http\Resources\Visibility\VisibilityCollection;
use App\Http\Resources\Visibility\VisibilityResource;
use App\Http\Resources\VisualType\VisualTypeCollection;
use App\Models\Category;
use App\Models\Channel;
use App\Models\City;
use App\Models\Outlet;
use App\Models\Planogram;
use App\Models\PosmType;
use App\Models\Product;
use Illuminate\Support\Arr;
use App\Models\SalesActivity;
use App\Models\SalesAvailability;
use App\Models\SalesOrder;
use App\Models\SalesSurvey;
use App\Models\SalesVisibility;
use App\Models\SurveyQuestion;
use App\Models\Visibility;
use App\Models\VisualType;
use App\Traits\HasAuthUser;
use App\Traits\ProductTrait;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Symfony\Component\HttpFoundation\Response;

class SalesActivityController extends Controller
{
    use HasAuthUser, ProductTrait;
    public function getSalesAcitivityList()
    {
        $now = Carbon::now();

        $activities = SalesActivity::completeRelation()
            ->with(['outlet', 'outlet.channel', 'user'])
            ->where('user_id', $this->getAuthUserId())
            ->whereDate('checked_in', $now)
            ->get();

        return new SalesActivityCollection($activities);
    }
    public function getAllProducts()
    {

        $products = Product::with(['category'])->get();
        return new ProductCollection($products);
    }

    public function getAllChannels()
    {
        $channels = Channel::whereNull('deleted_at')
            ->get(['id', 'name']);

        return new ChannelCollection($channels);
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


    public function storeActivity(SaveActivityRequest $request)
    {
        $data = $request->validated();
        $activity = SalesActivity::findOrFail($data['sales_activity_id']);

        // Check if the activity is already submitted
        if ($activity->status === 'SUBMITTED') {
            return $this->failedResponse(
                'This activity has already been submitted and cannot be modified',
                Response::HTTP_BAD_REQUEST
            );
        }

        // Check if the authenticated user matches the activity's user
        if ($activity->user_id !== $this->getAuthUserId()) {
            return $this->failedResponse(
                'You are not authorized to modify this activity',
                Response::HTTP_FORBIDDEN
            );
        }

        // Check if the outlet_id matches
        if ($activity->outlet_id !== $data['outlet_id']) {
            return $this->failedResponse(
                'The outlet ID does not match with the current activity',
                Response::HTTP_BAD_REQUEST
            );
        }

        // Start transaction
        DB::beginTransaction();
        try {
            // Clear existing data
            SalesAvailability::where('sales_activity_id', $activity->id)->delete();
            SalesVisibility::where('sales_activity_id', $activity->id)->delete();
            SalesSurvey::where('sales_activity_id', $activity->id)->delete();
            SalesOrder::where('sales_activity_id', $activity->id)->delete();

            // Store availability data
            foreach ($data['availability'] as $item) {
                SalesAvailability::create([
                    'sales_activity_id' => $activity->id,
                    'outlet_id' => $data['outlet_id'],
                    'product_id' => $item['product_id'],
                    'stock_on_hand' => $item['stock_on_hand'],
                    'stock_inventory' => $item['stock_inventory'],
                    'av3m' => $item['av3m'],
                    'status' => $item['status'],
                    'rekomendasi' => $item['rekomendasi'],
                    'availability' => $item['availability']
                ]);
            }

            // Store visibility data
            foreach ($data['visibility'] as $item) {
                $visibilityData = [
                    'sales_activity_id' => $activity->id,
                    'category' => $item['category'],
                    'type' => $item['type'],
                    'position' => $item['position'],
                    'posm_type_id' => $item['posm_type_id'] ?? null,
                    'visual_type' => $item['visual_type'] ?? null,
                    'condition' => $item['condition'] ?? null,
                    'shelf_width' => $item['shelf_width'] ?? null,
                    'shelving' => $item['shelving'] ?? null,
                    'has_secondary_display' => $item['has_secondary_display'] ?? null
                ];

                // Handle photo uploads
                if (isset($item['display_photo']) && $item['display_photo'] instanceof UploadedFile) {
                    $photo = $item['display_photo'];
                    $path = $item['category'] === 'COMPETITOR' ?
                        "visibility-entries/{$activity->id}/competitor" :
                        "visibility-entries/{$activity->id}";
                    $media = saveFile($photo, $path);
                    $visibilityData['display_photo'] = $media['path'];
                }

                // Handle competitor specific data
                if ($item['category'] === 'COMPETITOR') {
                    $visibilityData['competitor_brand_name'] = $item['competitor_brand_name'] ?? null;
                    $visibilityData['competitor_promo_mechanism'] = $item['competitor_promo_mechanism'] ?? null;
                    $visibilityData['competitor_promo_start'] = $item['competitor_promo_start'] ?? null;
                    $visibilityData['competitor_promo_end'] = $item['competitor_promo_end'] ?? null;

                    // Handle second photo only for competitor
                    if (isset($item['display_photo_2']) && $item['display_photo_2'] instanceof UploadedFile) {
                        $displayPhoto2 = $item['display_photo_2'];
                        $mediaPhoto2 = saveFile($displayPhoto2, "visibility-entries/{$activity->id}/competitor");
                        $visibilityData['display_photo_2'] = $mediaPhoto2['path'];
                    }
                }

                SalesVisibility::create($visibilityData);
            }

            // Store survey data
            foreach ($data['survey'] as $item) {
                SalesSurvey::create([
                    'sales_activity_id' => $activity->id,
                    'survey_question_id' => $item['survey_question_id'],
                    'answer' => $item['answer']
                ]);
            }

            // Store order data
            if (isset($data['order']) && !empty($data['order'])) {
                foreach ($data['order'] as $item) {
                    SalesOrder::create([
                        'sales_activity_id' => $activity->id,
                        'outlet_id' => $data['outlet_id'],
                        'product_id' => $item['product_id'],
                        'total_items' => $item['total_items'],
                        'subtotal' => $item['subtotal']
                    ]);
                }
            }


            // Update SalesActivity status and times
            $activity->update([
                'checked_out' => $data['current_time'],
                'views_knowledge' => $data['views_knowledge'],
                'time_availability' => $data['time_availability'],
                'time_visibility' => $data['time_visibility'],
                'time_knowledge' => $data['time_knowledge'],
                'time_survey' => $data['time_survey'],
                'time_order' => $data['time_order'],
                'status' => 'SUBMITTED'
            ]);

            DB::commit();
            return $this->successResponse(SalesActivityConstants::STORE_ACTIVITY, Response::HTTP_OK);
        } catch (\Exception $e) {
            DB::rollBack();
            return $this->failedResponse(
                'Failed to store activity: ' . $e->getMessage(),
                Response::HTTP_INTERNAL_SERVER_ERROR
            );
        }
    }
    public function getActivityById(string $id)
    {
        try {
            $activity = SalesActivity::with([
                'outlet',
                'user',
                'salesVisibilities',
                'surveys',
                'orders',
                'availabilities'
            ])
                ->completeRelation()
                ->findOrFail($id);

            return new DetailSalesActivityResource($activity);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'ERROR',
                'message' => 'Failed to fetch activity: ' . $e->getMessage()
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
    public function getPlanogram()
    {
        try {
            $planogram = Planogram::with('channel')->get();
            return response()->json([
                'status' => 'OK',
                'message' => 'Get the Planogram list successfully.',
                'data' => $planogram
            ], Response::HTTP_OK);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'ERROR',
                'message' => 'Failed to fetch planogram: ' . $e->getMessage()
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
    public function cancelActivity($id)
    {
        $activity = SalesActivity::find($id);
        if (!$activity) {
            return response()->json([
                'status' => 'ERROR',
                'message' => 'Activity not found'
            ], Response::HTTP_NOT_FOUND);
        }
        if ($activity->user_id !== $this->getAuthUserId()) {
            return $this->failedResponse(
                'You are not authorized to cancel this activity',
                Response::HTTP_FORBIDDEN
            );
        }
        if ($activity->status === 'SUBMITTED') {
            return $this->failedResponse(
                'This activity has already been submitted and cannot be canceled',
                Response::HTTP_BAD_REQUEST
            );
        }
        DB::beginTransaction();
        try {
            SalesAvailability::where('sales_activity_id', $id)->forceDelete();
            SalesVisibility::where('sales_activity_id', $id)->forceDelete();
            SalesSurvey::where('sales_activity_id', $id)->forceDelete();
            SalesOrder::where('sales_activity_id', $id)->forceDelete();
            $activity->forceDelete();
            DB::commit();
            return response()->json([
                'status' => 'OK',
                'message' => 'Activity cancel successfully',
            ], Response::HTTP_OK);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'status' => 'ERROR',
                'message' => 'Failed cancel activity : ' . $e->getMessage()
            ], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
}
