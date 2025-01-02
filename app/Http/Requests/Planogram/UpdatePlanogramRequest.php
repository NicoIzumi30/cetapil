<?php

namespace App\Http\Requests\Planogram;

use Illuminate\Foundation\Http\FormRequest;

class UpdatePlanogramRequest extends FormRequest
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
            'channel' => 'required|exists:channels,id',
            'planogram_file' => 'required|file|max:2048|mimes:png,jpg,jpeg',
        ];
    }
}
