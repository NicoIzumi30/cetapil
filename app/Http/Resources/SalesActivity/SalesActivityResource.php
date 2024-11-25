<?php

namespace App\Http\Resources\SalesActivity;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class SalesActivityResource extends JsonResource
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
            'outlet' => $this->outlet->only('id', 'name', 'category', 'city_id', 'longitude', 'latitude', 'visit_day'),
            'user' => $this->user->only('id', 'name'),
            'checked_in' => $this->checked_in,
            'checked_out' => $this->checked_out,
            'views_knowledge' => $this->views_knowledge,
            'time_availability' => $this->time_availability,
            'time_visibility' => $this->time_visibility,
            'time_knowledge' => $this->time_knowledge,
            'time_survey' => $this->time_survey,
            'time_order' => $this->time_order,
            'status' => $this->status
        ];
    }
}

