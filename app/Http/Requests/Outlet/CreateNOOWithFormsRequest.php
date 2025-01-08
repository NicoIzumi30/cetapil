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
            'channel_id' => 'required|exists:channels,id', 
            'city' => 'required|string',
            'name' => 'required|string',
            'category' => 'required|string',
            'longitude' => 'required|string',
            'latitude' => 'required|string',
            'address' => 'nullable|string',
            'img_front' => 'required|file|mimes:png,jpg,jpeg|max:1024',
            'img_banner' => 'required|file|mimes:png,jpg,jpeg|max:1024',
            'img_main_road' => 'required|file|mimes:png,jpg,jpeg|max:1024',
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
