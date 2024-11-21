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
                    if (!$product) {
                        if ($row['kategori_produk']) { 
                            $category = getCategoryByName($row['kategori_produk']);
                            if ($category) {
                                $product = Product::create([
                                    'category_id' => $category['id'],
                                    'sku' => $row['produk_sku'],
                                    'md_price' => $row['harga_md'] ?? 0,
                                    'sales_price' => $row['harga_sales'] ?? 0,
                                ]);
                            } else {
                                throw new Exception("Category not found: " . $row['kategori_produk']);
                            }
                        }
                    }

                    if ($product) {
                        $channelMappings = [
                            'av3m_chain_pharmacy' => 'Chain Pharmacy',
                            'av3m_minimarket' => 'Minimarket',
                            'av3m_hfs_atau_gt' => 'HFS/GT',
                            'av3m_hsm_hyper_suparmarket' => 'HSM (Hyper Suparmarket)'
                        ];

                        foreach ($channelMappings as $excelColumn => $channelName) {
                            if (isset($row[$excelColumn])) {
                                $channel = getChannelByName($channelName);
                                if ($channel) {
                                    Av3m::updateOrCreate(
                                        ['product_id' => $product->id, 'channel_id' => $channel['id']],
                                        ['av3m' => $row[$excelColumn]]
                                    );
                                } else {
                                    throw new Exception("Channel not found: " . $channelName);
                                }
                            }
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