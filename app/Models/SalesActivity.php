<?php

namespace App\Models;

use App\Traits\Excludable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class SalesActivity extends Model
{
    use HasFactory, HasUuids, SoftDeletes, Excludable;

    protected $guarded = [];

    public function outlet(): BelongsTo
    {
        return $this->belongsTo(Outlet::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function surveys(): HasMany
    {
        return $this->hasMany(SalesSurvey::class);
    }

    public function scopeCompleteRelation(Builder $query)
    {
        $query->has('outlet');
    }
    // Add this relationship method to your SalesActivity class
    public function visibilities(): HasMany
    {
        return $this->hasMany(Visibility::class, 'outlet_id', 'outlet_id');
    }
}
