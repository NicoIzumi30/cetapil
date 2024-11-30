<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Str;


class PosmImage extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'posm_images';
    public $incrementing = false;
    protected $keyType = 'string';
    
    protected $fillable = [
        'id',
        'posm_type_id',
        'image',
        'path'
    ];

    protected static function boot()
    {
        parent::boot();
        
        static::creating(function ($model) {
            $model->id = Str::uuid();
        });
    }

    public function posmType()
    {
        return $this->belongsTo(PosmType::class, 'posm_type_id', 'id');
    }
}

