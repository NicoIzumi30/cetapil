<?php

namespace Database\Seeders\MainData;

use Carbon\Carbon;
use App\Models\User;
use Faker\Factory as Faker;
use Illuminate\Support\Str;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class SalesActivitySeeder extends Seeder
{
    public function run()
    {
        $faker = Faker::create('id_ID');
        
        $outletIds = DB::table('outlets')->pluck('id')->toArray();
        $userIds = User::role('sales')->get()->pluck('id')->toArray();
        
        DB::beginTransaction();
        try {
            // Process in chunks of 1000
            for($i = 0; $i < 10000; $i += 1000) {
                $activities = [];
                foreach(range(1, min(1000, 10000 - $i)) as $index) {
                    $checkedIn = $faker->dateTimeBetween('-1 year', 'now');
                    $checkedOut = Carbon::parse($checkedIn)->addHours($faker->numberBetween(1, 4));
                    
                    $activities[] = [
                        'id' => Str::uuid(),
                        'outlet_id' => $faker->randomElement($outletIds),
                        'user_id' => $faker->randomElement($userIds),
                        'checked_in' => $checkedIn,
                        'checked_out' => $checkedOut,
                        'latitude' => $faker->latitude(-11, 6),
                        'longitude' => $faker->longitude(95, 141),
                        'radius' => $faker->numberBetween(1, 100),
                        'radius_status' => $faker->randomElement(['ONSITE', 'OFFSITE']),
                        'views_knowledge' => $faker->numberBetween(0, 100),
                        'time_availability' => $faker->numberBetween(5, 3000),
                        'time_visibility' => $faker->numberBetween(5, 3000),
                        'time_knowledge' => $faker->numberBetween(5, 3000),
                        'time_survey' => $faker->numberBetween(5, 3000),
                        'time_order' => $faker->numberBetween(5, 3000),
                        'status' => 'SUBMITTED',
                        'created_at' => Carbon::now(),
                        'updated_at' => Carbon::now(),
                    ];
                }
                
                foreach(array_chunk($activities, 100) as $chunk) {
                    DB::table('sales_activities')->insert($chunk);
                }
            }
            
            DB::commit();
            $this->command->info('10,000 Sales Activities seeded successfully');
        } catch (\Exception $e) {
            DB::rollback();
            throw $e;
        }
    }
}