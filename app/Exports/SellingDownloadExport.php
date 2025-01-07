<?php

namespace App\Exports;

use App\Models\SellingProduct;
use Carbon\Carbon;
use Maatwebsite\Excel\Concerns\FromQuery;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use Illuminate\Support\Facades\Log;

class SellingDownloadExport implements FromQuery, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    protected $startDate;
    protected $endDate;
    protected $region;

    public function __construct($startDate = null, $endDate = null, $region = null)
    {
        $this->startDate = $startDate;
        $this->endDate = $endDate;
        $this->region = $region;

        Log::info('SellingDownloadExport params:', [
            'startDate' => $startDate,
            'endDate' => $endDate,
            'region' => $region
        ]);
    }

    public function query()
    {
        $query = SellingProduct::query()
            ->with(['product.category', 'sell.user', 'sell.outlet.city.province', 'sell.outlet.channel']);
    
        if ($this->startDate && $this->endDate) {
            $query->whereHas('sell', function($q) {
                $q->whereBetween('checked_in', [
                    $this->startDate->startOfDay(),
                    $this->endDate->endOfDay()
                ]);
            });
        }
    
        if ($this->region && $this->region !== 'all') {
            $query->whereHas('sell.outlet.city.province', function($q) {
                $q->where('code', $this->region);
            });
        }
    
        return $query;
    }

    public function headings(): array
    {
        return [
            'Nama Sales',
            'TSO',
            'Outlet',
            'Kode Outlet',
            'Tipe Outlet',
            'Account',
            'Channel',
            'Kota',
            'Category',
            'SKU Name',
            'Qty Order',
            'Harga',
            'Total',
            'Created At',
            'Ended At',
            'Duration',
            'Week'
        ];
    }

    public function map($selling): array
    {
        try {
            return [
                $selling->sell->user->name ?? 'N/A',
                $selling->sell->outlet->TSO ?? 'N/A',
                $selling->sell->outlet->name ?? 'N/A',
                $selling->sell->outlet->code ?? 'N/A',
                $selling->sell->outlet->tipe_outlet ?? 'N/A',
                $selling->sell->outlet->account ?? 'N/A',
                $selling->sell->outlet->channel->name ?? 'N/A',
                $selling->sell->outlet->city->name ?? 'N/A',
                $selling->product->category->name ?? 'N/A',
                $selling->product->sku ?? 'N/A',
                $selling->qty ?? 0,
                $selling->price ?? 0,
                $selling->total ?? 0,
                $selling->sell->checked_in ? Carbon::parse($selling->sell->checked_in)->format('Y-m-d H:i:s') : 'N/A',
                $selling->sell->checked_out ? Carbon::parse($selling->sell->checked_out)->format('Y-m-d H:i:s') : 'N/A',
                $selling->sell->duration ?? 'N/A',
                $selling->created_at ? $selling->created_at->format('W') : '-',
            ];
        } catch (\Exception $e) {
            Log::error('Error mapping selling:', [
                'error' => $e->getMessage(),
                'selling_id' => $selling->id
            ]);
            return array_fill(0, 17, 'N/A');
        }
    }

    public function styles(Worksheet $sheet)
    {
        $lastColumn = 'Q';
        $lastRow = $sheet->getHighestRow();

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

        for ($row = 2; $row <= $lastRow; $row++) {
            if ($row % 2 == 0) {
                $sheet->getStyle("A{$row}:{$lastColumn}{$row}")->applyFromArray([
                    'fill' => [
                        'fillType' => Fill::FILL_SOLID,
                        'startColor' => ['rgb' => 'F8F9FA'],
                    ],
                ]);
            }
        }

        $sheet->getDefaultRowDimension()->setRowHeight(25);
        $sheet->freezePane('A2');

        return [
            1 => ['font' => ['bold' => true]],
        ];
    }
}