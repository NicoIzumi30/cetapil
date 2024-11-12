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
        //  TRUNCATE the categories and products table, comment this code if doesn't needed
        Schema::disableForeignKeyConstraints();
        Category::truncate();
        Product::truncate();
        Schema::enableForeignKeyConstraints();

        $products = [
            'Cleanser' => [
                [
                    'sku' => 'CETAPHIL Exfoliating Cleanser 178 ML',
                    'average_stock' => 100,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'CETAPHIL GENTLE SKIN CLEANSER 1000 ML',
                    'average_stock' => 20,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'CETAPHIL GENTLE SKIN CLEANSER 125 ML',
                    'average_stock' => 0,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'CETAPHIL GENTLE SKIN CLEANSER 250 ML',
                    'average_stock' => 100,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'CETAPHIL GENTLE SKIN CLEANSER 500 ML',
                    'average_stock' => 100,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'CETAPHIL GENTLE SKIN CLEANSER 59 ML',
                    'average_stock' => 0,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'CETAPHIL OILY SKIN CLEANSER 125 ML',
                    'average_stock' => 100,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'CETAPHIL ULTRA GENTLE BODY WASH 500 ML',
                    'average_stock' => 10,
                    'filename' => null,
                    'path' => null
                ],
            ],
            'BHR' => [
                [
                    'sku' => 'Cetaphil Brightening Body Lotion 245 ML',
                    'average_stock' => 100,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'Cetaphil Brightening Day Protection Cream SPF 50 ML',
                    'average_stock' => 20,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'Cetaphil Brightening Night Nourishing Cream 50 ML',
                    'average_stock' => 0,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'Cetaphil Brightness Refresh Toner 150 ML',
                    'average_stock' => 100,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'Cetaphil Brightness Reveal Body Wash 245 ML',
                    'average_stock' => 100,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'Cetaphil Brightness Reveal Creamy Cleanser 100 ML',
                    'average_stock' => 0,
                    'filename' => null,
                    'path' => null
                ],
            ],
            'Baby Calendula' => [
                [
                    'sku' => 'Cetaphil Baby Daily Lotion with Organic Calendula 400 ML',
                    'average_stock' => 100,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'Cetaphil Baby Diaper Cream with Organic Calendula 70G',
                    'average_stock' => 20,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'Cetaphil Baby Wash & Shampoo with Organic Calendula 230 ML',
                    'average_stock' => 10,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'Cetaphil Baby Wash & Shampoo with Organic Calendula 400 ML',
                    'average_stock' => 50,
                    'filename' => null,
                    'path' => null
                ]
            ],
            'Baby Classic' => [
                [
                    'sku' => 'CETAPHIL BABY DAILY LOTION 400 ML',
                    'average_stock' => 100,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'CETAPHIL BABY GTL WASH & SHAMPOO 230 ML',
                    'average_stock' => 0,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'CETAPHIL BABY GTL WASH & SHAMPOO 400 ML',
                    'average_stock' => 100,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'CETAPHIL BABY MOIST BATH & WASH 230 ML',
                    'average_stock' => 20,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'Cetaphil Baby Moist Bath & Wash 400ML Pump',
                    'average_stock' => 50,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'CETAPHIL BABY SHAMPOO 200 ML',
                    'average_stock' => 0,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'Cetaphil Baby with Organic Calendula Advanced Protection Cream 85G',
                    'average_stock' => 10,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'CETAPHIL DAILY FACIAL MOIST SPF15 118 ML',
                    'average_stock' => 10,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'CETAPHIL UVA/UVB DEF SPF 50+/UVA28 50 ML',
                    'average_stock' => 0,
                    'filename' => null,
                    'path' => null
                ]
            ],
            'Moisturizer' => [
                [
                    'sku' => 'CETAPHIL DAILY ADV ULT HYDRA LOTION 85 G',
                    'average_stock' => 20,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'CETAPHIL MOISTURIZING CREAM 453 G',
                    'average_stock' => 40,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'CETAPHIL MOISTURIZING CREAM 100 G',
                    'average_stock' => 20,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'CETAPHIL MOISTURIZING LOTION 200 ML',
                    'average_stock' => 10,
                    'filename' => null,
                    'path' => null
                ],
                [
                    'sku' => 'CETAPHIL MOISTURIZING LOTION 59 ML',
                    'average_stock' => 0,
                    'filename' => null,
                    'path' => null
                ]
            ]
        ];

        foreach ($products as $key => $values) {
            $category = Category::create([
                'name' => $key
            ]);

            if (count($values)) {
                foreach ($values as $product) {
                    Product::create([
                        'category_id' => $category->id,
                        'sku' => $product['sku'],
                        'average_stock' => $product['average_stock'],
                        'filename' => $product['filename'],
                        'path' => $product['path']
                    ]);
                }
            }
        }

        $this->command->info('Product seeder run successfully');
    }
}
