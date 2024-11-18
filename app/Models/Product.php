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

    protected $fillable = ['category_id', 'sku', 'md_price', 'sales_price'];
    /**
     * Get the category that owns the product.
     */
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
        return env('APP_URL') . "/storage$this->path";
    }
}
