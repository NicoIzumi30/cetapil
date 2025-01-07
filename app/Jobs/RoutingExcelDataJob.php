<?php 
namespace App\Jobs;

use App\Models\OutletRouting;
use Exception;
use App\Models\Outlet;
use Illuminate\Bus\Queueable;
use Illuminate\Support\Facades\Log;
use Illuminate\Queue\SerializesModels;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;

// ProductExcelDataJob.php
class RoutingExcelDataJob implements ShouldQueue
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
                    $user = getUserByName($row['nama_sales']);
                    if(!$user) {
                        throw new Exception('Sales dengan nama : ' . $row['nama_sales'] .' tidak ditemukan di baris '. $key);
                    }
                    $city = getCityByName($row['kota']);
                    if(!$city) {
                        throw new Exception('Kota dengan nama : ' . $row['kota'] .' tidak ditemukan di baris '. $key);
                    }
                    $channel = getChannelByName( $row['channel']);
                    if(!$channel) {
                        throw new Exception('Channel dengan nama : ' . $row['channel'] .' tidak ditemukan di baris '. $key);
                    }
                    $visitDay = getVisitDayByDay(strtoupper($row['hari']));
                    if($visitDay == null){
                        throw new Exception('Hari Kunjungan dengan nama hari : ' . $row['hari'] .' tidak ditemukan di baris '. $key);
                    }
                    if ($user && $city && $channel && $visitDay) {
                        $outlet = getOutletByCode($row['kode_outlet']);
                        if(!$outlet) {
                            $insert = Outlet::create([
                                'user_id' => $user->id,
                                'city_id' => $city->id,
                                'code' => $row['kode_outlet'],
                                'name' => $row['nama_outlet'],
                                'category' => $row['kategori_outlet'],
                                'channel_id'=> $channel->id,
                                'longitude' => null,
                                'latitude' => null,
                                'address' => $row['alamat'],
                                'status' => 'APPROVED',
                                'account' => $row['account'],
                                'distributor' => $row['distributor'],
                                'tipe_outlet' => $row['tipe_outlet'],
                                'TSO' => $row['tso'],
                                'KAM' => $row['kam'],
                            ]);
                            $outletId = $insert->id;
                            OutletRouting::create([
                                'outlet_id' => $outletId,
                                'visit_day' => $visitDay,
                                'week' => $row['week'],
                            ]);
                        }else{
                            $outletId = $outlet->id;
                            OutletRouting::firstOrCreate(
                                [
                                    'outlet_id' => $outletId,
                                    'visit_day' => $visitDay,
                                    'week' => $row['week'],
                                ]
                            );
                            
                        }
                    }
                } catch (\Exception $e) {
                    $errorRow = $key + 1;
                    $data = [
                        'FILE_NAME' => $this->fileName,
                        'ROW' => $errorRow,
                        'ERROR_MESSAGE' => $e->getMessage(),
                        'CHANNEL' => $row['channel'],
                        'USER' => $row['nama_sales'],
                        'KOTA' => $row['kota'],
                    ];
                    Log::channel('routingErrorLog')->error(json_encode($data));
                }
            }
        });
    }
}