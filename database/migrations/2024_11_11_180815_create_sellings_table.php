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
            $table->foreignUuid('outlet_id')->references('id')->on('outlets');
            $table->foreignUuid('user_id')->references('id')->on('users');
            $table->timestamp('checked_in')->nullable();
            $table->timestamp('checked_out')->nullable();
            $table->integer('duration')->nullable()
                ->comment('Duration of the selling activity in seconds');
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
