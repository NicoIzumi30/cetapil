<?php

namespace App\Http\Requests\ProductKnowledge;

use Illuminate\Foundation\Http\FormRequest;

class UpdateProductKnowledgeRequest extends FormRequest
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
            'channel_id' => 'required|exists:channels,id',
            'file_pdf' => 'nullable|file|mimes:pdf|max:10240',
            'file_video' => 'nullable|mimetypes:video/*|max:10240',
        ];
    }
}
