<?php

namespace App\Http\Resources\ProductKnowladge;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProductKnowladgeResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'path_pdf' => $this->path_pdf,
            'path_video' => $this->path_video,
        ];
    }
}
