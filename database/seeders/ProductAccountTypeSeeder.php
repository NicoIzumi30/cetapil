<?php

namespace Database\Seeders;

use App\Models\ProductAccountType;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Schema;

class ProductAccountTypeSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // TRUNCATE the product_account_types table, comment this code if doesn't needed
        Schema::disableForeignKeyConstraints();
        ProductAccountType::truncate();
        Schema::enableForeignKeyConstraints();

        $account_types = [
            'BABY SHOP - East',
            'COSMETIC STORE - East',
            'KIMIA FARMA',
            'K24',
            'MTI - EAST',
            'GUARDIAN',
            'WATSON',
            'MTI',
            'Boston',
            'HOKKY',
            'FARMERS / RANCH MARKET',
            'REMAJA SM',
            'VIVA'
        ];

        foreach ($account_types as $account_type) {
            ProductAccountType::create([
                'name' => $account_type,
                'average_stock' => 30
            ]);
        }

        $this->command->info('Product Account Type seeder run successfully');
    }
}
