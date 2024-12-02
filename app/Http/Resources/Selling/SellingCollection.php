<?php

namespace App\Http\Resources\Selling;

use App\Constants\SellingConstants;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class SellingCollection extends ResourceCollection
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
            "message" => SellingConstants::GET_LIST,
            "data" => SellingResource::collection($this->collection)
        ];
    }
}
