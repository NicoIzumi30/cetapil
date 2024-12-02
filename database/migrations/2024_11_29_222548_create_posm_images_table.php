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
        Schema::create('posm_images', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('posm_type_id');
            $table->foreign('posm_type_id')
                  ->references('id')
                  ->on('posm_types')
                  ->onDelete('cascade');
            $table->text('image');
            $table->text('path');
            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('posm_images');
    }
};
