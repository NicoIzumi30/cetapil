<?php

namespace App\Http\Resources\Outlet;

use App\Http\Resources\Product\CategoryResource;
use App\Http\Resources\Product\ProductResource;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class OutletResource extends JsonResource
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
            'longitude' => $this->longitude,
            'latitude' => $this->latitude,
            'city' => $this->city->only('id', 'name'),
            'address' => $this->address,
            'status' => $this->status,
            'images' => OutletImageResource::collection($this->images),
            'forms' => OutletFormResource::collection($this->forms)
        ];
    }
}
