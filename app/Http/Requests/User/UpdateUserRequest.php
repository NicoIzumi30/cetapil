<?php

namespace App\Http\Requests\User;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateUserRequest extends FormRequest
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
            'name' => 'required|string',
            'email' => [
                'required',
                Rule::unique('users')->ignore($this->user),
            ],
            'phone_number' => 'required',
            'role_id' => 'required|exists:roles,id',
            'longitude' => 'nullable|string',
            'latitude' => 'nullable|string',
            'city' => 'nullable|string|exists:cities,name',
            'region' => 'nullable|string',
            'address' => 'nullable|string',
            'permissions' => 'required|array',
            'permissions.*' => 'required|string|exists:permissions,name',
            'password' => 'nullable|string|min:8|confirmed',
        ];
    }
}
