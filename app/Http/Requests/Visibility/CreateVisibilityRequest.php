<?php

namespace App\Http\Requests\Visibility;

use App\Traits\ResponseTrait;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;

class CreateVisibilityRequest extends FormRequest
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
            'user_id' => 'required|exists:users,id',
            'city_id' => 'required|exists:cities,id',
            'outlet_id' => 'required|exists:outlets,id',
            'product_id' => 'required|exists:products,id',
            'posm_type_id' => 'required|exists:posm_types,id',
            'visual_type_id' => 'required|exists:visual_types,id',
            'started_at' => 'required|date',
            'ended_at' => 'required|date',
            'banner_img' => 'nullable|file|mimes:pdf,jpg,jpeg|max:1024'
        ];
    }

    protected function failedValidation(Validator $validator)
    {
        throw new HttpResponseException($this->errorValidation($validator->getMessageBag()));
    }
}
