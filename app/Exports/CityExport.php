<?php

namespace App\Exports;

use App\Models\City;
use App\Traits\ExcelExportable;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class CityExport implements FromCollection, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    use ExcelExportable;

    public function collection()
    {
        return $this->safeCollection(function () {
            return City::with(['province'])
                ->orderBy('province_code')
                ->get();
        });
    }

    public function headings(): array
    {
        return [
            'Regional',
            'Nama Kota',
        ];
    }

    public function map($row): array
    {
        return $this->safeMap(function ($row) {
            return [
                $row->province->name ?? '',
                $row->name ?? ''
            ];
        }, $row, 'city');
    }

    public function styles(Worksheet $sheet)
    {
        // Use default styles from trait
        $this->applyDefaultStyles($sheet);
        
        // Override row height for this specific export
        $sheet->getDefaultRowDimension()->setRowHeight(20);

        return [
            1 => ['font' => ['bold' => true]],
        ];
    }
}