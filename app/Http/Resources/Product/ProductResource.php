<?php

namespace App\Http\Resources\Product;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProductResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            // 'id' => $this->id,
            // 'sku' => $this->sku,
            // 'category' => $this->category->only('id', 'name'),
            // 'deleted_at' => $this->deleted_at
            'id' => $this->id,
            'sku' => $this->sku,
            'category' => $this->category->only('id', 'name'),
            'average_stock' => $this->average_stock,
            'md_price' => $this->md_price,
            'sales_price' => $this->sales_price,
            // 'product_account_type' => $this->accountType,
            // 'filename' => $this->filename,
            // 'path' => $this->path,
            // 'image' => $this->image,
            // 'deleted_at' => $this->deleted_at
        ];
    }
}
