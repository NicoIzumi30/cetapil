<?php

namespace Database\Seeders;

use Carbon\Carbon;
use App\Models\Role;
use App\Models\User;
use App\Models\Permission;
use Faker\Factory as Faker;
use Illuminate\Support\Arr;
use Illuminate\Support\Str;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Schema;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    private function csvToArray($filename, $header)
    {
        if (!file_exists($filename)) {
            $this->command->error("File tidak ditemukan: {$filename}");
            return false;
        }
        
        if (!is_readable($filename)) {
            $this->command->error("File tidak bisa dibaca: {$filename}");
            return false;
        }
        
        $data = array();
        
        if (($handle = fopen($filename, 'r')) !== false) {
            // Skip header row if exists
            fgetcsv($handle);
            
            $rowCount = 0;
            while (($row = fgetcsv($handle)) !== false) {
                if (!empty($header)) {
                    if (count($header) != count($row)) {
                        $this->command->warn("Baris ke-{$rowCount}: Jumlah kolom tidak sesuai. Diharapkan: " . count($header) . ", Didapat: " . count($row));
                        continue;
                    }
                    $row = array_combine($header, $row);
                }
                $data[] = $row;
                $rowCount++;
            }
            fclose($handle);
        }
        
        return $data;
    }
    public function run(): void
    {

        //  TRUNCATE the users, roles and permissions table, comment this code if doesn't needed
        Schema::disableForeignKeyConstraints();
        User::truncate();
        Role::truncate();
        Permission::truncate();
        Schema::enableForeignKeyConstraints();
        // Reset cached roles and permissions
        app()[\Spatie\Permission\PermissionRegistrar::class]->forgetCachedPermissions();

        $superadmin = Role::firstOrCreate([
            'name' => 'superadmin'
        ]);
        $admin = Role::firstOrCreate([
            'name' => 'admin'
        ]);
        $sales = Role::firstOrCreate(['name' => 'sales']);
        $merchandiser = Role::firstOrCreate(['name' => 'merchandiser']);
        $permissions = [
            'menu_report',
            'menu_product',
            'menu_visibility',
            'menu_user',

            'menu_outlet',
            'menu_routing',
            'menu_activity',
            'menu_selling',
        ];
       
        foreach ($permissions as $permission) {
            Permission::firstOrCreate([
                'name' => $permission
            ]);
        }
        // Create User
        $users = [
            [
                'name' => 'Teamate',
                'email' => 'teamate@gmail.com',                
                'password' => Hash::make('121233'),
                'phone_number' => '+62859126462972',
                'role' => $superadmin,
                'permission' => $permissions
            ],
            [
                'name' => 'Admin',
                'email' => 'admin@gmail.com',
                'password' => Hash::make('12345678'),
                'phone_number' => '+62859126462972',
                'role' => $admin,
                'permission' => $permissions
            ],
            [
                'name' => 'Sales 1',
                'email' => 'sales1@gmail.com',
                'password' => Hash::make('12345678'),
                'phone_number' => '+628123456789',
                'role' => $sales,
                'permission' => ['menu_outlet', 'menu_routing', 'menu_activity', 'menu_selling']
            ],
            [
                'name' => 'Sales 2',
                'email' => 'sales2@gmail.com',
                'password' => Hash::make('12345678'),
                'phone_number' => '+628123456789',
                'role' => $sales,
                'permission' => ['menu_outlet', 'menu_routing', 'menu_activity', 'menu_selling']
            ],

            [
                'name' => 'Merchandiser',
                'email' => 'merchandiser@gmail.com',
                'password' => Hash::make('12345678'),
                'phone_number' => '+62859126462972',
                'role' => $merchandiser,
                'permission' => ['menu_outlet', 'menu_routing', 'menu_activity', 'menu_selling']
            ],
        ];

        $faker = Faker::create();

        foreach ($users as $user) {
            $email = $user['email'];
            $userCheck = User::where('email', $email)->first();
            if ($userCheck) {
                continue;
            }else{
                $newUser = User::create([
                    'name' => $user['name'],
                    'email' => $user['email'],
                    'password' => $user['password'],
                    'phone_number' => $user['phone_number'],
                    'longitude' => $faker->longitude(),
                    'latitude' => $faker->latitude()
                ])->assignRole($user['role']);
    
                $newUser->givePermissionTo($user['permission']);
                $newUser->save();
            }
            
        }
        $now = Carbon::now();
        $file = public_path().'/assets/csv/pengguna.csv';
        $header = ['name', 'email', 'city'];
        $data = $this->csvToArray($file, $header);
        $data = array_map(function ($arr) use ($now) {
            $arr['permission'] = ['menu_outlet', 'menu_routing', 'menu_activity', 'menu_selling'];
            return $arr + ['created_at' => $now, 'updated_at' => $now];
        }, $data);
        foreach ($data as $user) {
            $newUser = User::create([
                'name' => ucwords($user['name']),
                'email' => $user['email'],
                'password' => Hash::make('12345678'),
                'phone_number' => '',
                'longitude' => null,
                'latitude' => null,
                'city' => $user['city'],
                'address' => null,
                'active' => 1,
                'region' => ''
            ])->assignRole($sales);
            $newUser->givePermissionTo($user['permission']);
            $newUser->save();
        }
        $this->command->info('User seeder run successfully');
    }
}
