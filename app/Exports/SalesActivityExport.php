<?php

namespace App\Exports;

use App\Traits\ExcelExportable;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;

class SalesActivityExport implements FromCollection, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    use ExcelExportable;

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
            'Nama Outlet', 
            'Hari Kunjungan',
            'Week',
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

    protected function formatTime($seconds)
    {
        if (!$seconds) return '';
        try {
            return gmdate('H:i:s', (int)$seconds);
        } catch (\Exception $e) {
            return '';
        }
    }



    public function map($row): array
    {
        try {
            $routing = optional($row->outlet)->outletRoutings->first();
            
            return [
                optional($row->user)->name ?? '',
                optional($row->outlet)->name ?? '',
                $row->checked_in ? $row->day_name : '',
                $row->checked_in ? $row->week : '',
                $row->checked_in ? Carbon::parse($row->checked_in)->format('Y-m-d H:i:s') : '',
                $row->checked_out ? Carbon::parse($row->checked_out)->format('Y-m-d H:i:s') : '',
                $row->views_knowledge ?? '0',
                $row->status ?? '',
                $row->radius_status ?? '',
                $this->formatTime($row->time_availability),
                $this->formatTime($row->time_visibility),
                $this->formatTime($row->time_knowledge),
                $this->formatTime($row->time_survey),
                $this->formatTime($row->time_order)
            ];
        } catch (\Exception $e) {
            Log::error('Error mapping row', [
                'row_id' => $row->id ?? 'unknown',
                'error' => $e->getMessage()
            ]);
            return array_fill(0, 14, '');
        }
    }

    public function styles(Worksheet $sheet)
    {
        $this->applyDefaultStyles($sheet);
        
        $lastRow = $sheet->getHighestRow();

        // Center align most columns
        $sheet->getStyle("C2:N{$lastRow}")
            ->getAlignment()
            ->setHorizontal(Alignment::HORIZONTAL_CENTER);

        // Left align name columns
        $sheet->getStyle("A2:B{$lastRow}")
            ->getAlignment()
            ->setHorizontal(Alignment::HORIZONTAL_LEFT);

        return [
            1 => ['font' => ['bold' => true]]
        ];
    }
}