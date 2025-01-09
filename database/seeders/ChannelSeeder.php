<?php

namespace Database\Seeders;

use App\Models\Channel;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Schema;

class ChannelSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // TRUNCATE the posm_types and visual_types table, comment this code if doesn't needed
        Schema::disableForeignKeyConstraints();
        Channel::truncate();
        Schema::enableForeignKeyConstraints();

        $channel_name = [
            'Baby Special Stores',
            'Chain Pharmacy Store',
            'CLINIC',
            'Cosmetic Special Stores',
            'HFS (High frequency Store)/ GT Retailer Stores',
            'HOSPITAL',
            'HSM',
            'IP',
            'Minimart',
            'OTHERS',
            'Pure Players/Market Place'
        ];

        foreach ($channel_name as $channel) {
            Channel::create([
                'name' => $channel
            ]);
        }
        $this->command->info('Channer seeder run successfully');
    }
}
