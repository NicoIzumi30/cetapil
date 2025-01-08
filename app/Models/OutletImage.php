<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class OutletImage extends Model
{
    use HasFactory, HasUuids, SoftDeletes;

    protected $guarded = [];

    public function getImageAttribute()
    {
        if (!$this->path) {
            return null;
        }
        return "/storage$this->path";
    }

    public function outlet()
    {
        return $this->belongsTo(Outlet::class);
    }
}
