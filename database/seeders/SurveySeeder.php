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
                    'CETAPHIL Gentle Skin Cleanser 125 ML',
                    'CETAPHIL Gentle Skin Cleanser 500 ML',
                    'CETAPHIL Oily Skin Cleanser 125 ML',
                    'CETAPHIL Exfoliating Cleanser 178 ML',
                    'CETAPHIL MOISTURIZING LOTION 200 ML',
                    'Cetaphil Brightness Refresh Toner 150 ML'
                ],
                'Berapa harga POWER SKU di toko?' => [
                    'CETAPHIL Gentle Skin Cleanser 125 ML',
                    'CETAPHIL Gentle Skin Cleanser 500 ML',
                    'CETAPHIL Oily Skin Cleanser 125 ML',
                    'CETAPHIL Exfoliating Cleanser 178 ML',
                    'CETAPHIL MOISTURIZING LOTION 200 ML',
                    'Cetaphil Brightness Refresh Toner 150 ML'
                ],
                'Berapa harga kompetitor di toko?' => [
                    'Bioderma Sensibio H2O Micellar Water 100 ML',
                    'Bioderma Sensibio H2O Micellar Water 500 ML Pump',
                    'Bioderma Sensibio Defensive 40 ML Antioxidant Soothing Moisturizer',
                    'Bioderma Gel Moussant 200 ML Soothing Gentle Cleanser'
                ]
            ],
            'Visibility' => [
                'N' => [
                    'Rak Reguler: Apakah lokasi Cetaphil berada di Kategori Derma atau Sensitive Skin?',
                    'Rak Reguler: Apakah 6 Power SKU berada pada top level atau eye level?',
                    'Rak Reguler: Apakah Cetaphil memiliki shelf share sama atau lebih besar dari Bioderma?',
                    'Rak Reguler: Apakah Cetaphil memiliki POSM (shelftalker, wobbler, backwall, standee, dll) di toko?',
                    'Apakah Claim Cetaphil #1 MEREK DERMATOLOGIS terlihat di Rak Regular dan/atau secondary display di toko?',
                    'BHR: Apakah ada Penempatan Khusus untuk highlight BHR (glorifier,standee,backwall,COC,sample?',
                    'Apakah Cetaphil terdisplay di Lokasi selain rak regular dengan minimal 2 SKUs?'
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
                            ($categoryName === 'Recommndation' && $quest === 'Apakah ada produk detailing/training di 3 bulan terakhir ke 80% Apoteker atau Staff Toko?')) {
                            $type = 'bool';
                        }
                        $prod = Product::whereRaw('LOWER(`sku`) LIKE ? ', strtolower($quest).'%')->first();
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
