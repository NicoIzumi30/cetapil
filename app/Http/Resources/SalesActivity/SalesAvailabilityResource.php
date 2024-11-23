<?php

namespace App\Http\Resources\SalesActivity;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class SalesAvailabilityResource extends JsonResource
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
            'outlet' => $this->outlet?->only('id', 'name'),
            'product' => $this->product->only('id', 'sku'),
            'availability_stock' => $this->availability_stock,
            'average_stock' => $this->average_stock,
            'ideal_stock' => $this->ideal_stock,
            'status' => $this->status,
            'detail' => $this->detail
        ];
    }
}
