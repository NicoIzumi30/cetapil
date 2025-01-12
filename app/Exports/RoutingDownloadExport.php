<?php

namespace App\Exports;

use App\Models\Outlet;
use App\Traits\ExcelExportable;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use PhpOffice\PhpSpreadsheet\Style\Alignment;

class RoutingDownloadExport implements FromCollection, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    use ExcelExportable;

    protected $data;

    public function __construct($week = null, $region = null)
    {
        $this->data = $this->safeCollection(function () use ($week, $region) {
            $query = Outlet::with(['city.province', 'user', 'channel'])
                ->where('status', 'APPROVED')
                ->whereNull('deleted_at');

            if ($region && $region !== 'all') {
                $query->whereHas('city.province', function($q) use ($region) {
                    $q->where('id', $region);
                });
            }

            if ($week && $week !== 'all') {
                $query->whereHas('outletRoutings', function($q) use ($week) {
                    $q->where('week', $week);
                });
            }

            return $query->get();
        });
    }

    public function collection()
    {
        return $this->data;
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
        }, $outlet, 'routing');
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

    public function styles(Worksheet $sheet)
    {
        $this->applyDefaultStyles($sheet);
        
        $lastRow = $sheet->getHighestRow();

        // Specific column alignments
        // $sheet->getStyle("B2:B{$lastRow}")
        //     ->getAlignment()
        //     ->setHorizontal(Alignment::HORIZONTAL_CENTER);
        
        // $sheet->getStyle("C2:C{$lastRow}")
        //     ->getAlignment()
        //     ->setHorizontal(Alignment::HORIZONTAL_CENTER);
        
        // $sheet->getStyle("E2:O{$lastRow}")
        //     ->getAlignment()
        //     ->setHorizontal(Alignment::HORIZONTAL_CENTER);

        return [
            1 => ['font' => ['bold' => true]],
        ];
    }
}