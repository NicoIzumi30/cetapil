<?php

namespace Database\Seeders\MainData;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Carbon\Carbon;
use Faker\Factory as Faker;

class SalesVisibilitySeeder extends Seeder
{
    public function run()
    {
        $faker = Faker::create('id_ID');
        
        $salesActivityIds = DB::table('sales_activities')->pluck('id')->toArray();
        $posmTypeIds = DB::table('posm_types')->pluck('id')->toArray();
        
        DB::beginTransaction();
        try {
            // Process in chunks of 1000
            for($i = 0; $i < 1000000; $i += 1000) {
                $visibilities = [];
                foreach(range(1, min(1000, 1000000 - $i)) as $index) {
                    $visibilities[] = [
                        'id' => Str::uuid(),
                        'sales_activity_id' => $faker->randomElement($salesActivityIds),
                        'category' => $faker->randomElement(['CORE', 'BABY', 'COMPETITOR']),
                        'type' => $faker->randomElement(['PRIMARY', 'SECONDARY', 'COMPETITOR']),
                        'position' => $faker->numberBetween(1, 10),
                        'posm_type_id' => $faker->randomElement($posmTypeIds),
                        'visual_type' => $faker->randomElement(['Poster', 'Banner', 'Shelf Display']),
                        'condition' => $faker->randomElement(['GOOD', 'BAD']),
                        'competitor_brand_name' => $faker->company,
                        'competitor_promo_mechanism' => $faker->text(100),
                        'competitor_promo_start' => $faker->dateTimeBetween('-1 month', '+1 month'),
                        'competitor_promo_end' => $faker->dateTimeBetween('+1 month', '+2 months'),
                        'shelf_width' => $faker->numberBetween(50, 200),
                        'shelving' => $faker->randomElement(['Top', 'Middle', 'Bottom']),
                        'has_secondary_display' => $faker->randomElement(['Y', 'N']),
                        'display_photo' => $faker->imageUrl(),
                        'display_photo_2' => $faker->imageUrl(),
                        'created_at' => Carbon::now(),
                        'updated_at' => Carbon::now(),
                    ];
                }
                
                foreach(array_chunk($visibilities, 100) as $chunk) {
                    DB::table('sales_visibilities')->insert($chunk);
                }

                if($i % 50000 == 0) {
                    $this->command->info($i . ' Sales Visibilities seeded');
                }
            }
            
            DB::commit();
            $this->command->info('1,000,000 Sales Visibilities seeded successfully');
        } catch (\Exception $e) {
            DB::rollback();
            throw $e;
        }
    }
}