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
        Schema::create('sellings', function (Blueprint $table) {
            $table->uuid('id')->primary()->unique();
            $table->foreignUuid('user_id')->references('id')->on('users');
            $table->string('outlet_name');
            $table->string('longitude');
            $table->string('latitude');
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
        Schema::dropIfExists('sellings');
    }
};
