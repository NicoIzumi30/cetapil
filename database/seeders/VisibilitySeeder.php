<?php

namespace Database\Seeders;

use App\Models\PosmType;
use App\Models\VisualType;
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
        PosmType::truncate();
        VisualType::truncate();
        Schema::enableForeignKeyConstraints();

        $posm_types = [
            'Backwall / Wall Id',
            'Standee',
            'COC',
            'End Gondola',
            'Rak Regular',
        ];
        $visual_types = [
            '15 Ceremide',
            'Andien',
            'BHR',
            'Others',
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
