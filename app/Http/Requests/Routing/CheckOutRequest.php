<?php

namespace App\Http\Requests\Routing;

use App\Traits\ResponseTrait;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;

class CheckOutRequest extends FormRequest
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
            'sales_activity_id' => 'required|exists:sales_activities,id',
            'checked_out' => 'required|date',
            'views_knowledge' => 'required|numeric|min:0',
            'time_availability' => 'required|numeric|min:0',
            'time_visibility' => 'required|numeric|min:0',
            'time_knowledge' => 'required|numeric|min:0',
            'time_survey' => 'required|numeric|min:0',
            'time_order' => 'required|numeric|min:0',
        ];
    }

    protected function failedValidation(Validator $validator)
    {
        throw new HttpResponseException($this->errorValidation($validator->getMessageBag()));
    }
}
