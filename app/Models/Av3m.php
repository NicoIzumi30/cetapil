<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Av3m extends Model
{
    use HasFactory, HasUuids, SoftDeletes;
    public $incrementing = false; // Since we're using UUID
    protected $keyType = 'string';
    
    protected $fillable = ['id','channel_id', 'product_id', 'av3m','outlet_id',];
    public function product()
    {
        return $this->belongsTo(Product::class);
    }

    public function channel()
    {
        return $this->belongsTo(Channel::class);
    }

    public function outlet()
    {
        return $this->belongsTo(Outlet::class);
    }
}
