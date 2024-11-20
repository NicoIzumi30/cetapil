<?php 
namespace App\Jobs;

use App\Models\Product;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class ProductExcelDataJob implements ShouldQueue
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
        collect($this->excelData)->chunk(50)->each(function ($chunk) {
            foreach ($chunk as $key => $row) {
                $product = getProductBySku($row['produk_sku']);
                if (!$product) {
                    if ($row['kategori_produk']) {
                        $category = getCategoryByName($row['kategori_produk']);
                        if ($category) {
                            Product::create([
                                'category_id' => $category['id'],
                                'sku' => $row['produk_sku'],
                                'md_price' => $row['md_price'] ?? 0,
                                'sales_price' => $row['sales_price'] ?? 0,
                            ]);
                        } else {
                            $errorRow = $key + 1;
                            $data = [
                                'FILE_NAME' => $this->fileName,
                                'ROW' => $errorRow,
                                'KATEGORI_PRODUK' => $row['kategori_produk'],
                                'SKU' => $row['produk_sku']
                            ];
                            Log::channel('productErrorRowLog')->info(json_encode($data));
                        }
                    }
                } else {
                    $data = [
                        'FILE_NAME' => $this->fileName,
                        'KATEGORI_PRODUK' => $row['kategori_produk'],
                        'SKU' => $row['produk_sku']
                    ];
                    Log::channel('productExistsLog')->info(json_encode($data));
                }
            }
        });
    }
}