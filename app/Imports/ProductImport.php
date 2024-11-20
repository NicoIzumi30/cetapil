<?php 
namespace App\Imports;

use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithHeadingRow;
use App\Jobs\ProductExcelDataJob;

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
        dispatch(new ProductExcelDataJob($rows, $this->fileName));
        $this->response = ["status" => 'success', "message" => 'Success import.'];
    }
}