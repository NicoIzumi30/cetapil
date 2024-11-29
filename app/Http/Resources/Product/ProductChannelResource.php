<?php

namespace App\Http\Resources\Product;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\DB;

class ProductChannelResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {        // Get all av3m values grouped by channel for this product
        $channelData = DB::table('channels')
            ->select('channels.id', 'channels.name', 'av3ms.av3m')
            ->join('av3ms', 'channels.id', '=', 'av3ms.channel_id')
            ->where('av3ms.product_id', $this->id)
            ->whereNull('channels.deleted_at')
            ->get()
            ->mapWithKeys(function ($item) {
                return [$item->name => $item->av3m];
            });

        return [
            'id' => $this->id,
            'sku' => $this->sku,
            'category' => $this->category->only('id', 'name'),
            'average_stock' => $this->average_stock,
            'md_price' => $this->md_price,
            'sales_price' => $this->sales_price,
            'channel_av3m' => $channelData
        ];
    }
}
