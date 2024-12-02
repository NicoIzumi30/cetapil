<?php 
namespace App\Jobs;

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
                    $user = getUserByName($row['nama_md']);
                    if(!$user) {
                        throw new Exception('User not found: ' . $row['nama_md']);
                    }
                    $city = getCityByName($row['kota']);
                    if(!$city) {
                        throw new Exception('City not found: ' . $row['kota']);
                    }
                    $channel = getChannelByName( $row['channel']);
                    if(!$channel) {
                        throw new Exception('Channel not found: '. $row['channel']);
                    }
                    $visitDay = getVisitDayByDay(strtoupper($row['hari_kunjungan']));
                    if($visitDay == null){
                        throw new Exception('Hari Kunjungan not found: '. $row['hari_kunjungan']);
                    }
                    if ($user && $city && $channel && $visitDay) {
                        $outlet = getOutletByName($row['nama_outlet']);
                        if(!$outlet) {
                            Outlet::create([
                                'user_id' => $user->id,
                                'city_id' => $city->id,
                                'code' => $row['kode_store'],
                                'name' => $row['nama_outlet'],
                                'category' => $row['kategori_outlet'],
                                'channel'=> $channel->id,
                                'visit_day' => $visitDay,
                                'longitude' => $row['longtitude'],
                                'latitude' => $row['latitude'],
                                'address' => $row['alamat'],
                                'status' => 'APPROVED',
                                'cycle' => $row['cycle'],
                                'week_type'=> $row['week_type'],

                            ]);
                        }
                    }
                } catch (\Exception $e) {
                    $errorRow = $key + 1;
                    $data = [
                        'FILE_NAME' => $this->fileName,
                        'ROW' => $errorRow,
                        'ERROR_MESSAGE' => $e->getMessage(),
                        'CHANNEL' => $row['channel'],
                        'USER' => $row['nama_md'],
                        'KOTA' => $row['kota'],
                    ];
                    Log::channel('routingErrorLog')->error(json_encode($data));
                }
            }
        });
    }
}