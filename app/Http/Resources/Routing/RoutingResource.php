<?php

namespace App\Http\Resources\Routing;

use App\Http\Resources\Outlet\OutletFormResource;
use App\Http\Resources\Outlet\OutletImageResource;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class RoutingResource extends JsonResource
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
            'user' => $this->user?->only('id', 'name'),  // Added null safe operator
            'name' => $this->name,
            'category' => $this->category,
            'channel' => $this->channel?->only('id', 'name'),  // Already had null check
            'visit_day' => $this->visit_day,
            'longitude' => $this->longitude,
            'latitude' => $this->latitude,
            'city' => $this->city,
            'address' => $this->address,
            'status' => $this->status,
            'week_type' => $this->week_type,
            'cycle' => $this->cycle,
            'sales_activity' => $this->salesActivities->first(),
            'images' => OutletImageResource::collection($this->images),
            'forms' => OutletFormResource::collection($this->forms)
        ];
    }
}
