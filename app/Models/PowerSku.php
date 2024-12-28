<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class PowerSku extends Model
{
    use HasFactory, HasUuids, SoftDeletes;

    protected $guarded = [];
    protected $fillable = [
        'category',
        'product_id',
        'product_competitor_price'
    ];

    public function product()
    {
        return $this->belongsTo(Product::class);
    }
}
