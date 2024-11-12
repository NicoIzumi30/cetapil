<?php

namespace Database\Seeders;

use App\Models\PosmType;
use App\Models\Visibility;
use App\Models\VisualType;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Schema;

class VisibilitySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // TRUNCATE the posm_types and visual_types table, comment this code if doesn't needed
        Schema::disableForeignKeyConstraints();
        Visibility::truncate();
        PosmType::truncate();
        VisualType::truncate();
        Schema::enableForeignKeyConstraints();

        $posm_types = [
            'Backwall',
            'Standee',
            'Glorifier',
            'COC'
        ];
        $visual_types = [
            'We do skin, you do you',
            'New soothing foam wash',
            'Bright Healty Radiance'
        ];

        foreach ($posm_types as $posm) {
            PosmType::create([
                'name' => $posm
            ]);
        }
        foreach ($visual_types as $visual) {
            VisualType::create([
                'name' => $visual
            ]);
        }

        $this->command->info('Visibility seeder run successfully');
    }
}
