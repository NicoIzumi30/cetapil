<?php

namespace App\Http\Requests\Posm;

use Illuminate\Foundation\Http\FormRequest;

class CreateImagePOSM extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'backwall' => 'nullable|image', // 5MB
            'standee' => 'nullable|image',
            'glolifier' => 'nullable|image',
            'coc' => 'nullable|image',
            'posm_type_id' => 'exists:posm_types,id'
        ];
    }

    public function messages(): array
    {
        return [
            'backwall.image' => 'File backwall harus berupa gambar',
            'backwall.max' => 'Ukuran file backwall maksimal 5MB',
            'standee.image' => 'File standee harus berupa gambar',
            'standee.max' => 'Ukuran file standee maksimal 5MB',
            'glolifier.image' => 'File glolifier harus berupa gambar',
            'glolifier.max' => 'Ukuran file glolifier maksimal 5MB',
            'coc.image' => 'File coc harus berupa gambar',
            'coc.max' => 'Ukuran file coc maksimal 5MB',
            'posm_type_id.exists' => 'POSM type tidak ditemukan'
        ];
    }
}