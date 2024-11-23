<?php

namespace App\Http\Resources\VisualType;

use App\Constants\VisualTypeConstants;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class VisualTypeCollection extends ResourceCollection
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
            "message" => VisualTypeConstants::GET_LIST,
            "data" => VisualTypeResource::collection($this->collection)
        ];
    }
}
