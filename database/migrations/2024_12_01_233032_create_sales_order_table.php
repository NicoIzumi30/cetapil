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
        Schema::create('sales_orders', function (Blueprint $table) {
            $table->uuid('id')->primary()->unique();
            $table->foreignUuid('sales_activity_id')->references('id')->on('sales_activities');
            $table->foreignUuid('outlet_id')->references('id')->on('outlets');
            $table->foreignUuid('product_id')->references('id')->on('products');
            $table->integer('total_items')->default(0);
            $table->integer('subtotal')->default(0);
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('sales_order');
    }
};
