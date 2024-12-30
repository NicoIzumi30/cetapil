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
            'outlet' => $this->outlet->only('id', 'name'),
            'products' => $this->whenLoaded('products', function () {
                return $this->products->map(function ($selling_product) {
                    return [
                        'id' => $selling_product->id,
                        'product_id' => $selling_product->product_id,
                        'category' => $selling_product->product->category?->only("id", "name"),
                        'product_name' => $selling_product->product_name,
                        'qty' => $selling_product->qty,
                        'price' => $selling_product->price,
                        'total' => $selling_product->total,
                    ];
                });
            }, []),
            'longitude' => $this->longitude,
            'latitude' => $this->latitude,
            'filename' => $this->filename,
            'image' => "/storage{$this->path}",
            'created_at' => Carbon::parse($this->created_at)->toDateTimeLocalString(),
            'checked_in' => $this->checked_in ? Carbon::parse($this->checked_in)->toDateTimeLocalString() : null,
            'checked_out' => $this->checked_out ? Carbon::parse($this->checked_out)->toDateTimeLocalString() : null,
            'duration' => $this->duration,
        ];
    }
}
