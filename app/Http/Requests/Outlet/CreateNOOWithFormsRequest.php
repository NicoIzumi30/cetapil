<?php

namespace App\Http\Requests\Outlet;

use App\Traits\ResponseTrait;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;

class CreateNOOWithFormsRequest extends FormRequest
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
            // Original NOO request rules
            'city' => 'required|string',
            'name' => 'required|string',
            'category' => 'required|string',
            'visit_day' => 'required|integer|between:1,7',
            'longitude' => 'required|string',
            'latitude' => 'required|string',
            'address' => 'nullable|string',
            'cycle' => 'required|in:1x1,1x2',
            'week_type' => 'required_if:cycle,1x2|in:ODD,EVEN',
            'img_front' => 'nullable|file|mimes:png,jpg,jpeg|max:1024',
            'img_banner' => 'nullable|file|mimes:png,jpg,jpeg|max:1024',
            'img_main_road' => 'nullable|file|mimes:png,jpg,jpeg|max:1024',
            // Form rules
            // 'outlet_id' => 'required|exists:outlets,id',
            'forms' => 'required|array',
            'forms.*.id' => 'required|exists:outlet_forms,id',
            'forms.*.answer' => 'required|string',
        ];
    }

    protected function failedValidation(Validator $validator)
    {
        throw new HttpResponseException($this->errorValidation($validator->getMessageBag()));
    }
}
