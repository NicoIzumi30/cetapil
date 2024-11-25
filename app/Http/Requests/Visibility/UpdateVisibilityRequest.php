<?php

namespace App\Http\Requests\Visibility;

use Illuminate\Foundation\Http\FormRequest;

class UpdateVisibilityRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;  // Ubah ke true
    }

    public function rules(): array
    {
        return [
            'city_id' => 'required|exists:cities,id',
            'outlet_id' => 'required|exists:outlets,id',
            'product_id' => 'required|exists:products,id',
            'program_date' => 'required|date',
            'visual_type_id' => 'required|exists:visual_types,id',
            'posm_type_id' => 'required|exists:posm_types,id',
            'banner' => 'nullable|image|mimes:jpeg,png,jpg  ',
        ];
    }

    public function messages()
    {
        return [
            'city_id.required' => 'Kabupaten/Kota wajib dipilih',
            'outlet_id.required' => 'Outlet wajib dipilih',
            'product_id.required' => 'Produk wajib dipilih',
            'program_date.required' => 'Tanggal program wajib diisi',
            'visual_type_id.required' => 'Jenis visual wajib dipilih',
            'posm_type_id.required' => 'Jenis POSM wajib dipilih',
            'banner.image' => 'File harus berupa gambar',
            'banner.mimes' => 'Format file harus jpeg, png, atau jpg',
            'banner.max' => 'Ukuran file maksimal 5MB',
        ];
    }
}