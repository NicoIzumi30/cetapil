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
        Schema::create('sales_availabilities', function (Blueprint $table) {
            $table->uuid('id')->primary()->unique();
            $table->foreignUuid('sales_activity_id')->references('id')->on('sales_activities');
            $table->foreignUuid('outlet_id')->references('id')->on('outlets');
            $table->foreignUuid('product_id')->references('id')->on('products');
            $table->integer('stock_on_hand')->default(0);
            $table->integer('stock_inventory')->default(0);
            $table->integer('av3m')->default(0);

            $table->enum('status', ['IDEAL', 'MINUS', 'OVER'])->nullable();
            $table->integer('rekomendasi')->nullable(); // Can be minus
            $table->enum('availability', ['Y', 'N'])->default('N');

            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('sales_availabilities');
    }
};
