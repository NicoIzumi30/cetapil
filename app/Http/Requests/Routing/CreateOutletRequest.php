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


    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array 
    {
        return [
            // 'user_id' => 'required|exists:users,id',
            // 'city' => 'required|exists:cities,id',
            // 'code' => 'required|string|unique:outlets,code', 
            // 'name' => 'required|string',
            // 'category' => 'required|string',
            // 'visit_day' => 'required|array',
            // 'visit_day.*' => 'required|string|max:1', 
            // 'week' => 'required|array',
            // 'week.*' => 'required|string',
            // 'longitude' => 'nullable|string',
            // 'latitude' => 'nullable|string',
            // 'address' => 'nullable|string',
            // 'outlet_type' => 'required|string',
            // 'account_type' => 'required|string',
            // 'channel' => 'required|exists:channels,id',
            // 'product_category' => 'nullable|array',
            // 'product_category.*' => 'exists:categories,id',
            // 'survey' => 'required|array', 
            // 'survey.*' => 'required|string',
            // 'av3m' => 'array',
            // 'av3m.*' => 'numeric|min:0',
            // 'img_front' => 'required|file|mimes:png,jpg,jpeg|max:2048',
            // 'img_banner' => 'required|file|mimes:png,jpg,jpeg|max:2048',
            // 'img_main_road' => 'required|file|mimes:png,jpg,jpeg|max:2048',
        ];
    }

    public function messages()
    {
        return [
            // 'user_id.required' => 'Sales harus dipilih',
            // 'user_id.exists' => 'Sales tidak valid',
            // 'city.required' => 'Kota harus dipilih',
            // 'city.exists' => 'Kota tidak valid',
            // 'code.required' => 'Kode outlet harus diisi',
            // 'code.unique' => 'Kode outlet sudah digunakan',
            // 'name.required' => 'Nama outlet harus diisi',
            // 'category.required' => 'Kategori harus dipilih',
            // 'visit_day.required' => 'Waktu kunjungan harus dipilih',
            // 'visit_day.*.required' => 'Waktu kunjungan harus dipilih',
            // 'visit_day.*.string' => 'Format waktu kunjungan tidak valid',
            // 'week.required' => 'Week harus dipilih',
            // 'outlet_type.required' => 'Tipe outlet harus diisi',
            // 'account_type.required' => 'Tipe akun harus diisi',
            // 'channel.required' => 'Channel harus dipilih',
            // 'channel.exists' => 'Channel tidak valid',
            // 'product_category.required' => 'Kategori produk harus dipilih',
            // 'survey.required' => 'Survey harus diisi',
            // 'survey.*.required' => 'Semua pertanyaan survey harus dijawab',
            // 'av3m.array' => 'Data AV3M harus dalam bentuk array',
            // 'av3m.*.numeric' => 'Nilai AV3M harus berupa angka',
            // 'av3m.*.min' => 'Nilai AV3M tidak boleh kurang dari 0'
        ];
    }
}
