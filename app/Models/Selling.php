<?php

namespace App\Models;

use App\Traits\Excludable;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Selling extends Model
{
    use HasFactory, HasUuids, SoftDeletes, Excludable;

    protected $guarded = [];

    protected $appends = ['image'];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
    public function salesActivity() {
        return $this->belongsTo(SalesActivity::class);
    }
    public function outlet(): BelongsTo
    {
        return $this->belongsTo(Outlet::class);
    }

    public function products(): HasMany
    {
        return $this->hasMany(SellingProduct::class);
    }

    public function getImageAttribute()
    {
        if (!$this->path) {
            return null;
        }
        return "/storage$this->path";
    }
}
