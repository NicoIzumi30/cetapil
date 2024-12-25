<?php

namespace Database\Seeders;

use App\Models\Product;
use App\Models\SurveyCategory;
use App\Models\SurveyQuestion;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Schema;

class SurveySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // TRUNCATE the survey_categories, survey_questions table, comment this code if doesn't needed
        Schema::disableForeignKeyConstraints();
        SurveyCategory::truncate();
        SurveyQuestion::truncate();
        Schema::enableForeignKeyConstraints();
        $categories = [
            'Availability' => [
                'Apakah POWER SKU tersedia di toko?' => [
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
                ],
                'Berapa harga POWER SKU di toko?' => [
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
                ],
                'Berapa harga kompetitor di toko?' => [
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
                ]
            ],
            'Visibility' => [
                'N' => [
                    "Rak Reguler: Apakah lokasi Cetaphil berada di Kategori Derma atau Sensitive Skin?",
                    "Rak Reguler: Apakah 6 Power SKU berada pada top level atau eye level?",
                    "Rak Reguler: Apakah Cetaphil memiliki POSM di regular shelf (Shelf talker, Wobbler, Header, Glorifier, dll) di toko?",
                    "Rak Reguler: Apakah Cetaphil memiliki shelf share sama atau lebih besar dari Cerave?",
                    "Apakah Claim Cetaphil #1 MEREK DERMATOLOGIS terlihat di Rak Regular dan/atau secondary display di toko?",
                    "Apakah Cetaphil memiliki secondary display di toko (Gondola, Standee, Stack Rack, CoC)",
                    "Apakah Cetaphil terdisplay di Lokasi selain rak regular dengan minimal 2 SKUs?",
                ]
            ],
            'Recommndation' => [
                'N' => [
                    'Apakah ada produk detailing/training di 3 bulan terakhir ke 80% Apoteker atau Staff Toko?',
                    'Berapa kali di Kuartal ini pernah dijalankan product detailing di toko ini?'
                ]
            ]
        ];

        foreach ($categories as $key => $values) {
            $categoryName = $key;
            if (count($values)) {
                foreach ($values as $key => $product) {
                    $categoryTitle = $key;
                    $category = SurveyCategory::create([
                        'name' => $categoryName,
                        'title' => $categoryTitle == 'N' ? null : $categoryTitle
                    ]);
                    foreach ($product as $quest) {
                        $type = 'text';
                        if (($categoryTitle === 'Apakah POWER SKU tersedia di toko?' || $categoryName === 'Visibility') ||
                            ($categoryName === 'Recommndation' && $quest === 'Apakah ada produk detailing/training di 3 bulan terakhir ke 80% Apoteker atau Staff Toko?')
                        ) {
                            $type = 'bool';
                        }
                        $prod = Product::whereRaw('LOWER(`sku`) LIKE ? ', strtolower($quest) . '%')->first();
                        $prod_id = null;
                        if ($prod) {
                            $prod_id = $prod->id;
                        }
                        SurveyQuestion::create([
                            'survey_category_id' => $category->id,
                            'product_id' => $prod_id,
                            'type' => $type,
                            'question' => $quest
                        ]);
                    }
                }
            }
        }

        $this->command->info('Survey seeder run successfully');
    }
}
