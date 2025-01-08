<?php

namespace App\Http\Requests\Routing;

use Illuminate\Validation\Rule;
use Illuminate\Foundation\Http\FormRequest;

class UpdateOutletRequest extends FormRequest
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
        $outletId = $this->route('routing');
        
        return [
            'user_id' => 'required|exists:users,id',
            'city' => 'required|exists:cities,id',
            'code' => [
                'required',
                'string',
                Rule::unique('outlets', 'code')->ignore($outletId)
            ],
            'name' => 'required|string',
            'category' => 'required|string|in:MT,GT',
            'visit_day' => 'required|array',
            'visit_day.*' => 'required|integer|between:1,7',
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
            'survey' => 'nullable|array',
            'survey.*' => 'nullable|string',
            'av3m' => 'nullable|array',
            'av3m.*' => 'nullable|numeric|min:0',
            'img_front' => 'nullable|file|mimes:png,jpg,jpeg|max:2048',
            'img_banner' => 'nullable|file|mimes:png,jpg,jpeg|max:2048',
            'img_main_road' => 'nullable|file|mimes:png,jpg,jpeg|max:2048',
        ];
    }

    /**
     * Get custom validation messages.
     *
     * @return array
     */
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
            'category.in' => 'Kategori harus MT atau GT',
            'visit_day.required' => 'Waktu kunjungan harus dipilih',
            'visit_day.array' => 'Format waktu kunjungan tidak valid',
            'visit_day.*.required' => 'Setiap waktu kunjungan harus diisi',
            'visit_day.*.integer' => 'Format waktu kunjungan tidak valid',
            'visit_day.*.between' => 'Waktu kunjungan harus antara hari 1-7',
            'week.required' => 'Week harus dipilih',
            'week.array' => 'Format week tidak valid',
            'week.*.required' => 'Setiap week harus diisi',
            'week.*.in' => 'Week harus bernilai 1-4',
            'outlet_type.required' => 'Tipe outlet harus diisi',
            'account_type.required' => 'Tipe akun harus diisi',
            'channel.required' => 'Channel harus dipilih',
            'channel.exists' => 'Channel tidak valid',
            'product_category.*.exists' => 'Kategori produk tidak valid',
            'av3m.*.numeric' => 'Nilai AV3M harus berupa angka',
            'av3m.*.min' => 'Nilai AV3M tidak boleh kurang dari 0',
            'img_front.mimes' => 'Foto depan outlet harus berformat png, jpg, atau jpeg',
            'img_front.max' => 'Ukuran foto depan outlet maksimal 2MB',
            'img_banner.mimes' => 'Foto banner harus berformat png, jpg, atau jpeg',
            'img_banner.max' => 'Ukuran foto banner maksimal 2MB',
            'img_main_road.mimes' => 'Foto jalan utama harus berformat png, jpg, atau jpeg',
            'img_main_road.max' => 'Ukuran foto jalan utama maksimal 2MB',
        ];
    }
}