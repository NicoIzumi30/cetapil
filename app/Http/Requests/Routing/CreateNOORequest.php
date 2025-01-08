<?php

namespace App\Http\Requests\Routing;

use App\Traits\ResponseTrait;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;

class CreateNOORequest extends FormRequest
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
            'city' => 'required|string',
            'name' => 'required|string',
            'category' => 'required|string',
            'longitude' => 'required|string',
            'latitude' => 'required|string',
            'address' => 'nullable|string',
            'img_front' => 'nullable|file|mimes:png,jpg,jpeg|max:1024',
            'img_banner' => 'nullable|file|mimes:png,jpg,jpeg|max:1024',
            'img_main_road' => 'nullable|file|mimes:png,jpg,jpeg|max:1024'
        ];
    }

    protected function failedValidation(Validator $validator)
    {
        throw new HttpResponseException($this->errorValidation($validator->getMessageBag()));
    }
}
