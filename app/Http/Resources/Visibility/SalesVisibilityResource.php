<?php

namespace App\Http\Resources\Visibility;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class SalesVisibilityResource extends JsonResource
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
            'visibility' => VisibilityResource::make($this->visibility),
            'condition' => $this->condition,
            'filename' => $this->filename,
            'image' => $this->image
        ];
    }
}
