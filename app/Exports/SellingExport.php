<?php

namespace App\Exports;

use App\Models\SellingProduct;
use App\Traits\ExcelExportable;
use Maatwebsite\Excel\Concerns\FromQuery;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\WithChunkReading;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class SellingDownloadExport implements FromQuery, WithHeadings, WithMapping, WithStyles, WithChunkReading
{
    use ExcelExportable;

    protected $startDate;
    protected $endDate;
    protected $region;
    protected int $chunkSize = 1000;

    public function __construct($startDate = null, $endDate = null, $region = null)
    {
        $this->startDate = $startDate;
        $this->endDate = $endDate;
        $this->region = $region;
        $this->useAlternatingRows = true;
    }

    public function query()
    {
        $query = SellingProduct::query()
            ->select([
                'selling_products.id',
                'selling_products.qty',
                'selling_products.price',
                'selling_products.total',
                'selling_products.created_at',
                'selling_products.sell_id',
                'selling_products.product_id'
            ])
            ->with([
                'product:id,sku,category_id',
                'product.category:id,name',
                'sell:id,user_id,outlet_id,checked_in,checked_out,duration',
                'sell.user:id,name',
                'sell.outlet:id,name,code,tipe_outlet,account,TSO,channel_id,city_id',
                'sell.outlet.city:id,name,province_id',
                'sell.outlet.channel:id,name',
                'sell.outlet.city.province:id,code'
            ]);
    
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
    
        return $query->orderBy('created_at', 'desc');
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
        return $this->safeMap(function ($selling) {
            return [
                $selling->sell->user->name ?? '',
                $selling->sell->outlet->TSO ?? '',
                $selling->sell->outlet->name ?? '',
                $selling->sell->outlet->code ?? '',
                $selling->sell->outlet->tipe_outlet ?? '',
                $selling->sell->outlet->account ?? '',
                $selling->sell->outlet->channel->name ?? '',
                $selling->sell->outlet->city->name ?? '',
                $selling->product->category->name ?? '',
                $selling->product->sku ?? '',
                $selling->qty ?? 0,
                $selling->price ?? 0,
                $selling->total ?? 0,
                $this->formatDateTime($selling->sell->checked_in),
                $this->formatDateTime($selling->sell->checked_out),
                $selling->sell->duration ?? '',
                $selling->created_at ? $selling->created_at->format('W') : '-',
            ];
        }, $selling, 'Selling Export');
    }

    public function styles(Worksheet $sheet)
    {
        $this->applyDefaultStyles($sheet);
    }

    public function chunkSize(): int
    {
        return $this->chunkSize;
    }
}
