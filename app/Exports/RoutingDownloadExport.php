<?php

namespace App\Exports;

use App\Models\Outlet;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\Alignment;

class RoutingDownloadExport implements FromCollection, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    protected $data;
    protected $minimumWidth = 10;
    protected $maximumWidth = 50;

    public function __construct($week = null, $region = null)
    {
        $query = Outlet::with(['city.province', 'user', 'channel_name'])
            ->where('status', 'APPROVED')
            ->whereNull('deleted_at');

        if ($region && $region !== 'all') {
            $query->whereHas('city.province', function($q) use ($region) {
                $q->where('id', $region);
            });
        }

        if ($week && $week !== 'all') {
            if (strpos($week, '&') !== false) {
                $weeks = explode('&', $week);
                $query->whereIn('week', $weeks);
            } else {
                $query->where('week', $week);
            }
        }

        $this->data = $query->get();
    }

    public function collection()
    {
        return $this->data;
    }

    public function map($outlet): array
    {
        try {
            return [
                $outlet->name,
                $outlet->user->name ?? 'N/A',
                $outlet->category,
                getVisitDayByNumber($outlet->visit_day),
                $outlet->cycle,
                $outlet->week,
                $outlet->channel_name->name ?? '',
                $outlet->account,
                $outlet->distributor,
                $outlet->TSO,
                $outlet->KAM,
                $outlet->city->name ?? 'N/A',
                $outlet->address,
                $outlet->longitude,
                $outlet->latitude,
            ];
        } catch (\Exception $e) {
            Log::error('Error mapping outlet:', [
                'error' => $e->getMessage(),
                'outlet_id' => $outlet->id ?? 'unknown'
            ]);
            return array_fill(0, 15, 'N/A');
        }
    }

    public function headings(): array
    {
        return [
            'Nama Outlet',
            'Nama Sales',
            'Kategori Outlet',
            'Hari Kunjungan',
            'Cycle',
            'Week',
            'Channel',
            'Account',
            'Distributor',
            'TSO',
            'KAM',
            'Kota',
            'Alamat',
            'Longitude',
            'Latitude',
        ];
    }

    public function styles(Worksheet $sheet)
    {
        $lastColumn = 'O'; // 15 columns (A to O)
        $lastRow = $sheet->getHighestRow();

        // Header styles
        $sheet->getStyle("A1:{$lastColumn}1")->applyFromArray([
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

        // Data styles
        $sheet->getStyle("A2:{$lastColumn}{$lastRow}")->applyFromArray([
            'alignment' => [
                'vertical' => Alignment::VERTICAL_CENTER,
            ],
            'borders' => [
                'allBorders' => [
                    'borderStyle' => Border::BORDER_THIN,
                    'color' => ['rgb' => '000000'],
                ],
            ],
        ]);

        // Optimal column width
        foreach (range('A', $lastColumn) as $column) {
            $sheet->getColumnDimension($column)->setAutoSize(true);
            $columnWidth = $sheet->getColumnDimension($column)->getWidth();

            if ($columnWidth < $this->minimumWidth) {
                $sheet->getColumnDimension($column)->setWidth($this->minimumWidth);
            } elseif ($columnWidth > $this->maximumWidth) {
                $sheet->getColumnDimension($column)->setWidth($this->maximumWidth);
                $sheet->getStyle($column . '1:' . $column . $lastRow)
                    ->getAlignment()
                    ->setWrapText(true);
            }
        }

        // Specific column alignments
        $sheet->getStyle("B2:B{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);
        $sheet->getStyle("C2:B{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);
        $sheet->getStyle("E2:{$lastColumn}{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);

        $sheet->getDefaultRowDimension()->setRowHeight(25);
        $sheet->freezePane('A2');

        return [
            1 => ['font' => ['bold' => true]],
        ];
    }
}