<?php

namespace App\Exports;

use App\Models\Selling;
use App\Models\SellingProduct;
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
        return SellingProduct::query()->with(['product', 'sell'])->completeRelation();
    }

    public function headings(): array
    {
        return [
            'Nama Sales',
            'TSO',
            'Outlet',
            'Kode Outlet',
            'Tipe Outlet',
            'Account',
            'Channel',
            'Kota',
            'Category',
            'SKU Name',
            'Qty Order',
            'Harga',
            'Total',
            'Created At',
            'Ended At',
            'Duration',
            'Week'
        ];
    }

    public function map($selling): array
    {
        return [
            $selling->sell->user->name,
            $selling->sell->outlet->TSO,
            $selling->sell->outlet->name,
            $selling->sell->code,
            $selling->sell->outlet->tipe_outlet,
            $selling->sell->outlet->account,
            $selling->sell->outlet->channel->name,
            $selling->sell->outlet->city->name,
            $selling->product->category->name,
            $selling->product->sku,
            $selling->qty,
            $selling->price,
            $selling->total,
            $selling->sell->created_at,
            $selling->sell->ended_at,
            $selling->sell->duration,
            $selling->sell->week
        ];
    }

    public function styles(Worksheet $sheet)
    {
        $lastColumn = 'Q'; // Last column in our dataset
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