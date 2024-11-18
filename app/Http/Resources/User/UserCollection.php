<?php

namespace App\Http\Resources\User;

use App\Constants\UserConstants;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class UserCollection extends ResourceCollection
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
            "message" => UserConstants::GET_LIST,
            "data" => UserResource::collection($this->collection)
        ];
    }
}
