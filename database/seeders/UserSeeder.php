<?php

namespace Database\Seeders;

use App\Models\Permission;
use App\Models\Role;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Schema;
use Faker\Factory as Faker;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
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

        $superadmin = Role::create([
            'name' => 'superadmin'
        ]);
        $admin = Role::create([
            'name' => 'admin'
        ]);
        $sales = Role::create(['name' => 'sales']);
        $merchandiser = Role::create(['name' => 'merchandiser']);
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
            Permission::create([
                'name' => $permission
            ]);
        }
        // Create User
        $users = [
            [
                'name' => 'Yuki Me',
                'email' => 'yuki@gmail.com',                
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

        $this->command->info('User seeder run successfully');
    }
}
