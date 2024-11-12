<?php

namespace Database\Seeders;

use App\Models\OutletForm;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Schema;

class OutletFormSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // TRUNCATE the outlet_forms table, comment this code if doesn't needed
        Schema::disableForeignKeyConstraints();
        OutletForm::truncate();
        Schema::enableForeignKeyConstraints();

        $forms = [
            [
                'question' => 'Apakah outlet sudah menjual produk GIH',
                'type' => 'bool'
            ],
            [
                'question' => 'Berapa SKU GIH yang dijual',
                'type' => 'text'
            ],
            [
                'question' => 'Selling out GSC500 / week (in pcs)',
                'type' => 'text'
            ],
            [
                'question' => 'Selling out GSC1000 / week (in pcs)',
                'type' => 'text'
            ],
            [
                'question' => 'Selling out GSC 250 / week (in pcs)',
                'type' => 'text'
            ],
            [
                'question' => 'Selling out GSC 125 / week (in pcs)',
                'type' => 'text'
            ],
            [
                'question' => 'Selling out Oily 125 / week ( in psc)',
                'type' => 'text'
            ],
            [
                'question' => 'Selling out Wash & Shampo 400 ml / week (in pcs)',
                'type' => 'text'
            ],
            [
                'question' => 'Selling out Wash & Shampo Cal 400 ml / week (in pcs)',
                'type' => 'text'
            ],
            [
                'question' => 'Selling out Baby Lotion Cal 400ml / week (in pcs)',
                'type' => 'text'
            ],
            [
                'question' => 'Selling out Baby Lotion  400ml / week (in pcs)',
                'type' => 'text'
            ],
            [
                'question' => 'Selling out Baby Diaper Cal / week (in pcs)',
                'type' => 'text'
            ],
            [
                'question' => 'Selling out Baby Advance Protection Cream Cal / week (in pcs)',
                'type' => 'text'
            ],
            [
                'question' => 'Selling out BHR Night / week (in pcs)',
                'type' => 'text'
            ],
            [
                'question' => 'Selling out BHR Day Protection / week (in pcs)',
                'type' => 'text'
            ],
            [
                'question' => 'Selling out BHR Serum /week (in pcs)',
                'type' => 'text'
            ],
        ];

        foreach ($forms as $form) {
            OutletForm::create($form);
        }

        $this->command->info('Outlet Forms seeder run successfully');
    }
}
