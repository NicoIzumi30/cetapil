<?php

namespace App\Http\Resources\SalesActivity;

use App\Constants\SalesActivityConstants;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class SalesAvailabilityCollection extends ResourceCollection
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
            "message" => SalesActivityConstants::GET_LIST_ON_HAND,
            "data" => SalesAvailabilityResource::collection($this->collection)
        ];
    }
}
