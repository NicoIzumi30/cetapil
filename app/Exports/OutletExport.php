<?php

namespace App\Exports;

use App\Models\Channel;
use App\Models\Outlet;
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
    protected $startDate;
    protected $endDate;
    protected $region;
    protected $minimumWidth = 10;
    protected $maximumWidth = 50;

    public function __construct($startDate = null, $endDate = null, $region = null)
    {
        $this->startDate = $startDate;
        $this->endDate = $endDate;
        $this->region = $region;
    }

    public function collection()
    {
        $query = Outlet::with(['user', 'city.province', 'channel_name']);

        // Apply province filter if provided
        if ($this->region && $this->region !== 'all') {
            $query->whereHas('city', function($q) {
                $q->where('province_code', $this->region);
            });
        }

        // Apply date filter if provided
        if ($this->startDate && $this->endDate) {
            $query->whereBetween('created_at', [$this->startDate, $this->endDate]);
        }

        return $query->get();
    }

    public function headings(): array
    {
        return [
            'Nama Outlet',
            'Nama Sales',
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
        ];
    }

    public function map($outlet): array
    {
        try {
            return [
                $outlet->name,
                $outlet->user->name,
                $outlet->category,
                getVisitDayByNumber($outlet->visit_day),
                $outlet->cycle,
                $outlet->week,
                $outlet->channel_name->name ?? '',
                $outlet->account,
                $outlet->TSO,
                $outlet->KAM,
                $outlet->city->name ?? '',
                $outlet->address,
                $outlet->longitude,
                $outlet->latitude,
            ];
        } catch (\Exception $e) {
            Log::error('Error in ProductExport mapping', [
                'message' => $e->getMessage(),
                'outlet_id' => $outlet->id ?? 'unknown'
            ]);
            throw $e;
        }
    }

    public function styles(Worksheet $sheet)
    {
        $lastColumn = chr(65 + 10);
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

        // Mengatur lebar kolom secara optimal
        foreach (range('A', $lastColumn) as $column) {
            $sheet->getColumnDimension($column)->setAutoSize(true);

            // Mendapatkan lebar kolom setelah autosize
            $columnWidth = $sheet->getColumnDimension($column)->getWidth();

            // Menyesuaikan lebar kolom dalam batas minimum dan maksimum
            if ($columnWidth < $this->minimumWidth) {
                $sheet->getColumnDimension($column)->setWidth($this->minimumWidth);
            } elseif ($columnWidth > $this->maximumWidth) {
                $sheet->getColumnDimension($column)->setWidth($this->maximumWidth);

                // Mengaktifkan text wrapping untuk kolom yang terlalu lebar
                $sheet->getStyle($column . '1:' . $column . $lastRow)
                    ->getAlignment()
                    ->setWrapText(true);
            }
        }

        // Specific column alignments
        $sheet->getStyle("B2:B{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);
        $sheet->getStyle("C2:B{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);
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
