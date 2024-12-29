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
    public function rules()
    {
        $rules = [
            'select-input-survey-data' => 'required|in:power-sku,harga-kompetitor',
        ];

        if ($this->input('select-input-survey-data') === 'power-sku') {
            $rules['power-sku'] = 'required|exists:products,id';
            $rules['power-sku-category_id'] = 'required|exists:categories,id';
        }

        if ($this->input('select-input-survey-data') === 'harga-kompetitor') {
            $rules['product-competitor'] = 'required|string';
        }

        return $rules;
    }

    public function messages()
    {
        return [
            'select-input-survey-data.required' => 'Kategori survey harus dipilih',
            'select-input-survey-data.in' => 'Kategori survey tidak valid',
            'power-sku.required' => 'Power SKU harus dipilih',
            'power-sku.exists' => 'Power SKU tidak valid',
            'power-sku-category_id.required' => 'Kategori produk harus dipilih',
            'power-sku-category_id.exists' => 'Kategori produk tidak valid',
            'product-competitor.required' => 'Nama Produk harus diisi',
        ];
    }
}
