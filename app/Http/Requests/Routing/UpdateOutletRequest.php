<?php

namespace App\Http\Requests\Routing;

use Illuminate\Validation\Rule;
use Illuminate\Foundation\Http\FormRequest;

class UpdateOutletRequest extends FormRequest
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
        $rules = [
            'user_id' => 'required|exists:users,id',
            'city' => 'required|exists:cities,id',
            'code' => 'required|string',
            'name' => 'required|string',
            'category' => 'required|string',
            'visit_day' => 'required|integer|between:1,7',
            'longitude' => 'required|string',
            'latitude' => 'required|string', 
            'address' => 'nullable|string',
            'cycle' => 'required|in:1x1,1x2,1x4',
            'outlet_type' => 'required|string',
            'account_type' => 'required|string',
            'channel' => 'required|exists:channels,id',
            'product_category' => 'nullable|array',
            'product_category.*' => 'exists:categories,id',
            'survey' => 'required|array',
            'survey.*' => 'required|string',
            'av3m' => 'array',
            'av3m.*' => 'numeric|min:0',
            'img_front' => 'nullable|file|mimes:png,jpg,jpeg|max:2048',
            'img_banner' => 'nullable|file|mimes:png,jpg,jpeg|max:2048',
            'img_main_road' => 'nullable|file|mimes:png,jpg,jpeg|max:2048',
        ];
    
        if ($this->input('cycle') === '1x4') {
            $rules['week'] = 'required|in:1,2,3,4';
        } elseif ($this->input('cycle') === '1x2') {
            $rules['week'] = 'required|in:13,24';
        }
    
        return $rules;
    }
}
