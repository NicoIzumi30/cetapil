<?php

namespace App\Http\Requests\PowerSku;

use Illuminate\Foundation\Http\FormRequest;

class CreatePowerSkuRequest extends FormRequest
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
            'power-sku-category_id' => 'required|exists:categories,id',
            'power-sku' => 'required|string|max:255|unique:products,sku',
        ];
    }

    public function messages(): array
    {
        return [
            'power-sku-category_id.required' => 'Kategori produk harus dipilih',
            'power-sku-category_id.exists' => 'Kategori produk tidak valid',
            'power-sku.required' => 'Power SKU harus diisi',
            'power-sku.max' => 'Power SKU maksimal 255 karakter'
        ];

    }
}
