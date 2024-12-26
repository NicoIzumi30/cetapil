<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use Carbon\Carbon;

class VisibilityActivityExport implements FromCollection, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    protected $data;

    public function __construct($data)
    {
        $this->data = $data;
    }

    public function collection()
    {
        return collect($this->data);
    }

    public function headings(): array
    {
        return [
            'Outlet',
            'Kode Outlet',
            'Tipe Outlet',
            'Account',
            'Channel',
            'Sales',
            'Check In',
            'Check Out',
            'Duration',
            'Radius Status',
            'Time Availability',
            'Time Visibility',
            'Time Knowledge',
            'Time Survey',
            'Time Order',
            'Status',
            'Latitude',
            'Longitude',
            // SalesVisibilities Data
            'Category',
            'Type',
            'Position',
            'Visual Type',
            'Condition',
            'Display Photo',
            'Shelf Width',
            'Shelving',
            'Has Secondary Display',
            'Created At',
            'Week'
        ];
    }

    public function map($row): array
    {
        // Get first visibility record if exists
        $visibility = $row->salesVisibilities->first();

        return [
            // Activity Data
            @$row->outlet->name ?: '-',
            @$row->outlet->code ?: '-',
            @$row->outlet->type ?: '-',
            @$row->outlet->account ?: '-',
            @$row->outlet->channel ?: '-',
            @$row->user->name ?: '-',
            @$row->checked_in ? Carbon::parse($row->checked_in)->format('d F Y H:i:s') : '-',
            @$row->checked_out ? Carbon::parse($row->checked_out)->format('d F Y H:i:s') : '-',
            $this->calculateDuration($row->checked_in, $row->checked_out),
            @$row->radius_status ?: '-',
            @$row->time_availability ?: '-',
            @$row->time_visibility ?: '-',
            @$row->time_knowledge ?: '-',
            @$row->time_survey ?: '-',
            @$row->time_order ?: '-',
            @$row->status ?: '-',
            @$row->latitude ?: '-',
            @$row->longitude ?: '-',
            // Visibility Data
            @$visibility->category ?: '-',
            @$visibility->type ?: '-',
            @$visibility->position ?: '-',
            @$visibility->visual_type ?: '-',
            @$visibility->condition ?: '-',
            @$visibility->display_photo ?: '-',
            @$visibility->shelf_width ?: '-',
            @$visibility->shelving ?: '-',
            @$visibility->has_secondary_display ? 'Yes' : 'No',
            @$row->created_at ? Carbon::parse($row->created_at)->format('d F Y H:i:s') : '-',
            @$row->created_at ? Carbon::parse($row->created_at)->format('W') : '-'
        ];
    }

    private function calculateDuration($checkIn, $checkOut)
    {
        if (!$checkIn || !$checkOut) {
            return '-';
        }

        $start = Carbon::parse($checkIn);
        $end = Carbon::parse($checkOut);

        $diffInMinutes = $end->diffInMinutes($start);

        if ($diffInMinutes < 60) {
            return $diffInMinutes . ' minutes';
        }

        $hours = floor($diffInMinutes / 60);
        $minutes = $diffInMinutes % 60;

        return $hours . ' hours ' . $minutes . ' minutes';
    }

    public function styles(Worksheet $sheet)
    {
        $lastRow = $sheet->getHighestRow();
        $lastColumn = $sheet->getHighestColumn();

        // Header styling
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
            ],
        ]);

        // Content styling
        $sheet->getStyle("A2:{$lastColumn}{$lastRow}")->applyFromArray([
            'borders' => [
                'allBorders' => [
                    'borderStyle' => Border::BORDER_THIN,
                ],
            ],
            'alignment' => [
                'vertical' => Alignment::VERTICAL_CENTER,
            ],
        ]);

        // Set row height
        $sheet->getDefaultRowDimension()->setRowHeight(25);

        // Apply text wrapping to all columns
        $sheet->getStyle("A1:{$lastColumn}{$lastRow}")->getAlignment()->setWrapText(true);

        return [
            1 => ['font' => ['bold' => true]],
        ];
    }
}
