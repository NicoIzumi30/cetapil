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
            'Nama Sales',
            'Outlet',
            'Kota/Area',
            'Channel',
            'SKU',
            'Stock On-Hand',
            'Status',
            'AV3M',
            'Rekomendasi',
            'Keterangan',
            'Created At',
            'Updated At'
        ];
    }

    public function map($row): array
    {
        try {
            return [
                $row->outlet->user->name ?? 'N/A', // Nama Sales
                $row->outlet->name ?? 'N/A', // Outlet
                $row->outlet->city->name ?? 'N/A', // Kota/Area
                $row->outlet->channel->name ?? 'N/A', // Channel
                $row->product->sku ?? 'N/A', // SKU
                $row->availability_stock ?? '0', // Stock On-Hand
                $row->status == '1' ? 'YES' : 'NO', // Status
                $row->average_stock ?? '0', // AV3M
                $row->ideal_stock ?? '0', // Rekomendasi
                $row->detail ?? 'N/A', // Keterangan
                $row->created_at ? $row->created_at->format('Y-m-d H:i:s') : 'N/A', // Created At
                $row->updated_at ? $row->updated_at->format('Y-m-d H:i:s') : 'N/A'  // Updated At
            ];
        } catch (\Exception $e) {
            Log::error('Error in StockOnHandExport mapping', [
                'error' => $e->getMessage(),
                'row' => $row->id ?? 'unknown'
            ]);
            
            return array_fill(0, 12, 'Error');
        }
    }

    public function styles(Worksheet $sheet)
    {
        try {
            $lastRow = $sheet->getHighestRow();
            $lastCol = 'L'; // 12 columns A to L

            // Header styling
            $sheet->getStyle("A1:{$lastCol}1")->applyFromArray([
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

            // Data styling
            $sheet->getStyle("A2:{$lastCol}{$lastRow}")->applyFromArray([
                'borders' => [
                    'allBorders' => [
                        'borderStyle' => Border::BORDER_THIN,
                        'color' => ['rgb' => '000000'],
                    ],
                ],
                'alignment' => [
                    'vertical' => Alignment::VERTICAL_CENTER,
                ],
            ]);

            // Left align text columns
            $sheet->getStyle("A2:D{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_LEFT);
            $sheet->getStyle("E2:E{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_LEFT); // SKU
            
            // Center align numeric/status columns
            $sheet->getStyle("F2:L{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);

            // Set row height
            $sheet->getDefaultRowDimension()->setRowHeight(25);

            // Freeze panes
            $sheet->freezePane('A2');

            return [
                1 => ['font' => ['bold' => true]],
            ];
        } catch (\Exception $e) {
            Log::error('Error in StockOnHandExport styles', [
                'error' => $e->getMessage()
            ]);
            throw $e;
        }
    }
}