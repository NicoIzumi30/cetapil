<?php

namespace App\Http\Requests\Profile;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Hash;

class UpdatePasswordRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'current_password' => 'required',
            'new_password' => 'required|min:8|confirmed',
            'new_password_confirmation' => 'required'
        ];
    }

    public function messages(): array
    {
        return [
            'current_password.required' => 'Kata sandi lama harus diisi.',
            'new_password.required' => 'Kata sandi baru harus diisi.',
            'new_password.min' => 'Kata sandi baru minimal 6 karakter.',
            'new_password.confirmed' => 'Konfirmasi kata sandi baru tidak cocok.',
            'new_password_confirmation.required' => 'Konfirmasi kata sandi baru harus diisi.'
        ];
    }
}