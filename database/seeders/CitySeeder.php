<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class CitySeeder extends Seeder
{
    /**
     * Function to parse CSV file to array
     */
    private function csvToArray($filename, $header)
    {
        if (!file_exists($filename) || !is_readable($filename)) {
            return false;
        }
        
        $data = array();
        
        if (($handle = fopen($filename, 'r')) !== false) {
            while (($row = fgetcsv($handle)) !== false) {
                if (!empty($header)) {
                    if (count($header) != count($row)) {
                        continue;
                    }
                    $row = array_combine($header, $row);
                }
                $data[] = $row;
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
        $now = Carbon::now();
        $file = public_path().'/assets/csv/cities.csv';
        $header = ['code', 'province_code', 'name', 'lat', 'long'];
        
        // Menggunakan fungsi csvToArray yang sudah dibuat
        $data = $this->csvToArray($file, $header);
        
        if (!$data) {
            throw new \Exception("Failed to read CSV file: {$file}");
        }

        $data = array_map(function ($arr) use ($now) {
            $arr['meta'] = json_encode(['lat' => $arr['lat'], 'long' => $arr['long']]);
            unset($arr['lat'], $arr['long']);
            $arr['id'] = Str::uuid();
            return $arr + ['created_at' => $now, 'updated_at' => $now];
        }, $data);

        $collection = collect($data);

        foreach ($collection->chunk(50) as $chunk) {
            DB::table('cities')->insertOrIgnore($chunk->toArray());
        }
    }
}