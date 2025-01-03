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
use Illuminate\Support\Facades\Log;

class SalesActivityExport implements FromCollection, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    protected $data;

    public function __construct($data)
    {
        $this->data = $data;
        
        // Log data received in constructor
        Log::info('SalesActivityExport constructed with data:', [
            'count' => $data->count(),
            'first_record' => $data->first()
        ]);
    }

    public function collection()
    {
        Log::info('Collection method called with data count:', [
            'count' => $this->data->count()
        ]);

        return $this->data;
    }

    public function headings(): array
    {
        return [
            'Nama Sales',
            'Nama Outlet', 
            'Hari Kunjungan',
            'Check-In',
            'Check-Out',
            'Views',
            'Status',
            'Radius Status',
            'Time Availability',
            'Time Visibility',
            'Time Knowledge',
            'Time Survey',
            'Time Order'
        ];
    }

    public function map($row): array
    {
        try {
            Log::info('Mapping row:', [
                'id' => $row->id,
                'user' => $row->user,
                'outlet' => $row->outlet
            ]);

            return [
                $row->user ? $row->user->name : 'N/A',
                $row->outlet ? $row->outlet->name : 'N/A',
                $row->outlet ? getVisitDayByNumber($row->outlet->visit_day ?? 0) : 'N/A',
                $row->checked_in ? Carbon::parse($row->checked_in)->format('Y-m-d H:i:s') : 'N/A',
                $row->checked_out ? Carbon::parse($row->checked_out)->format('Y-m-d H:i:s') : 'N/A',
                $row->views_knowledge ?? '0',
                $row->status ?? '',
                $row->radius_status ?? '',
                $row->time_availability ?? '0',
                $row->time_visibility ?? '0',
                $row->time_knowledge ?? '0',
                $row->time_survey ?? '0',
                $row->time_order ?? '0'
            ];
        } catch (\Exception $e) {
            Log::error('Error mapping row:', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
                'row' => $row
            ]);

            // Return default values if mapping fails
            return [
                '', '', '', '', '', '', 
                '', '', '', '', '', '', ''
            ];
        }
    }

    public function styles(Worksheet $sheet)
    {
        $lastColumn = 'M';  // 13 columns (A to M)
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

        // Text alignment for specific columns
        $sheet->getStyle("A2:B{$lastRow}")->getAlignment()
              ->setHorizontal(Alignment::HORIZONTAL_LEFT);
        $sheet->getStyle("C2:{$lastColumn}{$lastRow}")->getAlignment()
              ->setHorizontal(Alignment::HORIZONTAL_CENTER);

        // Row height
        $sheet->getDefaultRowDimension()->setRowHeight(25);
        
        // Freeze panes
        $sheet->freezePane('A2');

        return [
            1 => ['font' => ['bold' => true]],
        ];
    }
}