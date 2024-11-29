<?php

namespace App\Http\Resources\ProductKnowladge;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class ProductKnowladgeCollection extends ResourceCollection
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
            "message" => "Get the outlet list successfully.",
            "data" => ProductKnowladgeResource::collection($this->collection)
        ];
    }
}
