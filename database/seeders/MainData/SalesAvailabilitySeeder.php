<?php

namespace Database\Seeders\MainData;

use App\Models\SalesAvailability;
use Carbon\Carbon;
use Faker\Factory as Faker;
use Illuminate\Support\Str;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class SalesAvailabilitySeeder extends Seeder
{
    public function run()
    {
        Schema::disableForeignKeyConstraints();
        SalesAvailability::truncate();
        Schema::enableForeignKeyConstraints();
        $faker = Faker::create('id_ID');
        
        $salesActivityIds = DB::table('sales_activities')->pluck('id')->toArray();
        $outletIds = DB::table('outlets')->pluck('id')->toArray();
        $productIds = DB::table('products')->pluck('id')->toArray();
        
        DB::beginTransaction();
        try {
            // Process in chunks of 1000
            for($i = 0; $i < 200000; $i += 1000) {
                $availabilities = [];
                foreach(range(1, min(1000, 200000 - $i)) as $index) {
                    $stock = $faker->numberBetween(0, 100);
                    $av3m = $faker->numberBetween(10, 50);
                    
                    $availabilities[] = [
                        'id' => Str::uuid(),
                        'sales_activity_id' => $faker->randomElement($salesActivityIds),
                        'outlet_id' => $faker->randomElement($outletIds),
                        'product_id' => $faker->randomElement($productIds),
                        'stock_on_hand' => $stock,
                        'stock_inventory' => $faker->numberBetween($stock - 10, $stock + 10),
                        'av3m' => $av3m,
                        'status' => $faker->randomElement(['IDEAL', 'MINUS', 'OVER']),
                        'rekomendasi' => $faker->numberBetween(-10, 20),
                        'availability' => $faker->randomElement(['Y', 'N']),
                        'created_at' => Carbon::now(),
                        'updated_at' => Carbon::now(),
                    ];
                }
                
                foreach(array_chunk($availabilities, 100) as $chunk) {
                    DB::table('sales_availabilities')->insert($chunk);
                }

                if($i % 10000 == 0) {
                    $this->command->info($i . ' Sales Availabilities seeded');
                }
            }
            
            DB::commit();
            $this->command->info('200,000 Sales Availabilities seeded successfully');
        } catch (\Exception $e) {
            DB::rollback();
            throw $e;
        }
    }
}