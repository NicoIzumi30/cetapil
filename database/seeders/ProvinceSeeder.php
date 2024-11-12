<?php

namespace Database\Seeders;

use Carbon\Carbon;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class ProvinceSeeder extends Seeder
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
        $now = Carbon::now();
        $file = public_path().'/assets/csv/provinces.csv';
        $header = ['code', 'name', 'lat', 'long'];
        $data = $this->csvToArray($file, $header);
        $data = array_map(function ($arr) use ($now) {
            $arr['meta'] = json_encode(['lat' => $arr['lat'], 'long' => $arr['long']]);
            unset($arr['lat'], $arr['long']);
            $arr['id'] = Str::uuid();
            return $arr + ['created_at' => $now, 'updated_at' => $now];
        }, $data);

        DB::table('provinces')->insertOrIgnore($data);
    }
}
