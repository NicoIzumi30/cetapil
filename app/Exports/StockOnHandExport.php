<?php 
namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromQuery;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithChunkReading;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class StockOnHandExport implements FromQuery, WithHeadings, WithMapping, WithChunkReading
{
    protected $query;

    public function __construct($query)
    {
        $this->query = $query;
    }

    public function query()
    {
        return $this->query;
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
            $row->created_at ? $row->created_at->format('Y-m-d H:i:s') : '-',
            $row->salesActivity && $row->created_at
                ? $row->created_at->addSeconds($row->salesActivity->time_availability)->format('Y-m-d H:i:s')
                : '-'
        ];
    }

    public function chunkSize(): int
    {
        return 2000; // Adjust chunk size based on server capacity
    }

    public function styles(Worksheet $sheet)
    {
        // Apply styles if needed
        $sheet->getStyle('A1:Z1')->getFont()->setBold(true);
    }
}
