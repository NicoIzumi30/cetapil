<?php

namespace App\Http\Requests\Routing;

use Illuminate\Foundation\Http\FormRequest;

class CreateOutletRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    protected function prepareForValidation()
    {
        if ($this->has('week')) {
            // Konversi format week untuk 1x2
            if ($this->cycle === '1x2') {
                $this->merge([
                    'week' => $this->week === '13' ? '1&3' : '2&4'
                ]);
            }
        }
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
            'longitude' => 'required|string',
            'latitude' => 'required|string', 
            'address' => 'nullable|string',
            'cycle' => 'required|in:1x1,1x2,1x4',
            'outlet_type' => 'required|string',
            'account_type' => 'required|string',
            'channel' => 'required|exists:channels,id',
            'product_category' => 'nullable|array',
            'product_category.*' => 'exists:categories,id',
            'survey' => 'required|array',
            'survey.*' => 'required|string',
            'av3m' => 'array',
            'av3m.*' => 'numeric|min:0'
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
            'user_id.required' => 'Sales harus dipilih',
            'user_id.exists' => 'Sales tidak valid',
            'city.required' => 'Kota harus dipilih',
            'city.exists' => 'Kota tidak valid',
            'code.required' => 'Kode outlet harus diisi',
            'code.unique' => 'Kode outlet sudah digunakan',
            'name.required' => 'Nama outlet harus diisi',
            'category.required' => 'Kategori harus dipilih',
            'visit_day.required' => 'Waktu kunjungan harus dipilih',
            'longitude.required' => 'Longitude harus diisi',
            'latitude.required' => 'Latitude harus diisi',
            'cycle.required' => 'Cycle harus dipilih',
            'cycle.in' => 'Cycle tidak valid',
            'outlet_type.required' => 'Tipe outlet harus diisi',
            'account_type.required' => 'Tipe akun harus diisi',
            'channel.required' => 'Channel harus dipilih',
            'channel.exists' => 'Channel tidak valid',
            'week.required' => 'Week harus dipilih untuk cycle 1x2 atau 1x4',
            'week.in' => 'Nilai Week tidak valid untuk cycle yang dipilih',
            'product_category.required' => 'Kategori produk harus dipilih',
            'survey.required' => 'Survey harus diisi',
            'survey.*.required' => 'Semua pertanyaan survey harus dijawab',
            'av3m.array' => 'Data AV3M harus dalam bentuk array',
            'av3m.*.numeric' => 'Nilai AV3M harus berupa angka',
            'av3m.*.min' => 'Nilai AV3M tidak boleh kurang dari 0'
        ];
    }
}
