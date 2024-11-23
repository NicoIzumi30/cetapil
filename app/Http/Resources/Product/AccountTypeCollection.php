<?php

namespace App\Http\Resources\Product;

use App\Constants\ProductConstants;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class AccountTypeCollection extends ResourceCollection
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
            "message" => ProductConstants::GET_ACCOUNT_TYPE_LIST,
            "data" => AccountTypeResource::collection($this->collection)
        ];
    }
}
