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
     */
    public function rules()
{
    return [
        'city_id' => 'required|exists:cities,id',
        'outlet_id' => 'required|exists:outlets,id',
        'user_id' => 'required|exists:users,id', // Tambahkan validasi user_id
        'product_id' => 'required|exists:products,id',
        'program_date' => 'required|date',
        'visual_type_id' => 'required|exists:visual_types,id',
        'posm_type_id' => 'required|exists:posm_types,id',
        'banner' => 'required|image|mimes:jpeg,png,jpg',
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
            'banner.required' => 'Banner wajib diunggah',
            'banner.image' => 'File harus berupa gambar',
            'banner.mimes' => 'Format file harus jpeg, png, atau jpg',
            'banner.max' => 'Ukuran file maksimal 5MB',
        ];
    }

    protected function prepareForValidation()
    {
        $this->merge([
            'program_date' => $this->input('program-date'),
            'visual_type_id' => $this->input('visual-campaign'),
            'posm_type_id' => $this->input('posm'),
            'product_id' => $this->input('sku'),
            'outlet_id' => $this->input('outlet-name'),
            'user_id' => $this->input('user_id'),  // Tambahkan ini
        ]);
    }
}
