<?php

namespace App\Exports;

use App\Models\Outlet;
use App\Models\Product;
use App\Traits\ExcelExportable;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\FromQuery;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\WithChunkReading;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class Av3mExport implements FromQuery, WithHeadings, WithMapping, WithStyles, WithChunkReading
{
    use ExcelExportable;

    private Collection $products;
    private array $baseHeadings = ['Code Outlet', 'Nama Outlet'];
    protected int $chunkSize = 1000;

    public function __construct()
    {
        $this->products = Product::select('id', 'sku')->orderBy('sku')->get();
        $this->useAlternatingRows = true;
    }

    public function query()
    {
        return Outlet::query()
            ->select('outlets.id', 'outlets.code', 'outlets.name')
            ->whereExists(function ($query) {
                $query->select('outlet_id')
                    ->from('av3ms')
                    ->whereColumn('outlet_id', 'outlets.id');
            })
            ->orderBy('code');
    }

    public function headings(): array
    {
        return array_merge(
            $this->baseHeadings, 
            $this->products->pluck('sku')->unique()->values()->toArray()
        );
    }

    public function map($row): array
    {
        return $this->safeMap(function ($outlet) {
            return array_merge(
                [$outlet->code ?? '', $outlet->name ?? ''],
                $this->products->map(fn($product) => getAv3m($outlet->id, $product->id))->toArray()
            );
        }, $row, 'AV3M Export');
    }

    public function styles(Worksheet $sheet)
    {
        $this->applyDefaultStyles($sheet);
    }

    public function chunkSize(): int
    {
        return $this->chunkSize;
    }
}