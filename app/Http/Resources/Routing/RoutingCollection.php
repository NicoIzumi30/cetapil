<?php

namespace App\Http\Resources\Routing;

use App\Constants\RoutingConstants;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class RoutingCollection extends ResourceCollection
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
            "message" => RoutingConstants::GET_LIST,
            "data" => RoutingResource::collection($this->collection->except(['images', 'forms']))
        ];
    }
}
