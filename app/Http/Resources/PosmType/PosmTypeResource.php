<?php

namespace App\Http\Resources\PosmType;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PosmTypeResource extends JsonResource
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
            'name' => $this->name
        ];
    }
}
