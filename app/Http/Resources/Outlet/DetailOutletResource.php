<?php

namespace App\Http\Resources\Outlet;

use App\Http\Resources\Product\CategoryResource;
use App\Http\Resources\Product\ProductResource;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class DetailOutletResource extends JsonResource
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
            'user' => $this->user->only('id', 'name', 'email', 'phone_number'),
            'name' => $this->name,
            'category' => $this->category,
            'visit_day' => $this->visit_day,
            'longitude' => $this->longitude,
            'latitude' => $this->latitude,
            'city' => $this->city->only('id', 'name'),
            'address' => $this->address,
            'status' => $this->status,
            'week_type' => $this->week_type,
            'cycle' => $this->cycle,
            'images' => OutletImageResource::collection($this->images),
            'forms' => OutletFormResource::collection($this->forms),
            'product_categories' => CategoryResource::collection($this->product_categories),
            'products' => $this->products
        ];
    }
}
