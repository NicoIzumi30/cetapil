<?php

namespace App\Exports;

use App\Models\Outlet;
use App\Models\Channel;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use Illuminate\Support\Facades\Log;

class OutletExport implements FromCollection, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    protected $channels;

    public function __construct()
    {

    }

    public function collection()
    {
        return Outlet::with(['user', 'images','city','channel'])->get();
    }

    public function headings(): array
    {
        $headers = [
            'Nama Outlet',
            'Nama Sales',
            'Kategori Outlet',
            'Hari Kunjungan',
            'Cycle',
            'Tipe Minggu',
            'Channel',
            'Longitude',
            'Latitude',
            'Kota',
            'Alamat',
            'Foto Tampak Depan Outlet',
            'Foto Spanduk',
            'Foto Jalan Utama'
        ];
        return $headers;
    }

    public function map($outlet): array
    {
        try {
            $row = [
                $outlet->name,
                $outlet->user->name,
                $outlet->category,
                getVisitDayByNumber($outlet->visit_day),
                $outlet->cycle,
                $outlet->week_type,
                $outlet->channel->name,
                $outlet->longitude,
                $outlet->latitude,
                $outlet->city->name,
                $outlet->address,
            ];

            // Create associative array of av3m values by channel_id
            $av3mByChannel = $product->av3ms->pluck('av3m', 'channel_id')->toArray();

            // Add av3m values for each channel
            foreach ($this->channels as $channel) {
                $row[] = $av3mByChannel[$channel->id] ?? 0;
            }

            return $row;
        } catch (\Exception $e) {
            Log::error('Error in ProductExport mapping', [
                'message' => $e->getMessage(),
                'product_id' => $product->id ?? 'unknown'
            ]);
            throw $e;
        }
    }

    public function styles(Worksheet $sheet)
    {
        $lastColumn = chr(65 + 3 + $this->channels->count()); // A + number of base columns + number of channels
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

        // Align SKU center
        $sheet->getStyle("B2:B{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);

        // Align prices right
        $sheet->getStyle("C2:D{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_RIGHT);

        // Align AV3M values center
        $sheet->getStyle("E2:{$lastColumn}{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);

        // Set row height
        $sheet->getDefaultRowDimension()->setRowHeight(25);

        // Freeze panes
        $sheet->freezePane('A2');

        return [
            1 => ['font' => ['bold' => true]],
        ];
    }
}