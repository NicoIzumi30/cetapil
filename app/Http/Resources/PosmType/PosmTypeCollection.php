<?php

namespace App\Http\Resources\PosmType;

use App\Constants\PosmTypeConstants;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class PosmTypeCollection extends ResourceCollection
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
            "message" => PosmTypeConstants::GET_LIST,
            "data" => PosmTypeResource::collection($this->collection)
        ];
    }
}
