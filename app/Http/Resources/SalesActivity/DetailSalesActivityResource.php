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
            'outlet' => $this->outlet->only(
                'id',
                'name',
                'category',
                // 'city_id', 'longitude', 'latitude',
                'visit_day',
            ),
            // 'user' => $this->user->only('id', 'name'),
            'orders' => SalesOrderResource::collection($this->whenLoaded('orders')),
            'visibilities' => SalesVisibilityResource::collection($this->whenLoaded('salesVisibilities')),
            'availabilities' => SalesAvailabilityResource::collection($this->whenLoaded('availabilities')),
            'surveys' => SalesSurveyResource::collection($this->whenLoaded('surveys')),
        ];
    }
}

class SalesOrderResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'sales_activity_id' => $this->sales_activity_id,
            // 'outlet_id' => $this->outlet_id,
            'product_id' => $this->product_id,
            'total_items' => $this->total_items,
            'subtotal' => $this->subtotal,
        ];
    }
}

class SalesVisibilityResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'sales_activity_id' => $this->sales_activity_id,
            'visibility_id' => $this->visibility_id,
            // 'filename1' => $this->filename1,
            // 'filename2' => $this->filename2,
            'path1' => $this->path1,
            'path2' => $this->path2,
            'condition' => $this->condition,
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
            // 'outlet_id' => $this->outlet_id,
            'product_id' => $this->product_id,
            'availability_stock' => $this->availability_stock,
            'average_stock' => $this->average_stock,
            'ideal_stock' => $this->ideal_stock,
            // 'status' => $this->status,
            // 'detail' => $this->detail,
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
