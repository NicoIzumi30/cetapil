<?php

namespace App\Http\Resources\Outlet;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class OutletFormResource extends JsonResource
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
            'outletForm' => $this->outletForm?->only('id', 'type', 'question'),  // Added null safe operator
            'answer' => $this->answer
        ];
    }
}
