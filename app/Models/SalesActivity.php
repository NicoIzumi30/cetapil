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


    // app/Models/SalesActivity.php

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function outlet()
    {
        return $this->belongsTo(Outlet::class);
    }

    public function surveys(): HasMany
    {
        return $this->hasMany(SalesSurvey::class);
    }

    public function orders(): HasMany
    {
        return $this->hasMany(SalesOrder::class);
    }

    public function availabilities(): HasMany
    {
        return $this->hasMany(SalesAvailability::class);
    }

    public function salesVisibilities(): HasMany
    {
        return $this->hasMany(SalesVisibility::class);
    }
    public function visibilities(): HasMany
    {
        return $this->hasMany(Visibility::class, 'outlet_id', 'outlet_id');
    }

    public function scopeCompleteRelation(Builder $query)
    {
        $query->has('outlet');
    }

    public function av3m(): BelongsTo
    {
        return $this->belongsTo(Av3m::class);
    }

    // Scope to get all av3ms for a specific outlet
    public function scopeByOutlet($query, $outletId)
    {
        return $query->where('outlet_id', $outletId);
    }
}
