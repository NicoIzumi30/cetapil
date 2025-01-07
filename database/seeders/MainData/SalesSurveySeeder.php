<?php

namespace Database\Seeders\MainData;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Carbon\Carbon;
use Faker\Factory as Faker;

class SalesSurveySeeder extends Seeder
{
    public function run()
    {
        $faker = Faker::create('id_ID');
        
        $salesActivityIds = DB::table('sales_activities')->pluck('id')->toArray();
        $surveyQuestionIds = DB::table('survey_questions')->pluck('id')->toArray();
        
        DB::beginTransaction();
        try {
            // Process in chunks of 1000
            for($i = 0; $i < 1000000; $i += 1000) {
                $surveys = [];
                foreach(range(1, min(1000, 1000000 - $i)) as $index) {
                    $surveys[] = [
                        'id' => Str::uuid(),
                        'sales_activity_id' => $faker->randomElement($salesActivityIds),
                        'survey_question_id' => $faker->randomElement($surveyQuestionIds),
                        'answer' => $faker->randomElement(['Yes', 'No']),
                        'created_at' => Carbon::now(),
                        'updated_at' => Carbon::now(),
                    ];
                }
                
                foreach(array_chunk($surveys, 100) as $chunk) {
                    DB::table('sales_surveys')->insert($chunk);
                }

                if($i % 50000 == 0) {
                    $this->command->info($i . ' Sales Surveys seeded');
                }
            }
            
            DB::commit();
            $this->command->info('1,000,000 Sales Surveys seeded successfully');
        } catch (\Exception $e) {
            DB::rollback();
            throw $e;
        }
    }
}