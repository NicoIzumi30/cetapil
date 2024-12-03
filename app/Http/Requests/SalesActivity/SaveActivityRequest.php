<?php

namespace App\Http\Requests\SalesActivity;

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
            'views_knowledge' => 'required:numeric',
            'time_availability' => 'required:numeric',
            'time_visibility' => 'required:numeric',
            'time_knowledge' => 'required:numeric',
            'time_survey' => 'required:numeric',
            'time_order' => 'required:numeric',
            'current_time' => 'required|date',

            // Sales Availability
            'availability' => 'required|array',
            'availability.*.product_id' => 'required|exists:products,id',
            'availability.*.availability_stock' => 'required:numeric',
            'availability.*.average_stock' => 'required:numeric',
            'availability.*.ideal_stock' => 'required:numeric',


            // Sales Availability
            'visibility' => 'required|array',
            'visibility.*.visibility_id' => 'required|exists:visibilities,id',
            'visibility.*.file1' => 'required|image|mimes:jpeg,png,jpg',
            'visibility.*.file2' => 'required|image|mimes:jpeg,png,jpg',
            'visibility.*.condition' => 'required|in:GOOD,BAD',

            // Sales Question
            'survey' => 'required|array',
            'survey.*.survey_question_id' => 'required|exists:survey_questions,id|distinct',
            'survey.*.answer' => 'required|string',

            // Sales Order
            'order' => 'required|array',
            'order.*.product_id' => 'required|exists:products,id',
            'order.*.total_items' => 'required:numeric',
            'order.*.subtotal' => 'required:numeric',
        ];
    }
    protected function failedValidation(Validator $validator)
    {
        throw new HttpResponseException($this->errorValidation($validator->getMessageBag()));
    }
}
