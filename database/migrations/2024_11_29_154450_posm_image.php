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
        Schema::create('posm_image', function (Blueprint $table) {
            $table->uuid('id')->primary()->unique();
            $table->foreignUuid('posm_type_id')->references('id')->on('posm_types'); // Changed from posm_type to posm_types
            $table->text('image');
            $table->softDeletes();
            $table->timestamps(); // Added timestamps since most Laravel models use them
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('posm_image'); // Added proper down method
    }
};