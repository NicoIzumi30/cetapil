<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Province extends Model
{
    use HasFactory, HasUuids;

    protected $guarded = [];

    // Province.php
    public function cities() // Changed from city() to cities()
    {
        return $this->hasMany(City::class, 'province_code', 'code');
    }
}
