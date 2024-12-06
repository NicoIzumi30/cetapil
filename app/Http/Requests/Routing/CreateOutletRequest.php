<?php

namespace App\Http\Requests\Routing;

use Illuminate\Foundation\Http\FormRequest;

class CreateOutletRequest extends FormRequest
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
            'user_id' => 'required|exists:users,id',
            'category' => 'required|string',
            'visit_day' => 'required|integer|between:1,7',
            'cycle' => 'required|in:1x1,1x2',
            'week_type' => 'required_if:cycle,1x2|in:ODD,EVEN',
            'channel' => 'required|exists:channels,id',
            'product_category' => 'required|exists:categories,id',
            'longitude' => 'required|string',
            'latitude' => 'required|string',
            'city' => 'required|string|exists:cities,id',
            'address' => 'nullable|string',
            'code' => 'required|string|unique:outlets,code',
            // 'status' => 'required|in:APPROVED,PENDING,REJECTED',
            'img_front' => 'nullable|file|mimes:png,jpg,jpeg|max:1024',
            'img_banner' => 'nullable|file|mimes:png,jpg,jpeg|max:1024',
            'img_main_road' => 'nullable|file|mimes:png,jpg,jpeg|max:1024',
        ];
    }
}
