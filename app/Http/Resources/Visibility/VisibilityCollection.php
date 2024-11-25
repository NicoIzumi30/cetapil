<?php

namespace App\Http\Resources\Visibility;

use App\Constants\VisibilityConstants;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class VisibilityCollection extends ResourceCollection
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
            "message" => VisibilityConstants::GET_LIST,
            "data" => VisibilityResource::collection($this->collection)
        ];
    }
}
