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
            'Ended At'
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
                ($row->stock_on_hand !== null) ? (string)$row->stock_on_hand : '0',
                ($row->stock_inventory !== null) ? (string)$row->stock_inventory : '0',
                ($row->availability !== null) ? (string)$row->availability : '0',
                ($row->av3m !== null) ? (string)$row->av3m : '0',
                ($row->rekomendasi !== null) ? (string)$row->rekomendasi : '0',
                $row->status_ideal ?? '',
                gmdate('H:i:s', $row->salesActivity->time_availability),
                $row->created_at->format('W'),
                $row->created_at ? $row->created_at->format('Y-m-d H:i:s') : '',
                $row->created_at->addSeconds($row->salesActivity->time_availability) ?? ''
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
        $lastRow = $sheet->getHighestRow();
        $lastColumn = $sheet->getHighestColumn();

        // Apply styling to entire worksheet (headers and content)
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
        $sheet->getDefaultRowDimension()->setRowHeight(25);

        return [
            1 => ['font' => ['bold' => true]],
        ];
    }
}
