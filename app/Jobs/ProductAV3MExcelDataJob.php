<?php

namespace App\Jobs;

use Exception;
use App\Models\Av3m;
use App\Models\Product;
use Illuminate\Bus\Queueable;
use Illuminate\Support\Facades\Log;
use Illuminate\Queue\SerializesModels;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;

class ProductAV3MExcelDataJob implements ShouldQueue
{
   use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

   public $excelData;
   public $fileName;

   public function __construct($excelData, $fileName)
   {
       $this->excelData = $excelData;
       $this->fileName = $fileName;
   }

   private function processAv3m($outlet, $product, $value)
   {
       if ($outlet && $product) {
           $value = $value === null || $value === '' ? 0 : floatval($value);
           
           return Av3m::updateOrCreate(
               [
                   'outlet_id' => $outlet['id'],
                   'product_id' => $product->id
               ],
               ['av3m' => $value]
           );
       }
       return null;
   }

   public function handle(): void
   {
       collect($this->excelData)->chunk(50)->take(3)->each(function ($chunk) {
           foreach ($chunk as $key => $row) {
               try {
                   if (!isset($row['code_outlet'])) {
                       throw new Exception("Code outlet is missing");
                   }

                   $outlet = getOutletByCode($row['code_outlet']);
                   if (!$outlet) {
                       throw new Exception("Outlet not found for code: {$row['code_outlet']}");
                   }

                   foreach ($row as $key2 => $value) {
                       // Skip non-product columns
                       if (in_array($key2, ['code_outlet', 'nama_outlet'])) {
                           continue;
                       }

                       // Find product
                       $product = Product::select('id', 'sku')
                           ->whereRaw("REPLACE(LOWER(sku), ' ', '_') = ?", [strtolower($key2)])
                           ->first();

                       if (!$product) {
                           continue;
                       }

                       // Process AV3M data
                       $this->processAv3m($outlet, $product, $value);
                   }

               } catch (\Exception $e) {
                   Log::channel('productErrorLog')->error(json_encode([
                       'FILE_NAME' => $this->fileName,
                       'ROW' => $key + 1,
                       'ERROR_MESSAGE' => $e->getMessage(),
                       'CODE_OUTLET' => $row['code_outlet'] ?? 'unknown'
                   ]));
               }
           }
       });
   }
}