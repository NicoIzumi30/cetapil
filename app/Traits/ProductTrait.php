<?php

namespace App\Traits;

use App\Models\Product;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Support\Facades\DB;

trait ProductTrait
{
    public function getProductsWithAv3mFromOutletProduct(array $category_ids, string $outlet_id = null): Collection {

        $products = Product::query()
            ->select('id', 'sku', 'category_id','deleted_at')
            ->whereHas('outlets', function ($query) use ($outlet_id) {
                $query->where('outlet_id', $outlet_id);
            })
            ->whereIn('category_id', $category_ids)  // Menggunakan whereIn untuk array category_id
            ->with(['category:id,name'])
            ->get();
        return $products;
    }
}
