<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Channel extends Model
{
    use HasFactory, HasUuids, SoftDeletes;
    protected $fillable = ['name'];
    
    public function av3ms()
    {
        return $this->hasMany(Av3m::class);
    }
    public function outlet(){
        return $this->hasMany(Outlet::class);
    } 
}
