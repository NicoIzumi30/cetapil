<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Av3m extends Model
{
    use HasFactory, HasUuids, SoftDeletes;
    protected $fillable = ['channel_id', 'product_id', 'av3m'];
    public function product()
    {
        return $this->belongsTo(Product::class);
    }
    public function channel(){
        return $this->belongsTo(Channel::class);
    }
}
