<?php

namespace App\Exports;

use App\Models\SalesOrder;
use App\Traits\ExcelExportable;
use Carbon\Carbon;
use Maatwebsite\Excel\Concerns\FromQuery;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use Illuminate\Support\Facades\Log;


class OrderExport implements FromQuery, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    use ExcelExportable;

    protected $startDate;
    protected $endDate;
    protected $region;

    public function __construct($startDate = null, $endDate = null, $region = null)
    {
        $this->startDate = $startDate;
        $this->endDate = $endDate;
        $this->region = $region;
        $this->useAlternatingRows = true;

        Log::info('OrderExport params:', [
            'startDate' => $startDate,
            'endDate' => $endDate,
            'region' => $region
        ]);
    }

    public function query()
    {
        return $this->safeQuery(function () {
            $query = SalesOrder::query()
                ->with([
                    'salesActivity:id,time_order,created_at,status,user_id',
                    'salesActivity.user',
                    'outlet.city.province',
                    'outlet.channel',
                    'product.category'
                ])->where('total_items', '>', 0)->whereHas('salesActivity', function ($q) {
                    $q->where('status', 'SUBMITTED');
                });
            if ($this->startDate && $this->endDate) {
                $query->whereHas('salesActivity', function ($q) {
                    $q->whereDate('created_at', '>=', $this->startDate)
                        ->whereDate('created_at', '<=', $this->endDate);
                });
            }

            if ($this->region && $this->region !== 'all') {
                $query->whereHas('outlet.city.province', function ($q) {
                    $q->where('code', $this->region);
                });
            }

            return $query;
        });
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
            'Duration',
            'Created At',
            'Ended At',
            'Week'
        ];
    }

    public function map($order): array
    {
        return $this->safeMap(function ($order) {
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
                $order->salesActivity ? gmdate('H:i:s', $order->salesActivity->time_order) : '-',
                $this->formatDateTime($order->salesActivity->created_at),
                $this->formatDateTime(  $order->salesActivity && $order->salesActivity->created_at
                ? $order->salesActivity->created_at->addSeconds($order->salesActivity->time_order)->format('Y-m-d H:i:s')
                : '-'),
                $order->created_at ? $order->created_at->format('W') : '-',
            ];
        }, $order, 'order');
    }

    public function styles(Worksheet $sheet)
    {
        $this->applyDefaultStyles($sheet);
        return [1 => ['font' => ['bold' => true]]];
    }
}