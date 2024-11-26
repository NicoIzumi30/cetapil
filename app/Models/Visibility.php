<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;


class Visibility extends Model
{
    use HasFactory, HasUuids, SoftDeletes;

    protected $guarded = [];

    public function user()
    {
        return $this->belongsTo(User::class)->withTrashed();
    }

    public function city(): BelongsTo
    {
        return $this->belongsTo(City::class);
    }

    public function outlet(): BelongsTo
    {
        return $this->belongsTo(Outlet::class);
    }

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }

    public function posmType(): BelongsTo
    {
        return $this->belongsTo(PosmType::class);
    }

    public function visualType(): BelongsTo
    {
        return $this->belongsTo(VisualType::class);
    }

    public function scopeCompleteRelation(Builder $query)
    {
        $query->has('user')
                ->has('city')
                ->has('outlet')
                ->has('product')
                ->has('posmType')
                ->has('visualType');
    }



    public function getImageAttribute()
    {
        if (!$this->path) {
            return null;
        }
        return env('APP_URL') . "/storage$this->path";
    }
}
