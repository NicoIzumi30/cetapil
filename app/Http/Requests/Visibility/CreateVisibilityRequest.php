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
        'user_id' => 'required|exists:users,id',
        'product_id' => 'required|exists:products,id',
        'started_at' => 'required|date_format:Y-m-d H:i:s',
        'ended_at' => 'required|date_format:Y-m-d H:i:s|after_or_equal:started_at',
        'visual_type_id' => 'required|exists:visual_types,id',
        'posm_type_id' => 'required|exists:posm_types,id',
        'filename' => 'required|image|mimes:jpeg,png,jpg',
    ];
}

public function messages()
{
    return [
        'city_id.required' => 'Kabupaten/Kota wajib dipilih',
        'outlet_id.required' => 'Outlet wajib dipilih',
        'product_id.required' => 'Produk wajib dipilih',
        'started_at.required' => 'Tanggal mulai program wajib diisi',
        'started_at.date_format' => 'Format tanggal mulai tidak valid',
        'ended_at.required' => 'Tanggal selesai program wajib diisi',
        'ended_at.date_format' => 'Format tanggal selesai tidak valid',
        'ended_at.after_or_equal' => 'Tanggal selesai harus setelah atau sama dengan tanggal mulai',
        'visual_type_id.required' => 'Jenis visual wajib dipilih',
        'posm_type_id.required' => 'Jenis POSM wajib dipilih',
        'filename.required' => 'Banner wajib diunggah',
        'filename.image' => 'File harus berupa gambar',
        'filename.mimes' => 'Format file harus jpeg, png, atau jpg',
    ];
}

protected function prepareForValidation()
{
    $this->merge([
        'visual_type_id' => $this->input('visual-campaign'),
        'posm_type_id' => $this->input('posm'),
        'product_id' => $this->input('sku'),
        'outlet_id' => $this->input('outlet-name'),
    ]);
}
}
