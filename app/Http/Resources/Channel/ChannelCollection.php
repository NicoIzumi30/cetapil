<?php

namespace App\Http\Resources\Channel;

use App\Constants\ProductConstants;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class ChannelCollection extends ResourceCollection
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
            "message" =>"Get the channel list successfully.",
            "data" => ChannelResource::collection($this->collection)
        ];
    }
}
