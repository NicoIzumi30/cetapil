<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Product;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Schema;

class ProductSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // TRUNCATE the categories and products table
        Schema::disableForeignKeyConstraints();
        Category::truncate();
        Product::truncate();
        Schema::enableForeignKeyConstraints();

        $products = [
            'Baby' => [
                ['sku' => 'CETAPHIL BABY DAILY LOTION 400 ML', 'price' => 146926],
                ['sku' => 'Cetaphil Baby Daily Lotion with Organic Calendula 400 ml', 'price' => 167794],
                ['sku' => 'Cetaphil Baby Diaper Cream with Organic Calendula 70G', 'price' => 84444],
                ['sku' => 'CETAPHIL BABY GTL WASH & SHAMPOO 230 ML', 'price' => 83837],
                ['sku' => 'CETAPHIL BABY GTL WASH & SHAMPOO 400 ML', 'price' => 122734],

                ['sku' => 'CETAPHIL BABY MOIST BATH & WASH 230 ML', 'price' => 94609],
                ['sku' => 'Cetaphil Baby Moist Bath & Wash 400ml Pump', 'price' => 156221],
                ['sku' => 'CETAPHIL BABY SHAMPOO 200 ML', 'price' => 75636],
                ['sku' => 'Cetaphil Baby Wash & Shampoo with Organic Calendula 230 ml', 'price' => 95473],
                ['sku' => 'Cetaphil Baby Wash & Shampoo with Organic Calendula 400 ml', 'price' => 138280],

                ['sku' => 'Cetaphil Baby with Organic Calendula Advanced Protection Cream 85G', 'price' => 71464],
            ],
            'BHR' => [
                ['sku' => 'Cetaphil Bright Healthy Radiance Gentle Renewing Cleanser 100', 'price' => 138566],
                ['sku' => 'CETAPHIL Bright Healthy Radiance Perfecting Serum 30ml', 'price' => 287790],
                ['sku' => 'CETAPHIL BRIGHT PR SHEET MASK 6X23 ML', 'price' => 197190],
                ['sku' => 'Cetaphil Brightening Body Lotion 245ml', 'price' => 207429],
                ['sku' => 'Cetaphil Brightening Day Protection Cream SPF 50ml', 'price' => 186686],

                ['sku' => 'Cetaphil Brightening Night Nourishing Cream 50ml', 'price' => 193600],
                ['sku' => 'Cetaphil Brightness Refresh Toner 150ml', 'price' => 145200],
                ['sku' => 'Cetaphil Brightness Reveal Creamy Cleanser 100ml', 'price' => 138286],
            ],
            'Cleanser' => [
                ['sku' => 'CETAPHIL DAILY FACIAL CLEANSER 236ML', 'price' => 144493],
                ['sku' => 'CETAPHIL Exfoliating Cleanser 178 ML', 'price' => 81689],
                ['sku' => 'CETAPHIL GENTLE SKIN CLEANSER 1000 ML', 'price' => 273216],
                ['sku' => 'CETAPHIL GENTLE SKIN CLEANSER 125 ML', 'price' => 62095],
                ['sku' => 'CETAPHIL GENTLE SKIN CLEANSER 250 ML', 'price' => 109392]
                ,
                ['sku' => 'CETAPHIL GENTLE SKIN CLEANSER 500 ML', 'price' => 172905],
                ['sku' => 'CETAPHIL GENTLE SKIN CLEANSER 59 ML', 'price' => 37775],
                ['sku' => 'CETAPHIL HYDRATING FOAMING CREAM CLEANSER 236 ML', 'price' => 112126],
                ['sku' => 'CETAPHIL OILY SKIN CLEANSER 125 ML', 'price' => 149266],
                ['sku' => 'CETAPHIL SOOTHING FOAM WASH 2600ML', 'price' => 216486],

                ['sku' => 'CETAPHIL ULTRA GENTLE BODY WASH 500 ML', 'price' => 81689],
            ],
            'Moisturizer' => [
                ['sku' => 'CETAPHIL DAILY ADV ULT HYDRA LOTION 85 G', 'price' => 95878],
                ['sku' => 'CETAPHIL MOISTURISING LOTION 237 ml', 'price' => 144493],
                ['sku' => 'CETAPHIL MOISTURIZING CREAM 453 G', 'price' => 242500],
                ['sku' => 'CETAPHIL MOISTURIZING CREAM 100 G', 'price' => 112770],
                ['sku' => 'CETAPHIL MOISTURIZING LOTION 200 ML', 'price' => 132703],
                
                ['sku' => 'CETAPHIL MOISTURIZING LOTION 59 ML', 'price' => 48254],
            ],
            'Sun Protect' => [
                ['sku' => 'CETAPHIL DAILY FACIAL MOIST SPF15 118 ML', 'price' => 153495],
                ['sku' => 'CETAPHIL UVA/UVB DEF SPF 50+/PA+33 50 ML', 'price' => 195541],
                ['sku' => 'CETAPHIL Sun SPF50+ Light Gel 50ml', 'price' => 244964],
                ['sku' => 'CETAPHIL UVA/UVB MOIST 255 ML', 'price' => 279583],
            ],
            'Pro AD' => [
                ['sku' => 'CETAPHIL PRO AD DERMA REPAIR CREAM 227 G', 'price' => 287684],
                ['sku' => 'CETAPHIL PRO AD DERMA SKIN RESTORING MOISTURIZER 145 ML', 'price' => 164573],
                ['sku' => 'CETAPHIL PRO AD DERMA WASH 295 ML', 'price' => 246041],
            ],
        ];

        foreach ($products as $categoryName => $values) {
            $category = Category::create([
                'name' => $categoryName
            ]);

            foreach ($values as $product) {
                Product::create([
                    'category_id' => $category->id,
                    'sku' => $product['sku'],
                    'price' => $product['price'],
                ]);
            }
        }

        $this->command->info('Product seeder run successfully');
    }
}
