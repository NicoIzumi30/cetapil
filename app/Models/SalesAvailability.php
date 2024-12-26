<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class SalesAvailability extends Model
{
    use HasFactory, HasUuids, SoftDeletes;

    protected $guarded = [];
    protected $appends = ['status_ideal'];
    protected $casts = [
        'status' => 'boolean'
    ];
    public function getStatusIdealAttribute()
    {
        return $this->attributes['status'];
    }
    public function outlet(): BelongsTo
    {
        return $this->belongsTo(Outlet::class);
    }

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }

    public function scopeCompleteRelation(Builder $query)
    {
        $query->has('outlet')
                ->has('product');
    }

    public static function getDetail(int $stock)
    {
        if ($stock < 0) return 'MINUS';
        if ($stock > 0) return 'OVER';
        return 'IDEAL';
    }
}
