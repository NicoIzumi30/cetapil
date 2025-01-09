<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Product;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Schema;

class ProductSeeder extends Seeder
{

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
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // TRUNCATE the categories and products table
        Schema::disableForeignKeyConstraints();
        Product::truncate();
        Schema::enableForeignKeyConstraints();

        $file = public_path() . '/assets/csv/products.csv';
        $header = ['sku', 'category', 'price'];
        $data = $this->csvToArray($file, $header);
        $data = array_map(function ($arr) {
            return $arr;
        }, $data);

        foreach ($data as $product) {
            $category = getCategoryByName($product['category']);
            
            Product::create([
                'category_id' => $category->id,
                'sku' => $product['sku'],
                'price' => $product['price'],
            ]);
        }

        $this->command->info('Product seeder run successfully');
    }
}
