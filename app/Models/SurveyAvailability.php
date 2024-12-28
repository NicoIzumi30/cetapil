<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class SurveyAvailability extends Model
{
    use SoftDeletes;

    protected $table = 'survey_availabilities';

    protected $fillable = [
        'id',
        'category',
        'survey_question_id',
        'survey_question_id_2',
        'product_id',
        'product_name'
    ];

    public function product()
    {
        return $this->belongsTo(Product::class);
    }

    public function surveyQuestion()
    {
        return $this->belongsTo(SurveyQuestion::class);
    }

    public function surveyQuestion2()
    {
        return $this->belongsTo(SurveyQuestion::class, 'survey_question_id_2');
    }
}