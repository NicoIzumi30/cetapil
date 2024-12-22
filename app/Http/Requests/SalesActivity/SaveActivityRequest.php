<?php

namespace App\Http\Requests\SalesActivity;

use App\Rules\ValidateVisibilityEntries;
use App\Traits\ResponseTrait;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;

class SaveActivityRequest extends FormRequest
{
    use ResponseTrait;
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            // Sales Activity
            'sales_activity_id' => 'required|exists:sales_activities,id',
            'outlet_id' => 'required|exists:outlets,id',
            'views_knowledge' => 'required|numeric',
            'time_availability' => 'required|numeric',
            'time_visibility' => 'required|numeric',
            'time_knowledge' => 'required|numeric',
            'time_survey' => 'required|numeric',
            'time_order' => 'required|numeric',
            'current_time' => 'required|date',

            // Sales Availability
            'availability' => 'required|array',
            'availability.*.product_id' => 'required|exists:products,id',
            'availability.*.stock_on_hand' => 'required|integer',
            'availability.*.stock_inventory' => 'required|integer',
            'availability.*.av3m' => 'required|integer',
            'availability.*.status' => 'required|in:IDEAL,MINUS,OVER',
            'availability.*.rekomendasi' => 'required|integer',
            'availability.*.availability' => 'required|in:Y,N',

            // Visibility Entries
            'visibility' => ['required', 'array', new ValidateVisibilityEntries],
            'visibility.*' => 'required|array',
            'visibility.*.category' => 'required|in:CORE,BABY',
            'visibility.*.type' => 'required|in:PRIMARY,SECONDARY',
            'visibility.*.position' => 'required|integer|min:1|max:3',
            'visibility.*.posm_type_id' => 'required_if:type,PRIMARY|exists:posm_types,id',
            'visibility.*.visual_type' => 'required|string|max:255',
            'visibility.*.condition' => 'required_if:type,PRIMARY|in:GOOD,BAD',
            'visibility.*.display_photo' => 'required|image|mimes:jpeg,png,jpg',
            'visibility.*.shelf_width' => 'required_if:type,PRIMARY|integer|nullable',
            'visibility.*.shelving' => 'required_if:type,PRIMARY|string|max:255|nullable',
            'visibility.*.has_secondary_display' => 'required_if:type,SECONDARY|in:Y,N',

            // Sales Survey
            'survey' => 'required|array',
            'survey.*.survey_question_id' => 'required|exists:survey_questions,id|distinct',
            'survey.*.answer' => 'required|string',

            // Sales Order
            'order' => 'required|array',
            'order.*.product_id' => 'required|exists:products,id',
            'order.*.total_items' => 'required|numeric',
            'order.*.subtotal' => 'required|numeric',
        ];
    }
    protected function failedValidation(Validator $validator)
    {
        throw new HttpResponseException($this->errorValidation($validator->getMessageBag()));
    }
}
