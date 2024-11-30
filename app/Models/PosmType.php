<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class PosmType extends Model
{
    use HasFactory, HasUuids, SoftDeletes;

    protected $guarded = [];

    public function posmImages()
    {
        return $this->hasMany(PosmImage::class, 'posm_type_id', 'id');
    }
}
