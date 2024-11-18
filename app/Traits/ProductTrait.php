<?php

namespace App\Traits;

use App\Models\Product;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Support\Facades\DB;

trait ProductTrait
{
    public function getProductsWithAv3mFromOutletProduct(array $category_ids, string $outlet_id = null): Collection {
        $products = Product::query()
                    ->with(['category', 'accountType'])
                    ->whereIn('category_id', $category_ids)
                    ->leftJoin('outlet_products', function($join) use ($outlet_id) {
                        $join->on('products.id', '=', 'outlet_products.product_id')
                            ->where('outlet_products.outlet_id', '=', $outlet_id);
                    });

        $products->select(
            'products.id',
            'products.sku',
            DB::raw('
                CASE
                    WHEN outlet_products.id IS NOT NULL THEN outlet_products.av3m
                    ELSE products.average_stock
                END AS average_stock
            '),
            'category_id',
            'filename',
            'path'
        );

        return $products->get();
    }
}
