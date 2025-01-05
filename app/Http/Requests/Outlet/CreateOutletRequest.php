<?php

namespace App\Http\Requests\Outlet;

use App\Traits\ResponseTrait;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;

class CreateOutletRequest extends FormRequest
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
        $rules = [
            'user_id' => 'required|exists:users,id',
            'city' => 'required|exists:cities,id',
            'code' => 'required|string|unique:outlets,code',
            'name' => 'required|string',
            'category' => 'required|string',
            'visit_day' => 'required|integer|between:1,7',
            'longitude' => 'nullable|string',
            'latitude' => 'nullable|string',
            'address' => 'nullable|string',
            'cycle' => 'required|in:1x1,1x2,1x4',
            'week' => 'required_if:cycle,1x2,1x4',
            'outlet_type' => 'required|string',
            'account_type' => 'required|string',
            'channel' => 'required|exists:channels,id',
            'product_category' => 'nullable|array',
            'product_category.*' => 'exists:categories,id',
        ];

        if ($this->input('cycle') === '1x4') {
            $rules['week'] = 'required|in:1,2,3,4';
        } elseif ($this->input('cycle') === '1x2') {
            $rules['week'] = 'required|in:13,24';
        }

        return $rules;
    }

    public function messages()
    {
        return [
            'week.required_if' => 'Week harus diisi ketika cycle adalah 1x2 atau 1x4',
            'week.in' => 'Nilai Week tidak valid untuk cycle yang dipilih',
        ];
    }

    protected function failedValidation(Validator $validator)
    {
        throw new HttpResponseException($this->errorValidation($validator->getMessageBag()));
    }
}
