<?php

namespace App\Http\Resources\Selling;

use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class SellingResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'user' => $this->user->only('id', 'name'),
            'outlet_name' => $this->outlet_name,
            'category_outlet' => $this->category_outlet,
            'products' => $this->whenLoaded('products', function () {
                return $this->products->map(function ($selling_product) {
                    return [
                        'id' => $selling_product->id,
                        'product_id' => $selling_product->product_id,
                        'product_name' => $selling_product->product_name,
                        'stock' => $selling_product->stock,
                        'selling' => $selling_product->selling,
                        'balance' => $selling_product->balance,
                        'price' => $selling_product->price,
                    ];
                });
            }, []),
            'longitude' => $this->longitude,
            'latitude' => $this->latitude,
            'filename' => $this->filename,
            'image' => $this->image,
            'created_at' => Carbon::parse($this->created_at)->toDateTimeLocalString()
        ];
    }
}
