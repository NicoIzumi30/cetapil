<?php

namespace App\Http\Requests\SalesActivity;

use App\Traits\ResponseTrait;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;

class SaveVisibilityRequest extends FormRequest
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
            'visibilities' => 'required|array',
            'visibilities.*.id' => 'required|exists:visibilities,id',
            'visibilities.*.condition' => 'required|in:GOOD,BAD',
            'visibilities.*.image' => 'required|file|mimes:png,jpg,jpeg',
        ];
    }

    protected function failedValidation(Validator $validator)
    {
        throw new HttpResponseException($this->errorValidation($validator->getMessageBag()));
    }
}
