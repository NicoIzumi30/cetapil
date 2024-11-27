<?php

namespace App\Http\Resources\Survey;

use App\Constants\SurveyConstants;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\ResourceCollection;

class SurveyCollection extends ResourceCollection
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
            "message" => SurveyConstants::GET_LIST,
            "data" => SurveyResource::collection($this->collection)
        ];
    }
}
