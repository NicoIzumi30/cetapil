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
use Carbon\Carbon;


class SalesActivityExport implements FromCollection, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    protected $data;
    protected $filterDay;
    protected $filterArea;
    protected $filterDate;

    public function __construct($data, $filterDay = null, $filterArea = null, $filterDate = null)
    {
        $this->data = $data;
        $this->filterDay = $filterDay;
        $this->filterArea = $filterArea;
        $this->filterDate = $filterDate;
    }

    public function collection()
    {
        $filteredData = $this->data;
        
        // Filter by day
        if ($this->filterDay && $this->filterDay !== 'all') {
            $filteredData = $filteredData->filter(function($item) {
                return $item->visit_day == $this->filterDay;
            });
        }

        // Filter by area
        if ($this->filterArea && $this->filterArea !== 'all') {
            $filteredData = $filteredData->filter(function($item) {
                return $item->city_id == $this->filterArea;
            });
        }

        // Filter by date range
        if ($this->filterDate && $this->filterDate !== 'Date Range' && $this->filterDate !== '') {
            if (str_contains($this->filterDate, ' to ')) {
                [$startDate, $endDate] = explode(' to ', $this->filterDate);
                $filteredData = $filteredData->filter(function($item) use ($startDate, $endDate) {
                    $itemDate = Carbon::parse($item->created_at)->startOfDay();
                    return $itemDate->between(
                        Carbon::parse($startDate)->startOfDay(),
                        Carbon::parse($endDate)->endOfDay()
                    );
                });
            } else {
                $filterDate = Carbon::parse($this->filterDate)->startOfDay();
                $filteredData = $filteredData->filter(function($item) use ($filterDate) {
                    return Carbon::parse($item->created_at)->startOfDay()->eq($filterDate);
                });
            }
        }

        return $filteredData;
    }


    public function headings(): array
    {
        return [
            'Nama Sales',
            'Nama Outlet',
            'Hari Kunjungan',
            'Check-In',
            'Check-Out',
            'Views'
        ];
    }

    public function map($row): array
    {
        return [
            $row->user->name,
            $row->outlet->name,
            getVisitDayByNumber($row->outlet->visit_day),
            $row->checked_in ? Carbon::parse($row->checked_in)->format('Y-m-d H:i:s') : '-',
            $row->checked_out ? Carbon::parse($row->checked_out)->format('Y-m-d H:i:s') : '-',
            $row->views_knowledge ?? '0'
        ];
    }
    public function styles(Worksheet $sheet)
    {
        $lastColumn = 'F';  // We have 6 columns (A to F)
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

        // Set specific column alignments
        $sheet->getStyle("A2:B{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_LEFT);
        $sheet->getStyle("C2:F{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);

        // Set row height
        $sheet->getDefaultRowDimension()->setRowHeight(25);

        // Freeze panes
        $sheet->freezePane('A2');

        return [
            1 => ['font' => ['bold' => true]],
        ];
    }
}