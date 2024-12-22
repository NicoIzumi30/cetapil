<?php

namespace App\Http\Resources\SalesActivity;

use Illuminate\Http\Resources\Json\JsonResource;

class DetailSalesActivityResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'outlet_id' => $this->outlet_id,
            'user_id' => $this->user_id,
            'views_knowledge' => $this->views_knowledge,
            'time_availability' => $this->time_availability,
            'time_visibility' => $this->time_visibility,
            'time_knowledge' => $this->time_knowledge,
            'time_survey' => $this->time_survey,
            'time_order' => $this->time_order,
            'checked_in' => $this->checked_in,
            'checked_out' => $this->checked_out,
            'status' => $this->status,
            'channel' => $this->outlet->channel ? $this->outlet->channel->only('id', 'name') : null,
            'outlet' => $this->outlet->only(
                'id',
                'name',
                'category',
                'visit_day',
            ),
            'orders' => SalesOrderResource::collection($this->whenLoaded('orders')),
            'visibilities' => [
                'primary' => [
                    'core' => $this->formatVisibilities('CORE', 'PRIMARY'),
                    'baby' => $this->formatVisibilities('BABY', 'PRIMARY'),
                ],
                'secondary' => [
                    'core' => $this->formatVisibilities('CORE', 'SECONDARY'),
                    'baby' => $this->formatVisibilities('BABY', 'SECONDARY'),
                ],
            ],
            'availabilities' => SalesAvailabilityResource::collection($this->whenLoaded('availabilities')),
            'surveys' => SalesSurveyResource::collection($this->whenLoaded('surveys')),
        ];
    }

    private function formatVisibilities($category, $type)
    {
        return $this->salesVisibilities
            ->where('category', $category)
            ->where('type', $type)
            ->sortBy('position')
            ->values()
            ->map(function ($visibility) {
                return new VisibilityEntryResource($visibility);
            });
    }
}

class SalesOrderResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'sales_activity_id' => $this->sales_activity_id,
            'product_id' => $this->product_id,
            'total_items' => $this->total_items,
            'subtotal' => $this->subtotal,
        ];
    }
}

class VisibilityEntryResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'category' => $this->category,
            'type' => $this->type,
            'position' => $this->position,
            'posm_type' => $this->posmType ? [
                'id' => $this->posmType->id,
                'name' => $this->posmType->name,
            ] : null,
            'visual_type' => $this->visual_type,
            'condition' => $this->condition,
            'shelf_width' => $this->shelf_width,
            'shelving' => $this->shelving,
            'has_secondary_display' => $this->has_secondary_display,
            'display_photo' => $this->display_photo,
        ];
    }
}

class SalesAvailabilityResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'sales_activity_id' => $this->sales_activity_id,
            'product_id' => $this->product_id,
            'stock_on_hand' => $this->stock_on_hand,
            'stock_inventory' => $this->stock_inventory,
            'av3m' => $this->av3m,
            'status' => $this->status,
            'rekomendasi' => $this->rekomendasi,
            'availability' => $this->availability,
        ];
    }
}

class SalesSurveyResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'sales_activity_id' => $this->sales_activity_id,
            'survey_question_id' => $this->survey_question_id,
            'answer' => $this->answer,
        ];
    }
}
