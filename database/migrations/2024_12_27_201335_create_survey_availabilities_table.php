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
        Schema::create('survey_availabilities', function (Blueprint $table) {
            $table->uuid('id')->primary()->unique();
            $table->enum('category', ['Power SKU', 'Harga Kompetitif'])->default('Power SKU');;
            $table->foreignUuid('survey_question_id')->references('id')->on('survey_questions');
            $table->foreignUuid('survey_question_id_2')->references('id')->on('survey_questions')->nullable();
            $table->foreignUuid('product_id')->references('id')->on('products');
            $table->string("produk_name")->nullable();;
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('survey_availabilities');
    }
};
