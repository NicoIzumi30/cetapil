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
        Schema::create('survey_questions', function (Blueprint $table) {
            $table->uuid('id')->primary()->unique();
            $table->foreignUuid('survey_category_id')->references('id')->on('survey_categories');
            $table->foreignUuid('product_id')->nullable()->references('id')->on('products');
            $table->enum('type', ['bool', 'text']);
            $table->text('question');
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('selling_questions');
    }
};
