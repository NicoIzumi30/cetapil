<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Schema;

class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // TRUNCATE the posm_types and visual_types table, comment this code if doesn't needed
        Schema::disableForeignKeyConstraints();
        Category::truncate();
        Schema::enableForeignKeyConstraints();

        $category_name = [
            'Baby',
            'BHR',
            'CLEANSER',
            'MOISTURIZER',
            'PRO AD',
            'SUN'
        ];

        foreach ($category_name as $category) {
            Category::create([
                'name' => $category
            ]);
        }
        $this->command->info('Category seeder run successfully');
    }
}
