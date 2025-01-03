<?php

namespace App\Http\Controllers\Api;

use App\Constants\SellingConstants;
use App\Http\Controllers\Controller;
use App\Http\Requests\Selling\CreateSellingRequest;
use App\Http\Resources\Selling\SellingCollection;
use App\Models\Product;
use App\Models\Selling;
use App\Models\SellingProduct;
use App\Traits\HasAuthUser;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Arr;
use Symfony\Component\HttpFoundation\Response;

class SellingController extends Controller
{
    use HasAuthUser;
    public function index(Request $request): SellingCollection
    {
        $selling = Selling::query()
            ->with(['products.product'])
            ->where('created_at', '>=', Carbon::today()->subDays(10))
            ->latest()
            ->get();

        return new SellingCollection($selling);
    }

    public function store(CreateSellingRequest $request): JsonResponse
    {
        $data = Arr::except($request->validated(), ['image', 'products']);
        $selling = new Selling($data);
        $selling->user_id = $this->getAuthUserId();
        $selling->save();

        if ($request->hasFile('image')) {
            $file = $request->file('image');
            $media = saveFile($file, "sellings/$selling->id");
            $selling->update($media);
        }

        foreach ($request->products as $product) {
            $prod = Product::find($product['id']);
            if($product['qty'] > 0) {
                SellingProduct::create([
                    'selling_id' => $selling->id,
                    'product_id' => $prod->id,
                    'product_name' => $prod->sku,
                    'qty' => $product['qty'],
                    'price' => $product['price'],
                    'total' => $product['qty'] * $product['price']
                ]);
            }
        }

        return $this->successResponse(SellingConstants::CREATE, Response::HTTP_OK);
    }
}
