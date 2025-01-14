<?php

namespace App\Http\Resources\SalesActivity;

use App\Models\Av3m;
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
            'outlet' => $this->outlet->only('id', 'name', 'category', 'city_id', 'longitude', 'latitude'),
            'user' => $this->user->only('id', 'name'),
            'channel' => $this->outlet->channel ? $this->outlet->channel->only('id', 'name') : null,
            'av3m_products' => Av3m::where('outlet_id', $this->outlet_id)
                ->select('product_id', 'av3m')
                ->get()
                ->map(function ($av3m) {
                    return [
                        'product_id' => $av3m->product_id,
                        'av3m' => round($av3m->av3m)
                    ];
                }),
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
