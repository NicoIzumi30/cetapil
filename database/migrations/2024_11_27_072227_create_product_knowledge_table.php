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
        Schema::create('product_knowledge', function (Blueprint $table) {
            $table->uuid('id')->primary()->unique();
            $table->foreignUuid('channel_id')->references('id')->on('channels');
            $table->string('filename_pdf')->nullable();
            $table->string('path_pdf')->nullable();
            $table->string('filename_video')->nullable();
            $table->string('path_video')->nullable();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('product_knowledge');
    }
};
