<?php

namespace App\Http\Resources\Selling;

use App\Http\Resources\Product\ProductResource;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class SellingProductResource extends JsonResource
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
            'sell' => SellingResource::make($this->sell),
            'product' => ProductResource::make($this->product),
            'stock' => $this->stock,
            'selling' => $this->selling,
            'balance' => $this->balance,
            'datetime' => $this->created_at,
        ];
    }
}
