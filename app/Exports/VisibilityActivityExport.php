<?php

namespace App\Exports;

use Carbon\Carbon;
use App\Traits\ExcelExportable;
use Maatwebsite\Excel\Concerns\FromQuery;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class VisibilityActivityExport implements FromQuery, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    use ExcelExportable;
    protected int $chunkSize = 1000;

    protected $query;
    protected $photoCols = ['J', 'P', 'V', 'AB', 'AH', 'AN', 'AS', 'AV', 'AY', 'BB', 'BF', 'BG', 'BK', 'BL'];

    public function __construct($query)
    {
        $this->query = $query;
    }

    public function query()
    {
        return $this->query;
    }

    protected function mapVisibilityData($row, $type, $category, $position)
    {
        $visibility = $row->salesVisibilities
            ->where('type', $type)
            ->where('category', $category)
            ->where('position', $position)
            ->first();

        return $visibility;
    }

    protected function formatPhotoUrl($photoPath): string
    {
        if(empty($photoPath)) return '';
        if($photoPath == null) return '';
        return  config('app.storage_url') . $photoPath;
    }

    public function map($row): array
    {
        return $this->safeMap(function ($row) {
            $data = [];
            $categories = ['CORE', 'BABY'];
            // Primary display data
            foreach ($categories as $category) {
                for ($position = 1; $position <= 3; $position++) {
                    $visibility = $this->mapVisibilityData($row, 'PRIMARY', $category, $position);
                    $data = array_merge($data, [
                        @$visibility->posmType->name ?: '',
                        @$visibility->visual_type ?: '',
                        @$visibility->condition ?: '',
                        $this->formatPhotoUrl($visibility->display_photo ?? null),
                        @$visibility->shelf_width ?: '',
                        @$visibility->shelving ?: '',
                    ]);
                }
            }

            // Secondary display data
            foreach ($categories as $category) {
                for ($position = 1; $position <= 2; $position++) {
                    $visibility = $this->mapVisibilityData($row, 'SECONDARY', $category, $position);
                    $data = array_merge($data, [
                        @$visibility->visual_type ?: '',
                        @$visibility->has_secondary_display ? 'Yes' : 'No',
                        $this->formatPhotoUrl($visibility->display_photo ?? null),
                    ]);
                }
            }

            // Competitor data
            for ($position = 1; $position <= 2; $position++) {
                $visibility = $this->mapVisibilityData($row, 'COMPETITOR', 'COMPETITOR', $position);
                $data = array_merge($data, [
                    @$visibility->competitor_brand_name ?: '',
                    @$visibility->competitor_promo_mechanism ?: '',
                    @$visibility->competitor_promo_start . "" . @$visibility->competitor_promo_end ?: '',
                    $this->formatPhotoUrl($visibility->display_photo ?? null),
                    $this->formatPhotoUrl($visibility->display_photo_2 ?? null),
                ]);
            }

            // Time and metadata
            $endedAt = $row->created_at->addSeconds($row->time_availability + $row->time_visibility);
            $data = array_merge($data, [
                $row->created_at->format('Y-m-d H:i:s'),
                $endedAt->format('Y-m-d H:i:s'),
                gmdate('H:i:s', $row->time_visibility),
                $row->created_at->format('W'),
            ]);

            // Merge with base data
            return array_merge([
                @$row->outlet->name ?: '',
                @$row->outlet->code ?: '',
                @$row->outlet->tipe_outlet ?: '',
                @$row->outlet->account ?: '',
                @$row->outlet->channel->name ?: '',
                @$row->user->name ?: '',
            ], $data);

        }, $row, 'visibility');
    }

    public function styles(Worksheet $sheet)
    {
        $this->applyDefaultStyles($sheet);
        
        // Apply hyperlinks to photo columns
        $this->applyHyperlinks($sheet, $this->photoCols, $sheet->getHighestRow());
        
        // Set wrap text for all cells
        $lastColumn = $sheet->getHighestColumn();
        $lastRow = $sheet->getHighestRow();
        $sheet->getStyle("A1:{$lastColumn}{$lastRow}")
            ->getAlignment()
            ->setWrapText(true);

        return [
            1 => ['font' => ['bold' => true]],
        ];
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
    public function chunkSize(): int
    {
        return $this->chunkSize;
    }

}