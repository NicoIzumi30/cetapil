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
            'Nama Outlet',
            'Nama Sales',
            'Kode Outlet',
            'Kategori Outlet',
            'Hari Kunjungan',
            'Cycle',
            'Tipe Minggu',
            'Channel',
            'Account',
            'Distributor',
            'TSO',
            'KAM',
            'Kota',
            'Alamat',
            'Longitude',
            'Latitude',
            'Created At',
            'Updated At'
        ];
    }

    public function map($outlet): array
    {
        return [
            $outlet->name,
            $outlet->user->name,
            $outlet->code,
            $outlet->category,
            getVisitDayByNumber($outlet->visit_day),
            $outlet->cycle,
            $outlet->week ?? "Tiap Minggu",
            $outlet->channel->name ?? '',
            $outlet->account,
            $outlet->distributor,
            $outlet->TSO,
            $outlet->KAM,
            $outlet->city->name ?? '',
            $outlet->address,
            $outlet->longitude,
            $outlet->latitude,
            $outlet->created_at->format('Y-m-d H:i:s'),
            $outlet->updated_at->format('Y-m-d H:i:s')
        ];
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
