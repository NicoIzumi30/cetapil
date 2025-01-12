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

class OutletFilteredExport implements FromCollection, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
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
    }

    public function styles(Worksheet $sheet)
    {
        $lastRow = $sheet->getHighestRow();
        $lastColumn = $sheet->getHighestColumn();

        // Apply styling to entire worksheet (headers and content)
        $sheet->getStyle("A1:{$lastColumn}{$lastRow}")->applyFromArray([
            'alignment' => [
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
