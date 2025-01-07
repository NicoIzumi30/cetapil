<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use Illuminate\Support\Facades\Log;

class Av3mTemplateExport implements FromCollection, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    protected $data;

    public function __construct($data)
    {
        $this->data = $data;
    }

    public function collection()
    {
        return $this->data;
    }

    public function headings(): array
    {
        $baseHeadings = [
            'Code Outlet',
            'Nama Outlet',
        ];

        // Parse the JSON data
        $products = json_decode(json_encode($this->data), true);

        // Get all product SKUs
        $productSkus = collect($products)->pluck('sku')->unique()->values()->toArray();

        return array_merge($baseHeadings, $productSkus);
    }

    public function map($row): array
    {
        try {
            // Get the total number of columns from headings
            $totalColumns = count($this->headings());

            // Create array filled with empty strings
            return array_fill(0, $totalColumns, '');
        } catch (\Exception $e) {
            Log::error('Error in Av3mExport mapping', [
                'error' => $e->getMessage(),
                'row' => $row->id ?? 'unknown'
            ]);

            // Return array of 'Error' with same length as headings
            return array_fill(0, count($this->headings()), 'Error');
        }
    }

    public function styles(Worksheet $sheet)
    {
        $lastRow = $sheet->getHighestRow();
        $lastColumn = $sheet->getHighestColumn();

        // Apply styles to all columns in header row and data
        $sheet->getStyle("A1:{$lastColumn}{$lastRow}")->applyFromArray([
            'alignment' => [
                'horizontal' => Alignment::HORIZONTAL_CENTER,
                'vertical' => Alignment::VERTICAL_CENTER,
                'wrapText' => true,
            ],
            'borders' => [
                'allBorders' => [
                    'borderStyle' => Border::BORDER_THIN,
                ],
            ],
        ]);

        // Header styling (first row)
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
