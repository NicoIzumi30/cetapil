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

// ProductExcelDataJob.php
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

    public function handle(): void
    {
        collect($this->excelData)->chunk(50)->take(3)->each(function ($chunk) {
            foreach ($chunk as $key => $row) {
                try {
                    $outlet = getOutletByCode($row['code_outlet']);
                    $product2 = getProductBySku($row['product_sku']);
                    $product = getProductByCode($row['sku_code']);

                    if (!$outlet) {
                        throw new Exception("Outlet not found");
                    }
                    if($product){
                    Av3m::updateOrCreate(
                        [
                            'outlet_id' => $outlet['id'],
                            'product_id' => $product['id']
                        ],
                        [
                            'av3m' => $row['av3m']
                        ]
                    );
                }elseif($product2){
                    Av3m::updateOrCreate(
                        [
                            'outlet_id' => $outlet['id'],
                            'product_id' => $product2['id']
                        ],
                        [
                            'av3m' => $row['av3m']
                        ]
                    );
                }else{
                    throw new Exception("Product not found");
                }
                    Log::info('Error in ProductAV3MExcelDataJob', [
                        'FILE_NAME' => $this->fileName,
                        'ROW' => $key + 1,
                        'product_sku' => $row['product_sku'],
                        'av3m' => $row['av3m'],
                        'code_outlet' => $row['code_outlet'],
                        'sku_code' => $row['sku_code']
                    ]);

                } catch (\Exception $e) {
                    $errorRow = $key + 1;
                    $data = [
                        'FILE_NAME' => $this->fileName,
                        'ROW' => $errorRow,
                        'ERROR_MESSAGE' => $e->getMessage(),
                        'CODE_OUTLET' => $row['code_outlet'],
                        'SKU' => $row['product_sku'],
                        'AV3M' => $row['av3m'],
                        'SKU_CODE' => $row['sku_code']
                    ];
                    Log::channel('productErrorLog')->error(json_encode($data));
                }
            }
        });
    }
}
