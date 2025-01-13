<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;

use Illuminate\Database\Seeder;
use Database\Seeders\MainData\{
    OutletSeeder,
    SalesActivitySeeder,
    SalesAvailabilitySeeder,
    SalesSurveySeeder,
    SalesVisibilitySeeder
};

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
    $this->call([
        ProvinceSeeder::class,
        CitySeeder::class,
        UserSeeder::class,
        CategorySeeder::class,
        ProductSeeder::class,
        OutletFormSeeder::class,
        VisibilitySeeder::class,
        SurveySeeder::class,
        ChannelSeeder::class,
        PowerSkuSeeder::class
    ]);
        // $this->call([
        //     // OutletSeeder::class,
        //     SalesActivitySeeder::class,
        //     SalesAvailabilitySeeder::class,
        //     SalesSurveySeeder::class,
        //     SalesVisibilitySeeder::class,
        // ]);

    }
}
