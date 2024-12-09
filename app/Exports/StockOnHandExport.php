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

class StockOnHandExport implements FromCollection, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
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
        return [
            'Outlet',
            'SKU',
            'Stock-on-Hand(pcs)',
            'Status',
            'AV3M',
            'Rekomendasi',
            'Keterangan'
        ];
    }

    public function map($row): array
    {
        try {
            return [
                $row->outlet->name,
                $row->product->sku,
                $row->availability_stock,
                $row->status == '1' ? 'YES' : 'NO',
                $row->average_stock,
                $row->ideal_stock,
                $row->detail
            ];
        } catch (\Exception $e) {
            Log::error('Error in StockOnHandExport mapping', [
                'message' => $e->getMessage(),
                'row_id' => $row->id ?? 'unknown'
            ]);
            throw $e;
        }
    }

    public function styles(Worksheet $sheet)
    {
        $lastRow = $sheet->getHighestRow();

        // Header styles
        $sheet->getStyle("A1:G1")->applyFromArray([
            'font' => [
                'bold' => true,
                'color' => ['rgb' => 'FFFFFF'],
            ],
            'fill' => [
                'fillType' => Fill::FILL_SOLID,
                'startColor' => ['rgb' => '4A90E2'],
            ],
            'alignment' => [
                'horizontal' => Alignment::HORIZONTAL_CENTER,
                'vertical' => Alignment::VERTICAL_CENTER,
            ],
        ]);

        // Data styles
        $sheet->getStyle("A2:G{$lastRow}")->applyFromArray([
            'alignment' => [
                'vertical' => Alignment::VERTICAL_CENTER,
            ],
            'borders' => [
                'allBorders' => [
                    'borderStyle' => Border::BORDER_THIN,
                    'color' => ['rgb' => '000000'],
                ],
            ],
        ]);

        // Align specific columns
        $sheet->getStyle("A2:A{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_LEFT); // Outlet left aligned
        $sheet->getStyle("B2:B{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_LEFT); // SKU left aligned
        $sheet->getStyle("C2:G{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER); // Other columns centered

        // Set row height
        $sheet->getDefaultRowDimension()->setRowHeight(25);

        // Freeze panes
        $sheet->freezePane('A2');

        // Auto-size columns
        foreach(range('A','G') as $column) {
            $sheet->getColumnDimension($column)->setAutoSize(true);
        }

        return [
            1 => ['font' => ['bold' => true]],
        ];
    }
}