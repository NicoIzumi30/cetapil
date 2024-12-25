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
            "CETAPHIL GENTLE SKIN CLEANSER 125 ML",
            "CETAPHIL GENTLE SKIN CLEANSER 250 ML",
            "CETAPHIL DAILY FACIAL CLEANSER 236ML",
            "CETAPHIL Exfoliating Cleanser 178 ML",
            "CETAPHIL HYDRATING FOAMING CREAM CLEANSER 236 ML",
            "CETAPHIL ULTRA GENTLE BODY WASH 500 ML",
            "Cetaphil Baby Daily Lotion with Organic Calendula 400 ml",
            "CETAPHIL BABY GTL WASH & SHAMPOO 400 ML",
            "Cetaphil Baby Wash & Shampoo with Organic Calendula 400 ml",
            "CETAPHIL BABY DAILY LOTION 400 ML",
            "Cetaphil Baby with Organic Calendula Advanced Protection Cream 85G",
            "CETAPHIL Sun SPF50+ Light Gel 50ml",
            "CETAPHIL MOISTURISING LOTION 237 ml",
            "CETAPHIL MOISTURIZING CREAM 100 G",
            "Cetaphil Brightness Reveal Creamy Cleanser 100ml",
        ];

        foreach ($powerSkus as $sku) {
            $product = Product::where('sku', 'like', "%$sku%")->first();
            if ($product) {
                PowerSku::create(['product_id' => $product->id]);
            }
        }
    }
}
