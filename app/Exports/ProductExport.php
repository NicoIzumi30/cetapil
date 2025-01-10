<?php

namespace App\Exports;

use App\Models\Product;
use App\Models\Channel;
use App\Traits\ExcelExportable;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class ProductExport implements FromCollection, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    use ExcelExportable;

    protected $channels;

    public function __construct()
    {
        $this->channels = Channel::orderBy('created_at')->get();
    }

    public function collection()
    {
        return $this->safeCollection(function () {
            return Product::with(['category', 'av3ms.channel'])->get();
        });
    }

    public function headings(): array
    {
        return [
            'Kategori Produk',
            'Produk SKU',
            'Harga',
        ];
    }

    public function map($product): array
    {
        return $this->safeMap(function ($product) {
            return [
                $product->category->name ?? 'Uncategorized',
                $product->sku,
                $this->formatCurrency($product->price),
            ];
        }, $product, 'product');
    }

    public function styles(Worksheet $sheet)
    {
        $this->applyDefaultStyles($sheet);

        $lastRow = $sheet->getHighestRow();

        $sheet->getStyle("B2:B{$lastRow}")
            ->getAlignment()
            ->setHorizontal(\PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_CENTER);

        $sheet->getStyle("C2:C{$lastRow}")
            ->getAlignment()
            ->setHorizontal(\PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_RIGHT);

        return [
            1 => ['font' => ['bold' => true]],
        ];
    }
}