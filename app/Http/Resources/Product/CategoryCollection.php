<?php

namespace App\Http\Resources\Product;

use App\Constants\ProductConstants;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class CategoryCollection extends ResourceCollection
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
            "message" => ProductConstants::GET_CATEGORY_LIST,
            "data" => CategoryResource::collection($this->collection)
        ];
    }
}
