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
                try {
                    $product = getProductBySku($row['produk_sku']);
                    if ($row['kategori_produk']) {
                        $category = getCategoryByName($row['kategori_produk']);
                        if ($category) {
                            if (!$product) {
                                $product = Product::create([
                                    'category_id' => $category['id'],
                                    'sku' => $row['produk_sku'],
                                    'price' => $row['harga'] ?? 0,
                                ]);
                            } else {
                                $product->update([
                                    'category_id' => $category['id'],
                                    'sku' => $row['produk_sku'],
                                    'price' => $row['harga'] ?? 0,
                                ]);

                            }
                        } else {
                            throw new Exception("Category not found: " . $row['kategori_produk']);
                        }
                    }


                } catch (\Exception $e) {
                    $errorRow = $key + 1;
                    $data = [
                        'FILE_NAME' => $this->fileName,
                        'ROW' => $errorRow,
                        'ERROR_MESSAGE' => $e->getMessage(),
                        'KATEGORI_PRODUK' => $row['kategori_produk'],
                        'SKU' => $row['produk_sku']
                    ];
                    Log::channel('productErrorLog')->error(json_encode($data));
                }
            }
        });
    }
}