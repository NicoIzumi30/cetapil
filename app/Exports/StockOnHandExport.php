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
            'Kode Outlet',
            'Tipe Outlet',
            'Kota/Area',
            'Account',
            'Channel',
            'TSO',
            'SKU',
            'Stock On-Shelf (in pcs)',
            'Stock Inventory (in pcs)',
            'Availability',
            'AV3M',
            'Rekomendasi',
            'Keterangan',
            'Duration',
            'Week',
            'Created At',
            'Updated At'
        ];
    }

    public function map($row): array
    {
        try {
            return [
                $row->outlet->user->name ?? '',
                $row->outlet->name ?? '', 
                $row->outlet->code ?? '', 
                $row->outlet->tipe_outlet ?? '', 
                $row->outlet->city->name ?? '', 
                $row->outlet->account ?? '', 
                $row->outlet->channel->name ?? '', 
                $row->outlet->TSO ?? '', 
                $row->product->sku ?? '', 
                $row->stock_on_hand ?? '0', 
                $row->stock_inventory ?? '0', 
                $row->availability ?? '0', // 
                 $row->av3m ?? '0', 
                $row->rekomendasi ?? '0', 
                $row->status_ideal ?? '', 
             '', 
             '', 
                $row->created_at ? $row->created_at->format('Y-m-d H:i:s') : '', 
                $row->updated_at ? $row->updated_at->format('Y-m-d H:i:s') : ''  
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
            $lastCol = 'S'; // 12 columns A to L

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