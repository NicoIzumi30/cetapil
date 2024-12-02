<?php

namespace App\Http\Resources\SalesActivity;

use Carbon\Carbon;
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
        $now = Carbon::now();
        return [
            'id' => $this->id,
            'outlet' => $this->outlet->only('id', 'name', 'category', 'city_id', 'longitude', 'latitude', 'visit_day'),
            'user' => $this->user->only('id', 'name'),
            'channel' => $this->outlet->channel ? $this->outlet->channel->only('id', 'name') : null,
            'visibilities' => $this->whenLoaded('visibilities', function () {
                return $this->visibilities->map(function ($visibility) {
                    return [
                        'id' => $visibility->id,
                        'posm_type_id' => $visibility->posm_type_id,
                        'visual_type_id' => $visibility->visual_type_id,
                        'filename' => $visibility->filename,
                        'image' => $visibility->path,
                    ];
                });
            }, []),
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
