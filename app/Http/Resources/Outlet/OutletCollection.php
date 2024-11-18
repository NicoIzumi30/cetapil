<?php

namespace App\Http\Resources\Outlet;

use App\Constants\OutletConstants;
use App\Models\Outlet;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class OutletCollection extends ResourceCollection
{
    /**
     * Transform the resource collection into an array.
     *
     * @return array<int|string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            "status" => "OK",
            "message" => OutletConstants::GET_LIST,
            "total_request_noo" => Outlet::where('status', 'PENDING')->count(),
            "data" => OutletResource::collection($this->collection->except(['images', 'forms']))
        ];
    }
}
