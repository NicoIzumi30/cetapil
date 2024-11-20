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
                    'price_md' => '40000',
                    'price_sales' => '30000',
                ],
                [
                    'sku' => 'CETAPHIL GENTLE SKIN CLEANSER 1000 ML',
                    'price_md' => '40000',
                    'price_sales' => '30000',
                ],
                [
                    'sku' => 'CETAPHIL GENTLE SKIN CLEANSER 125 ML',
                    'price_md' => '40000',
                    'price_sales' => '30000',
                ],
                [
                    'sku' => 'CETAPHIL GENTLE SKIN CLEANSER 250 ML',
                    'price_md' => '40000',
                    'price_sales' => '30000',
                ],
                [
                    'sku' => 'CETAPHIL GENTLE SKIN CLEANSER 500 ML',
                    'price_md' => '40000',
                    'price_sales' => '30000',
                ],
                [
                    'sku' => 'CETAPHIL GENTLE SKIN CLEANSER 59 ML',
                    'price_md' => '40000',
                    'price_sales' => '30000',
                ],
                [
                    'sku' => 'CETAPHIL OILY SKIN CLEANSER 125 ML',
                    'price_md' => '40000',
                    'price_sales' => '30000',
                ],
                [
                    'sku' => 'CETAPHIL ULTRA GENTLE BODY WASH 500 ML',
                    'price_md' => '40000',
                    'price_sales' => '30000',
                ],
            ],
            'BHR' => [
                [
                    'sku' => 'Cetaphil Brightening Body Lotion 245 ML',
                    'price_md' => '50000',
                    'price_sales' => '10000',
                ],
                [
                    'sku' => 'Cetaphil Brightening Day Protection Cream SPF 50 ML',
                    'price_md' => '50000',
                    'price_sales' => '10000',
                ],
                [
                    'sku' => 'Cetaphil Brightening Night Nourishing Cream 50 ML',
                   'price_md' => '50000',
                    'price_sales' => '10000',
                ],
                [
                    'sku' => 'Cetaphil Brightness Refresh Toner 150 ML',
                    'price_md' => '50000',
                    'price_sales' => '10000',
                ],
                [
                    'sku' => 'Cetaphil Brightness Reveal Body Wash 245 ML',
                    'price_md' => '50000',
                    'price_sales' => '10000',
                ],
                [
                    'sku' => 'Cetaphil Brightness Reveal Creamy Cleanser 100 ML',
                   'price_md' => '50000',
                    'price_sales' => '10000',
                ],
            ],
            'Baby Calendula' => [
                [
                    'sku' => 'Cetaphil Baby Daily Lotion with Organic Calendula 400 ML',
                    'price_md' => '100000',
                    'price_sales' => '20000',
                ],
                [
                    'sku' => 'Cetaphil Baby Diaper Cream with Organic Calendula 70G',
                    'price_md' => '100000',
                    'price_sales' => '20000',
                ],
                [
                    'sku' => 'Cetaphil Baby Wash & Shampoo with Organic Calendula 230 ML',
                    'price_md' => '100000',
                    'price_sales' => '20000',
                ],
                [
                    'sku' => 'Cetaphil Baby Wash & Shampoo with Organic Calendula 400 ML',
                    'price_md' => '100000',
                    'price_sales' => '20000',
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
