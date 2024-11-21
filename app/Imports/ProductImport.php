<?php
namespace App\Imports;

use Symfony\Component\Clock\now;
use App\Jobs\ProductExcelDataJob;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

// ProductImport.php
class ProductImport implements ToCollection, WithHeadingRow
{
    public $response;
    public $fileName;

    public function __construct($fileName)
    {
        $this->fileName = $fileName;
    }

    public function collection(Collection $rows)
    {
        dispatch(new ProductExcelDataJob($rows, $this->fileName))->onConnection('sync');
        $this->response = ["status" => 'success', "message" => 'Success import.'];
    }
}