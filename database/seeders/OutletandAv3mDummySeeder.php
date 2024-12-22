<?php

namespace Database\Seeders;

use App\Models\Outlet;
use App\Models\Av3m;
use App\Models\Product;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Schema;

class OutletandAv3mDummySeeder extends Seeder
{
    public function run(): void
    {
        Schema::disableForeignKeyConstraints();
        Outlet::truncate();
        Av3m::truncate();
        Schema::enableForeignKeyConstraints();

        // Sample outlet data
        $outlets = [
            [
                'user_id' => '9dc8acdb-e5cb-4e78-9e10-46eba51c7fbd', // Replace with actual user_id
                'city_id' => '697aafa1-415c-432c-9e44-816feb50085a', // Replace with actual city_id
                'channel_id' => '9dc8aceb-4d13-4ad8-be1c-958160a05c74', // Replace with actual channel_id
                'code' => 'OUT001',
                'name' => 'Cetaphil Store Senopati',
                'category' => 'MT',
                'distributor' => 'PT Distributor A',
                'TSO' => 'John Doe',
                'KAM' => 'Jane Smith',
                'visit_day' => '1',
                'longitude' => '106.813999',
                'latitude' => '-6.225588',
                'address' => 'Jl. Senopati No. 123, Jakarta Selatan',
                'status' => 'APPROVED',
                'cycle' => '1x1',
                'week_type' => 'ODD',
            ],
            [
                'user_id' => '9dc8acdb-e5cb-4e78-9e10-46eba51c7fbd',
                'city_id' => '697aafa1-415c-432c-9e44-816feb50085a',
                'channel_id' => '9dc8aceb-4d13-4ad8-be1c-958160a05c74', // Replace with actual channel_id
                'code' => 'OUT002',
                'name' => 'Cetaphil Store Kemang',
                'category' => 'GT',
                'distributor' => 'PT Distributor B',
                'TSO' => 'Bob Wilson',
                'KAM' => 'Alice Brown',
                'visit_day' => '2',
                'longitude' => '106.814562',
                'latitude' => '-6.262341',
                'address' => 'Jl. Kemang Raya No. 45, Jakarta Selatan',
                'status' => 'APPROVED',
                'cycle' => '1x2',
                'week_type' => 'EVEN',
            ],
            [
                'user_id' => '9dc8acdb-e5cb-4e78-9e10-46eba51c7fbd',
                'city_id' => '697aafa1-415c-432c-9e44-816feb50085a',
                'channel_id' => '9dc8aceb-4d13-4ad8-be1c-958160a05c74', // Replace with actual channel_id
                'code' => 'OUT003',
                'name' => 'Cetaphil Store Kelapa Gading',
                'category' => 'MT',
                'distributor' => 'PT Distributor C',
                'TSO' => 'Charlie Brown',
                'KAM' => 'David Miller',
                'visit_day' => '3',
                'longitude' => '106.905877',
                'latitude' => '-6.159949',
                'address' => 'Mal Kelapa Gading, Jakarta Utara',
                'status' => 'APPROVED',
                'cycle' => '1x1',
                'week_type' => 'ODD',
            ],
        ];

        // Create outlets
        foreach ($outlets as $outletData) {
            $outlet = Outlet::create($outletData);

            // Get all products
            $products = Product::all();

            // Create av3m records for each product
            foreach ($products as $product) {
                Av3m::create([
                    'outlet_id' => $outlet->id,
                    'product_id' => $product->id,
                    'av3m' => rand(0, 50) // Random av3m value between 0 and 50
                ]);
            }
        }

        $this->command->info('Outlets and Av3m records created successfully!');
    }
}
