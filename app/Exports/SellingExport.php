<?php

namespace App\Exports;

use App\Models\Selling;
use Maatwebsite\Excel\Concerns\FromQuery;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\Fill;

class SellingExport implements FromQuery, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    public function query()
    {
        return Selling::with(['user', 'products.product']);
    }

    public function headings(): array
    {
        return [
            'Product',
            'Outlet',
            'Sales',
            'Stock',
            'Selling',
            'Balance',
            'Image URL'
        ];
    }

    public function map($selling): array
    {
        $rows = [];
        
        foreach ($selling->products as $product) {
            $rows[] = [
                $product->product->sku ?? 'N/A',
                $selling->outlet_name,
                $selling->user->name,
                $product->stock ?? 0,
                $product->selling ?? 0,
                $product->balance ?? 0,
                $selling->path ? url($selling->path) : 'N/A',
            ];
        }

        return $rows;
    }

    public function styles(Worksheet $sheet)
    {
        $lastColumn = 'G'; // Last column in our dataset
        $lastRow = $sheet->getHighestRow();

        // Header styles
        $sheet->getStyle("A1:{$lastColumn}1")->applyFromArray([
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
        $sheet->getStyle("A2:{$lastColumn}{$lastRow}")->applyFromArray([
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

        // Specific column alignments
        $sheet->getStyle("A2:A{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_LEFT); // Product
        $sheet->getStyle("B2:C{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_LEFT); // Outlet, Sales
        $sheet->getStyle("D2:F{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER); // Stock, Selling, Balance
        $sheet->getStyle("G2:G{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_LEFT); // Image URL

        // Alternate row colors for better readability
        for ($row = 2; $row <= $lastRow; $row++) {
            if ($row % 2 == 0) {
                $sheet->getStyle("A{$row}:{$lastColumn}{$row}")->applyFromArray([
                    'fill' => [
                        'fillType' => Fill::FILL_SOLID,
                        'startColor' => ['rgb' => 'F8F9FA'],
                    ],
                ]);
            }
        }

        // Set row height
        $sheet->getDefaultRowDimension()->setRowHeight(25);

        // Freeze panes
        $sheet->freezePane('A2');

        return [
            1 => ['font' => ['bold' => true]],
        ];
    }
}