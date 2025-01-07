<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class SalesOrder extends Model
{
    use HasFactory, HasUuids, SoftDeletes;

    protected $guarded = [];
    protected $table = 'sales_orders';

    protected $fillable = [
        'sales_activity_id',
        'outlet_id',
        'product_id',
        'total_items',
        'subtotal'
    ];

    // Relationship with Outlet
    public function salesActivity()
    {
        return $this->belongsTo(SalesActivity::class);
    }

    public function outlet()
    {
        return $this->belongsTo(Outlet::class);
    }

    public function product()
    {
        return $this->belongsTo(Product::class);
    }
}
