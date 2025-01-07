<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Outlet extends Model
{
    use HasFactory, HasUuids, SoftDeletes;

    protected $guarded = [];
    
    // protected $fillable = ['id','channel_id', 'product_id', 'av3m','outlet_id',];
    /**
     * Get the city that owns the outlet.
     */
    public function city(): BelongsTo
    {
        return $this->belongsTo(City::class);
    }
    public function Av3m(): BelongsTo
    {
        return $this->belongsTo(Av3m::class);
    }
    /**
     * Get the user that owns the outlet.
     */
    public function outlet()
    {
        return $this->belongsTo(Outlet::class);
    }
    public function outletRoutings(){
        return $this->hasMany(OutletRouting::class);
    } 
    public function user()
    {
        return $this->belongsTo(User::class)->withTrashed();
    }
    public function channel(): BelongsTo  // Note: changed from 'channels' to 'channel' since it's a single relationship
    {
        return $this->belongsTo(Channel::class);
    }
    public function products()
    {
        return $this->belongsToMany(Product::class, 'outlet_products');
    }
    public function images(): HasMany
    {
        return $this->hasMany(OutletImage::class);
    }

    public function forms(): HasMany
    {
        return $this->hasMany(OutletFormAnswer::class);
    }

    public function salesActivities(): HasMany
    {
        return $this->hasMany(SalesActivity::class, 'outlet_id');
    }

    public function scopeApproved(Builder $query): Builder
    {
        return $query->where('status', 'APPROVED');
    }

    public function getDayAttribute(): string
    {
        return Carbon::now()->startOfWeek()->addDays($this->attributes['visit_day'] - 1)->format('l');
    }
    public function channel_name()
    {
        return $this->belongsTo(Channel::class, 'channel', 'id');
    }
    public function productKnowledge()
    {
        return $this->hasMany(ProductKnowledge::class, 'channel_id', 'channel');
    }
    public function visibilities(): HasMany
    {
        return $this->hasMany(Visibility::class);
    }

    
}
