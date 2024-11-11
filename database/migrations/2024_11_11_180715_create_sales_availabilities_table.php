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
            $table->foreignUuid('outlet_id')->references('id')->on('outlets');
            $table->foreignUuid('product_id')->references('id')->on('products');
            $table->integer('availability_stock')->default(0);
            $table->integer('average_stock')->default(0);
            $table->integer('ideal_stock')->default(0);
            $table->boolean('status')->default(1);
            $table->enum('detail', ['IDEAL', 'MINUS', 'OVER']);
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
