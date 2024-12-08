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

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }

    public function scopeCompleteRelation(Builder $query)
    {
        $query->has('sell')
                ->has('product');
    }

    public function getImageAttribute()
    {
        if (!$this->path) {
            return null;
        }
        return "/storage$this->path";
    }
}
