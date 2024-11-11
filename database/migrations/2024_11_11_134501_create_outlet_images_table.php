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
        Schema::create('outlet_images', function (Blueprint $table) {
            $table->uuid('id')->primary()->unique();
            $table->foreignUuid('outlet_id')->references('id')->on('outlets');
            $table->integer('position');
            $table->string('filename');
            $table->string('path');
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('outlet_images');
    }
};
