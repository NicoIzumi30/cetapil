<?php

namespace App\Http\Requests\Profile;

use Illuminate\Foundation\Http\FormRequest;

class UpdateProfileRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name' => 'string|max:255',
            'email' => 'email|unique:users,email,' . auth()->id(),
            'phone_number' => 'string|max:20',
        ];
    }

    public function messages(): array
    {
        return [
            'name.required' => 'Nama pengguna wajib diisi',
            'name.max' => 'Nama pengguna maksimal 255 karakter',
            'email.required' => 'Email wajib diisi',
            'email.email' => 'Format email tidak valid',
            'email.unique' => 'Email sudah digunakan',
            'phone_number.required' => 'Nomor telepon wajib diisi',
            'phone_number.max' => 'Nomor telepon maksimal 20 karakter',
        ];
    }
}

