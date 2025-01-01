<?php

namespace App\Http\Requests\PowerSku;

use Illuminate\Foundation\Http\FormRequest;

class UpdatePowerSkuRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'edit-select-survey-data' => 'required|in:power-sku,harga-kompetitor',
            'edit-product-competitor' => 'required_if:edit-select-survey-data,harga-kompetitor',
            'edit-power-sku-category_id' => 'required_if:edit-select-survey-data,power-sku|exists:categories,id',
            'edit-power-sku' => 'required_if:edit-select-survey-data,power-sku|exists:products,id',
        ];
    }

    public function messages(): array
    {
        return [
            'edit-select-survey-data.required' => 'Kategori survey harus dipilih',
            'edit-select-survey-data.in' => 'Kategori survey tidak valid',
            'edit-product-competitor.required_if' => 'Nama produk kompetitor harus diisi',
            'edit-power-sku-category_id.required_if' => 'Kategori produk harus dipilih',
            'edit-power-sku.required_if' => 'Power SKU harus dipilih',
        ];
    }
}