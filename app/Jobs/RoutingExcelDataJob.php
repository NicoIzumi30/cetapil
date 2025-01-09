<?php 
namespace App\Jobs;

use App\Models\OutletRouting;
use Exception;
use App\Models\Outlet;
use Illuminate\Bus\Queueable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Queue\SerializesModels;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;

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

    public function handle()
    {
        try {
            DB::beginTransaction();
            $data = [];
            // Validate all data first
            foreach ($this->excelData as $key => $row) {
                array_push($data, $row);

                $user = getUserByName($row['nama_sales']);
                if (!$user) {
                    throw new Exception('Sales dengan nama : ' . $row['nama_sales'] .' tidak ditemukan di baris '. ($key + 2));
                }
                
                $city = getCityByName($row['kota']);
                if (!$city) {
                    throw new Exception('Kota dengan nama : ' . $row['kota'] .' tidak ditemukan di baris '. ($key + 2));
                }
                
                $channel = getChannelByName($row['channel']);
                if (!$channel) {
                    throw new Exception('Channel dengan nama : ' . $row['channel'] .' tidak ditemukan di baris '. ($key + 2));
                }
                
                $visitDay = getVisitDayByDay(strtoupper($row['hari']));
                if ($visitDay == null) {
                    throw new Exception('Hari Kunjungan dengan nama hari : ' . $row['hari'] .' tidak ditemukan di baris '. ($key + 2));
                }
            }

            // If validation passes, process the data
            collect($this->excelData)->chunk(50)->each(function ($chunk) {
                foreach ($chunk as $row) {
                    $user = getUserByName(ucwords($row['nama_sales']));
                    $city = getCityByName($row['kota']);
                    $channel = getChannelByName($row['channel']);
                    $visitDay = getVisitDayByDay(strtoupper($row['hari']));
                    
                    $outlet = getOutletByCode($row['kode_outlet']);
                    if (!$outlet) {
                        $outlet = Outlet::create([
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
                    }

                    OutletRouting::firstOrCreate([
                        'outlet_id' => $outlet->id,
                        'visit_day' => $visitDay,
                        'week' => $row['week'],
                    ]);
                }
            });

            DB::commit();
            
            return [
                "status" => "success",
                "message" => "Import berhasil",
                'data' => $this->excelData
            ];

        } catch (\Exception $e) {
            DB::rollBack();
            
            $data = [
                'FILE_NAME' => $this->fileName,
                'ERROR_MESSAGE' => $e->getMessage(),
                'ROW_DATA' => $row, // Tambahkan data row yang error
                'ROW_NUMBER' => $key + 2
            ];
            Log::channel('routingErrorLog')->error(json_encode($data));
            
            return [
                "status" => "error",
                "message" => $e->getMessage(),
                "debug_data" => $data 
            ];
        }
    }
}