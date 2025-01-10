<?php

namespace App\Exports;

use App\Models\Selling; // Changed from SellingProduct
use App\Traits\ExcelExportable;
use Maatwebsite\Excel\Concerns\FromQuery;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\WithChunkReading;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use Illuminate\Support\Facades\Log;

class SellingDownloadExport implements FromQuery, WithHeadings, WithMapping, WithStyles, WithChunkReading
{
    use ExcelExportable;

    protected $startDate;
    protected $endDate;
    protected $region;
    protected int $chunkSize = 1000;

    public function __construct($startDate = null, $endDate = null, $region = null)
    {
        $this->startDate = $startDate;
        $this->endDate = $endDate;
        $this->region = $region;
        $this->useAlternatingRows = true;
    }

    public function query()
    {
        $query = Selling::query()
            ->select([
                'sellings.id',
                'sellings.user_id',
                'sellings.outlet_id',
                'sellings.checked_in',
                'sellings.checked_out',
                'sellings.duration',
                'sellings.created_at'
            ])
            ->with([
                'user:id,name',
                'outlet:id,name,code,tipe_outlet,account,TSO,channel_id,city_id',
                'outlet.channel:id,name',
                'outlet.city:id,name,province_id',
                'outlet.city.province:id,code'
            ]);

        if ($this->startDate && $this->endDate) {
            $query->whereBetween('checked_in', [
                $this->startDate->startOfDay(),
                $this->endDate->endOfDay()
            ]);
        }

        if ($this->region && $this->region !== 'all') {
            $query->whereHas('outlet.city.province', function($q) {
                $q->where('code', $this->region);
            });
        }

        return $query->orderBy('created_at', 'desc');
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
            'Checked In',
            'Checked Out',
            'Duration',
            'Week'
        ];
    }

    public function map($selling): array
    {
        return $this->safeMap(function ($selling) {
            return [
                $selling->user->name ?? '',
                $selling->outlet->TSO ?? '',
                $selling->outlet->name ?? '',
                $selling->outlet->code ?? '',
                $selling->outlet->tipe_outlet ?? '',
                $selling->outlet->account ?? '',
                $selling->outlet->channel->name ?? '',
                $selling->outlet->city->name ?? '',
                $this->formatDateTime($selling->checked_in),
                $this->formatDateTime($selling->checked_out),
                $selling->duration ?? '',
                $selling->created_at ? $selling->created_at->format('W') : '-',
            ];
        }, $selling, 'Selling Export');
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