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
        Schema::create('sales_visibilities', function (Blueprint $table) {
            $table->uuid('id')->primary()->unique();
            $table->foreignUuid('visibility_id')->references('id')->on('visibilities');
            $table->enum('condition', ['GOOD', 'BAD']);
            $table->string('filename')->nullable();
            $table->string('path')->nullable();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('sales_visibilities');
    }
};
