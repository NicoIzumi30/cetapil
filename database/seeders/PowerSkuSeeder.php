<?php

namespace Database\Seeders;

use App\Models\Product;
use App\Models\PowerSku;
use App\Models\SurveyAvailability;
use App\Models\SurveyCategory;
use App\Models\SurveyQuestion;
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

            $surveyQuestionCategory1 = SurveyCategory::where('title', 'Apakah POWER SKU tersedia di toko?')->first()->id;
            $surveyQuestionCategory2 = SurveyCategory::where('title', 'Berapa harga POWER SKU di toko?')->first()->id;
            $product = Product::where('sku', 'like', "%$sku%")->first();
            if ($product) {
                // Apakah ada Power SKU di toko?
                $survey1 = SurveyQuestion::create([
                    'survey_category_id' => $surveyQuestionCategory1,
                    'type' => "bool",
                    'product_id' => $product->id,
                    'question' => $product->sku,
                ])->id;
                // Berapa harga POWER SKU di toko?
                $survey2 =  SurveyQuestion::create([
                    'survey_category_id' => $surveyQuestionCategory2,
                    'type' => "text",
                    'product_id' => $product->id,
                    'question' => $product->sku,
                ])->id;
                SurveyAvailability::create([
                    'category' => "Power SKU",
                    'survey_question_id' => $survey1,
                    'survey_question_id_2' => $survey2,
                    'product_id' => $product->id,
                    'product_name' => $product->sku,
                ]);
                PowerSku::create([
                    'product_id' => $product->id,
                ]);
            }
        }
    }
}
