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
        Schema::create('planograms', function (Blueprint $table) {
            $table->uuid('id')->primary()->unique();
            $table->foreignUuid('channel_id')->references('id')->on('channels');
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
        Schema::dropIfExists('planograms');
    }
};
