<?php

namespace App\Exports;

use App\Models\Outlet;
use App\Traits\ExcelExportable;
use Maatwebsite\Excel\Concerns\FromQuery;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\WithChunkReading;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class OutletExport implements FromQuery, WithHeadings, WithMapping, WithStyles, WithChunkReading
{
    use ExcelExportable;

    protected int $chunkSize = 1000;

    public function __construct()
    {
        $this->useAlternatingRows = true;
    }

    public function query()
    {
        return Outlet::query()
            ->select([
                'outlets.id',
                'outlets.name',
                'outlets.category',
                'outlets.account',
                'outlets.TSO',
                'outlets.KAM',
                'outlets.address',
                'outlets.longitude',
                'outlets.latitude',
                'outlets.user_id',
                'outlets.city_id',
                'outlets.channel_id'
            ])
            ->with([
                'user:id,name',
                'city:id,name',
                'channel:id,name'
            ])
            ->orderBy('name');
    }

    public function headings(): array
    {
        return [
            'Nama Sales',
            'Kota',
            'Nama Outlet',
            'Kode Outlet',
            'Week',
            'Hari',
            'Kategori Outlet',
            'Tipe Outlet',
            'Channel',
            'Account',
            'Distributor',
            'TSO',
            'KAM',
            'Alamat',
            'Longitude',
            'Latitude',
        ];
    }

    public function map($outlet): array
    {
        return $this->safeMap(function ($outlet) {
            return [
                $outlet->user->name ?? '-',
                $outlet->city->name ?? '-',
                $outlet->name,
                $outlet->code,
                getWeeks($outlet->id),
                getVisitDays($outlet->id),
                $outlet->category,
                $outlet->tipe_outlet,
                $outlet->channel->name ?? '',
                $outlet->account,
                $outlet->distributor,
                $outlet->TSO,
                $outlet->KAM,
                $outlet->address,
                $outlet->longitude,
                $outlet->latitude,
            ];
        }, $outlet, 'Outlet Export');
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