<?php

namespace App\Exports;

use App\Models\City;
use Illuminate\Support\Facades\Log;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use Maatwebsite\Excel\Concerns\WithStyles;
use PhpOffice\PhpSpreadsheet\Style\Border;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithHeadings;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class CityExport implements FromCollection, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{

    public function __construct()
    {
        
    }

    public function collection()
    {
        return City::with(['province'])->orderBy('province_code')->get();
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
        try {
            return [
                $row->province->name ?? '',
                $row->name ?? ''
            ];
        } catch (\Exception $e) {
            Log::error('Error in City mapping', [
                'error' => $e->getMessage(),
                'row' => $row->id ?? 'unknown'
            ]);

            return array_fill(0, 12, 'Error');
        }
    }

    public function styles(Worksheet $sheet)
    {
        $lastRow = $sheet->getHighestRow();
        $lastColumn = $sheet->getHighestColumn();

        // Apply styling to entire worksheet (headers and content)
        $sheet->getStyle("A1:{$lastColumn}{$lastRow}")->applyFromArray([
            'alignment' => [
                'vertical' => Alignment::VERTICAL_CENTER,
                'wrapText' => true,
            ],
            'borders' => [
                'allBorders' => [
                    'borderStyle' => Border::BORDER_THIN,
                ],
            ],
        ]);

        // Additional header styling
        $sheet->getStyle("A1:{$lastColumn}1")->applyFromArray([
            'font' => [
                'bold' => true,
                'color' => ['rgb' => 'FFFFFF'],
            ],
            'fill' => [
                'fillType' => Fill::FILL_SOLID,
                'startColor' => ['rgb' => '4A90E2'],
            ],
        ]);

        // Set row height
        $sheet->getDefaultRowDimension()->setRowHeight(20);

        return [
            1 => ['font' => ['bold' => true]],
        ];
    }
}
