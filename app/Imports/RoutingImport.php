<?php
namespace App\Imports;

use Symfony\Component\Clock\now;
use App\Jobs\RoutingExcelDataJob;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class RoutingImport implements ToCollection, WithHeadingRow
{
    public $response;
    public $fileName;

    public function __construct($fileName)
    {
        $this->fileName = $fileName;
    }

    public function collection(Collection $rows)
    {
        $job = new RoutingExcelDataJob($rows, $this->fileName);
        $result = $job->handle(); // Panggil handle() langsung daripada menggunakan dispatch_sync
        
        $this->response = $result; // Simpan seluruh response
    }
}