<?php

namespace App\Exports;

use App\Models\SalesOrder;
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

class OrderExport implements FromQuery, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    protected $startDate;
    protected $endDate;
    protected $region;

    public function __construct($startDate = null, $endDate = null, $region = null)
    {
        $this->startDate = $startDate;
        $this->endDate = $endDate;
        $this->region = $region;

        Log::info('OrderExport params:', [
            'startDate' => $startDate,
            'endDate' => $endDate,
            'region' => $region
        ]);
    }

    public function query()
    {
        $query = SalesOrder::query()
            ->with([
                'salesActivity.user',
                'outlet.city.province',
                'outlet.channel',
                'product.category'
            ]);
    
        if ($this->startDate && $this->endDate) {
            $query->whereHas('salesActivity', function($q) {
                $q->whereBetween('created_at', [
                    $this->startDate->startOfDay(),
                    $this->endDate->endOfDay()
                ]);
            });
        }
    
        if ($this->region && $this->region !== 'all') {
            $query->whereHas('outlet.city.province', function($q) {
                $q->where('code', $this->region);
            });
        }
    
        return $query;
    }

    public function headings(): array
    {
        return [
            'Nama Sales',
            'Outlet',
            'Kode Outlet',
            'Tipe Outlet',
            'Account',
            'Channel',
            'Kota',
            'Province',
            'Category',
            'SKU Name',
            'Total Items',
            'Subtotal',
            'Created At',
            'Week'
        ];
    }

    public function map($order): array
    {
        try {
            return [
                $order->salesActivity->user->name ?? '',
                $order->outlet->name ?? '',
                $order->outlet->code ?? '',
                $order->outlet->tipe_outlet ?? '',
                $order->outlet->account ?? '',
                $order->outlet->channel->name ?? '',
                $order->outlet->city->name ?? '',
                $order->outlet->city->province->name ?? '',
                $order->product->category->name ?? '',
                $order->product->sku ?? '',
                $order->total_items ?? 0,
                $order->subtotal ?? 0,
                $order->created_at ? Carbon::parse($order->created_at)->format('Y-m-d H:i:s') : '',
                $order->salesActivity->week ?? ''
            ];
        } catch (\Exception $e) {
            Log::error('Error mapping order:', [
                'error' => $e->getMessage(),
                'order_id' => $order->id
            ]);
            return array_fill(0, 14, '');
        }
    }

    public function styles(Worksheet $sheet)
    {
        $lastColumn = 'N';
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