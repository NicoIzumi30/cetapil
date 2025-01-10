<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class SellingProduct extends Model
{
    use HasFactory, HasUuids, SoftDeletes;

    protected $guarded = [];

    public function sell(): BelongsTo
    {
        return $this->belongsTo(Selling::class, 'selling_id');
    }

    public function product() {
        return $this->belongsTo(Product::class);
    }
    
    // Model Sell
    public function outlet() {
        return $this->belongsTo(Outlet::class);
    }
    
    public function user() {
        return $this->belongsTo(User::class);
    }
    
    public function scopeCompleteRelation(Builder $query)
    {
        $query->has('sell')
              ->has('product');
    }
}
