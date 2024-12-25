<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class SalesVisibility extends Model
{
    use HasFactory, HasUuids, SoftDeletes;

    protected $guarded = [];

    public function visibility(): BelongsTo
    {
        return $this->belongsTo(Visibility::class);
    }
    public function salesActivity(): BelongsTo
    {
        return $this->belongsTo(SalesActivity::class);
    }

    public function scopeCompleteRelation(Builder $query)
    {
        $query->has('visibility');
    }

    public function getImageAttribute()
    {
        if (!$this->path) {
            return null;
        }
        return "/storage$this->path";
    }
}
