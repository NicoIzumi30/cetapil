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
        return [
            'user_id' => 'required|exists:users,id',
            'city' => 'required|exists:cities,id',
            'code' => 'required|string|unique:outlets,code',
            'name' => 'required|string',
            'category' => 'required|string',
            'visit_day' => 'required|array',
            'visit_day.*' => 'required|string|max:1',
            'week' => 'required|array',
            'week.*' => 'required|string|in:1,2,3,4',
            'longitude' => 'nullable|string',
            'latitude' => 'nullable|string',
            'address' => 'nullable|string',
            'outlet_type' => 'required|string',
            'account_type' => 'required|string',
            'channel' => 'required|exists:channels,id',
            'product_category' => 'nullable|array',
            'product_category.*' => 'exists:categories,id',
        ];
    }

    public function messages()
    {
        return [
            'user_id.required' => 'Sales harus dipilih',
            'user_id.exists' => 'Sales tidak valid',
            'city.required' => 'Kota harus dipilih',
            'city.exists' => 'Kota tidak valid',
            'code.required' => 'Kode outlet harus diisi',
            'code.unique' => 'Kode outlet sudah digunakan',
            'name.required' => 'Nama outlet harus diisi',
            'category.required' => 'Kategori outlet harus dipilih',
            'visit_day.required' => 'Waktu kunjungan harus dipilih',
            'visit_day.array' => 'Format waktu kunjungan tidak valid',
            'visit_day.*.required' => 'Setiap waktu kunjungan harus diisi',
            'visit_day.*.string' => 'Format waktu kunjungan tidak valid',
            'visit_day.*.max' => 'Format waktu kunjungan tidak valid',
            'week.required' => 'Week harus dipilih',
            'week.array' => 'Format week tidak valid',
            'week.*.required' => 'Setiap week harus diisi',
            'week.*.string' => 'Format week tidak valid',
            'week.*.in' => 'Week harus bernilai 1-4',
            'outlet_type.required' => 'Tipe outlet harus diisi',
            'account_type.required' => 'Tipe akun harus diisi',
            'channel.required' => 'Channel harus dipilih',
            'channel.exists' => 'Channel tidak valid'
        ];
    }

    protected function failedValidation(Validator $validator)
    {
        throw new HttpResponseException($this->errorValidation($validator->getMessageBag()));
    }
}