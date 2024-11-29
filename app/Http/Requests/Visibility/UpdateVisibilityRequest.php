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
            'started_at' => 'required|date',
            'ended_at' => 'required|date|after_or_equal:started_at',
            'visual_type_id' => 'required|exists:visual_types,id',
            'posm_type_id' => 'required|exists:posm_types,id',
            'filename' => 'nullable|image|mimes:jpeg,png,jpg',
        ];
    }

    public function messages()
    {
        return [
            'city_id.required' => 'Kabupaten/Kota wajib dipilih',
            'outlet_id.required' => 'Outlet wajib dipilih',
            'product_id.required' => 'Produk wajib dipilih',
            'started_at.required' => 'Tanggal mulai program wajib diisi',
            'ended_at.required' => 'Tanggal selesai program wajib diisi', 
            'ended_at.after_or_equal' => 'Tanggal selesai harus setelah atau sama dengan tanggal mulai',
            'visual_type_id.required' => 'Jenis visual wajib dipilih',
            'posm_type_id.required' => 'Jenis POSM wajib dipilih',
            'filename.image' => 'File harus berupa gambar',
            'filename.mimes' => 'Format file harus jpeg, png, atau jpg',
            'filename.max' => 'Ukuran file maksimal 5MB',
        ];
    }
}
