<?php

namespace App\Exports;

use App\Traits\ExcelExportable;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\WithChunkReading;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class StockOnHandExport implements FromCollection, WithHeadings, WithMapping, WithStyles, WithChunkReading
{
    use ExcelExportable;

    protected $data;
    protected int $chunkSize = 1000;

    public function __construct($data)
    {
        $this->data = $data;
        $this->useAlternatingRows = true;
    }

    public function collection()
    {
        return $this->data;
    }

    public function headings(): array
    {
        return [
            'Nama Sales', 'Outlet', 'Kode Outlet', 'Tipe Outlet',
            'Kota/Area', 'Account', 'Channel', 'TSO', 'SKU',
            'Stock On-Shelf (in pcs)', 'Stock Inventory (in pcs)',
            'Availability', 'AV3M', 'Rekomendasi', 'Keterangan',
            'Duration', 'Week', 'Created At', 'Ended At'
        ];
    }

    public function map($row): array
    {
        return $this->safeMap(function ($row) {
            return [
                $row->outlet->user->name ?? '-',
                $row->outlet->name ?? '-',
                $row->outlet->code ?? '-',
                $row->outlet->tipe_outlet ?? '-',
                $row->outlet->city->name ?? '-',
                $row->outlet->account ?? '-',
                $row->outlet->channel->name ?? '-',
                $row->outlet->TSO ?? '-',
                $row->product->sku ?? '-',
                $row->stock_on_hand ?? '0',
                $row->stock_inventory ?? '0',
                $row->availability ?? '-',
                $row->av3m ?? '0',
                $row->rekomendasi ?? '0',
                $row->status_ideal ?? '-',
                $row->salesActivity ? gmdate('H:i:s', $row->salesActivity->time_availability) : '-',
                $row->created_at ? $row->created_at->format('W') : '-',
                $this->formatDateTime($row->created_at),
                $row->created_at && $row->salesActivity ? 
                    $this->formatDateTime($row->created_at->addSeconds($row->salesActivity->time_availability)) : '-'
            ];
        }, $row, 'Stock On Hand Export');
    }

    public function styles(Worksheet $sheet)
    {
        $this->applyDefaultStyles($sheet);
    }

    public function chunkSize(): int
    {
        return $this->chunkSize;
    }
}