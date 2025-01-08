<?php

namespace Database\Seeders\MainData;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Carbon\Carbon;
use Faker\Factory as Faker;

class OutletSeeder extends Seeder
{
    public function run()
    {
        $faker = Faker::create('id_ID');
        
        $userIds = DB::table('users')
    ->where('email', 'sales1@gmail.com')
    ->orWhere('email', 'sales2@gmail.com')
    ->pluck('id')
    ->toArray();
        $cityIds = DB::table('cities')->pluck('id')->toArray();
        $channelIds = DB::table('channels')->pluck('id')->toArray();

        DB::beginTransaction();
        try {
            $outlets = [];
            foreach(range(1, 2000) as $index) {
                $outlets[] = [
                    'id' => Str::uuid(),
                    'user_id' => $faker->randomElement($userIds),
                    'city_id' => $faker->randomElement($cityIds),
                    'channel_id' => $faker->randomElement($channelIds),
                    'code' => 'OUT' . $faker->unique()->numberBetween(1000, 9999),
                    'name' => $faker->company,
                    'tipe_outlet' => $faker->randomElement(['A', 'B','C','D']),
                    'account' => $faker->company,
                    'category' => $faker->randomElement(['GT', 'MT']),
                    'distributor' => $faker->company,
                    'TSO' => $faker->name,
                    'KAM' => $faker->name,
                    'longitude' => $faker->longitude(95, 141),
                    'latitude' => $faker->latitude(-11, 6),
                    'address' => $faker->address,
                    'status' => 'APPROVED',
                    'created_at' => Carbon::now(),
                    'updated_at' => Carbon::now(),
                ];
            }
            
            DB::table('outlets')->insert($outlets);
            DB::commit();
        } catch (\Exception $e) {
            DB::rollback();
            throw $e;
        }
    }
}