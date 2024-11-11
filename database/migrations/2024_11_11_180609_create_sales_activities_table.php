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
        Schema::create('sales_activities', function (Blueprint $table) {
            $table->uuid('id')->primary()->unique();
            $table->foreignUuid('outlet_id')->references('id')->on('outlets');
            $table->foreignUuid('user_id')->references('id')->on('users');
            $table->timestamp('checked_in')->nullable();
            $table->timestamp('checked_out')->nullable();
            $table->integer('views')->default(0);
            $table->enum('status', ['IN_PROGRESS', 'SUBMITTED', 'CANCELLED'])->default('IN_PROGRESS');
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('sales_activities');
    }
};
