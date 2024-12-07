<?php

namespace Database\Seeders;

use App\Models\Product;
use App\Models\PowerSku;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Schema;

class PowerSkuSeeder extends Seeder
{
    public function run(): void
    {
        Schema::disableForeignKeyConstraints();
        PowerSku::truncate();
        Schema::enableForeignKeyConstraints();

        $powerSkus = [
            'CETAPHIL Gentle Skin Cleanser 125ml',
            'CETAPHIL Gentle Skin Cleanser 500ml',
            'CETAPHIL Oily Skin Cleanser 125ml',
            'CETAPHIL Exfoliating Cleanser 178 ML',
            'CETAPHIL Moisturizing Lotion 200ml',
            'CETAPHIL Brightness Refresh Toner 150 ML'
        ];

        foreach ($powerSkus as $sku) {
            $product = Product::where('sku', 'like', "%$sku%")->first();
            if ($product) {
                PowerSku::create(['product_id' => $product->id]);
            }
        }
    }
}
