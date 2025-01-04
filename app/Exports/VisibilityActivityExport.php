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
use PhpOffice\PhpSpreadsheet\Cell\DataType;

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
            'Tipe Display Primary Core 1',
            'Visual Primary Core 1',
            'Condition Primary Core 1',
            'Foto Display Primary Core 1',
            'Lebar Rak Primary Core 1(cm)',
            'Shelving Primary Core 1',
            'Tipe Display Primary Core 2',
            'Visual Primary Core 2',
            'Condition Primary Core 2',
            'Foto Display Primary Core 2',
            'Lebar Rak Primary Core 2(cm)',
            'Shelving Primary Core 2',
            'Tipe Display Primary Core 3',
            'Visual Primary Core 3',
            'Condition Primary Core 3',
            'Foto Display Primary Core 3',
            'Lebar Rak Primary Core 3(cm)',
            'Shelving Primary Core 3',
            'Tipe Display Primary Baby 1',
            'Visual Primary Baby 1',
            'Condition Primary Baby 1',
            'Foto Display Primary Baby 1',
            'Lebar Rak Primary Baby 1(cm)',
            'Shelving Primary Baby 1',
            'Tipe Display Primary Baby 2',
            'Visual Primary Baby 2',
            'Condition Primary Baby 2',
            'Foto Display Primary Baby 2',
            'Lebar Rak Primary Baby 2(cm)',
            'Shelving Primary Baby 2',
            'Tipe Display Primary Baby 3',
            'Visual Primary Baby 3',
            'Condition Primary Baby 3',
            'Foto Display Primary Baby 3',
            'Lebar Rak Primary Baby 3(cm)',
            'Shelving Primary Baby 3',
            'Tipe Display Secondary Core 1',
            'Apakah Ada Secondary Display',
            'Foto Secondary Core 1',
            'Tipe Display Secondary Core 2',
            'Apakah Ada Secondary Display',
            'Foto Secondary Core 2',
            'Tipe Display Secondary Baby 1',
            'Apakah Ada Secondary Display',
            'Foto Secondary Baby 1',
            'Tipe Display Secondary Baby 2',
            'Apakah Ada Secondary Display',
            'Foto Secondary Baby 2',
            'Nama Brand Competitor 1',
            'Mekanisme Promo Competitor 1',
            'Periode Promo Competitor 1',
            'Foto Program Competitor 1',
            'Foto Program Competitor 1',
            'Nama Brand Competitor 2',
            'Mekanisme Promo Competitor 2',
            'Periode Promo Competitor 2',
            'Foto Program Competitor 2',
            'Foto Program Competitor 2',
            'Created At',
            'Ended At',
            'Duration',
            'Week'
        ];
    }

    public function map($row): array
    {
        $categories = ['CORE', 'BABY']; // Define categories
        $data = []; // Initialize data array

        foreach ($categories as $category) {
            for ($position = 1; $position <= 3; $position++) {
                // Find the first matching record for the category and position
                $visibility = $row->salesVisibilities
                    ->where('type', 'PRIMARY')
                    ->where('category', $category)
                    ->where('position', $position)
                    ->first();

                // Append data for this category and position
                $data[] = @$visibility->posmType->name ?: '-';
                $data[] = @$visibility->visual_type ?: '-';
                $data[] = @$visibility->condition ?: '-';
                $data[] = !empty($visibility->display_photo) ? config('app.storage_url') . $visibility->display_photo : '-';
                $data[] = @$visibility->shelf_width ?: '-';
                $data[] = @$visibility->shelving ?: '-';
            }
        }

        foreach ($categories as $category) {
            for ($position = 1; $position <= 2; $position++) {
                // Find the first matching record for the category and position
                $visibility = $row->salesVisibilities
                    ->where('type', 'SECONDARY')
                    ->where('category', $category)
                    ->where('position', $position)
                    ->first();

                // Append data for this category and position
                $data[] = @$visibility->visual_type ?: '-';
                $data[] = @$visibility->has_secondary_display ? 'Yes' : 'No';
                $data[] = !empty($visibility->display_photo) ? config('app.storage_url') . $visibility->display_photo : '-';
            }
        }

        for ($position = 1; $position <= 2; $position++) {
            // Find the first matching record for the category and position
            $visibility = $row->salesVisibilities
                ->where('type', 'COMPETITOR')
                ->where('category', 'COMPETITOR')
                ->where('position', $position)
                ->first();

            // Append data for this category and position
            $data[] = @$visibility->competitor_brand_name ?: '-';
            $data[] = @$visibility->competitor_promo_mechanism ?: '-';
            $data[] = @$visibility->competitor_promo_start . "-" . @$visibility->competitor_promo_end ?: '-';
            $data[] = !empty($visibility->display_photo) ? config('app.storage_url') . $visibility->display_photo : '-';
            $data[] = !empty($visibility->display_photo) ? config('app.storage_url') . $visibility->display_photo_2 : '-';
        }
        $data[] = $row->created_at->format('Y-m-d H:i:s'); // Created At

        // Calculate Ended At
        $endedAt = $row->created_at->addSeconds($row->time_availability + $row->time_visibility);
        $data[] = $endedAt->format('Y-m-d H:i:s'); // Ended At

        // Format Duration
        $durationInSeconds = $row->time_visibility;
        $duration = gmdate('H:i:s', $durationInSeconds); // Converts seconds to HH:mm:ss
        $data[] = $duration; // Duration

        // Calculate Week
        $data[] = $row->created_at->format('W'); // Week number


        // Return the activity data and visibility data
        return array_merge([
            // Activity Data
            @$row->outlet->name ?: '-',
            @$row->outlet->code ?: '-',
            @$row->outlet->type ?: '-',
            @$row->outlet->account ?: '-',
            @$row->outlet->channel->name ?: '-',
            @$row->user->name ?: '-',
        ], $data);
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
        $lastRow = $sheet->getHighestRow();
        $photoCols = ['J', 'P', 'V', 'AB', 'AH', 'AN', 'AS', 'AV', 'AY', 'BB','BF','BG','BK','BL']; // Sesuaikan dengan kolom foto Anda

        foreach ($photoCols as $col) {
            for ($row = 2; $row <= $lastRow; $row++) {
                $cell = $sheet->getCell($col . $row);
                if ($cell->getValue() !== '-') {
                    $sheet->getCell($col . $row)->setDataType(DataType::TYPE_STRING);
                    $sheet->getCell($col . $row)->getHyperlink()->setUrl($cell->getValue());
                    $sheet->getStyle($col . $row)->applyFromArray([
                        'font' => [
                            'underline' => true,
                            'color' => ['rgb' => '800080'] // Kode warna ungu, bisa disesuaikan
                        ]
                    ]);
                }
            }
        }
        // Set row height
        $sheet->getDefaultRowDimension()->setRowHeight(25);

        return [
            1 => ['font' => ['bold' => true]],
        ];
    }
}
