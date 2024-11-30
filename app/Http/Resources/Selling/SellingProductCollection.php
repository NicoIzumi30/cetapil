<?php

namespace App\Http\Resources\Selling;

use App\Constants\SellingConstants;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class SellingProductCollection extends ResourceCollection
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
            "message" => SellingConstants::GET_PRODUCT_LIST,
            "data" => SellingProductResource::collection($this->collection)
        ];
    }
}
