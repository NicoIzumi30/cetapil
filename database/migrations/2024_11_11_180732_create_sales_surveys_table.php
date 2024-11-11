<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('sales_surveys', function (Blueprint $table) {
            $table->uuid('id')->primary()->unique();
            $table->foreignUuid('sales_activity_id')->references('id')->on('sales_activities');
            $table->foreignUuid('survey_question_id')->references('id')->on('survey_questions');
            $table->string('answer');
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('sales_surveys');
    }
};
