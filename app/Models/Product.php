<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class Product extends Model
{
    use HasFactory, HasUuids, SoftDeletes;

    protected $guarded = [];

    protected $appends = ['image'];

    protected $fillable = ['category_id', 'sku', 'price'];
    /**
     * Get the category that owns the product.
     */
    public function outletProducts()
    {
        return $this->hasMany(OutletProduct::class);
    }
    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function accountType(): BelongsTo
    {
        return $this->belongsTo(ProductAccountType::class, 'product_account_type_id');
    }

    public function getImageAttribute()
    {
        if (!$this->path) {
            return null;
        }
        return "/storage$this->path";
    }

    public function av3ms()
    {
        return $this->hasMany(Av3m::class);
    }
    public function outlets()
    {
        return $this->belongsToMany(Outlet::class, 'outlet_products');
    }

    public function channels()
    {
        return $this->belongsToMany(Channel::class, 'av3ms')
            ->withPivot('av3m');
    }
    public function av3m()
    {
        return $this->hasOne(Av3m::class);
    }
}
