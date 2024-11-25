<?php

namespace App\Http\Resources\Visibility;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class VisibilityResource extends JsonResource
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
            'outlet' => $this->outlet->only('id', 'name'),
            'user' => $this->user->only('id', 'name'),
            'product' => $this->product->only('id', 'sku', 'category'),
            'city' => $this->city->only('id', 'name'),
            'posm_type' => $this->posmType->only('id', 'name'),
            'visual_type' => $this->visualType->only('id', 'name'),
            'filename' => $this->filename,
            'image' => $this->image,
            'started_at' => $this->started_at,
            'ended_at' => $this->ended_at,
            'status' => $this->status
        ];
    }
}
