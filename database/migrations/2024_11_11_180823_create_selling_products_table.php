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
        Schema::create('selling_products', function (Blueprint $table) {
            $table->uuid('id')->primary()->unique();
            $table->foreignUuid('selling_id')->references('id')->on('sellings');
            $table->foreignUuid('product_id')->references('id')->on('products');
            $table->string('product_name')->nullable();
            $table->integer('stock')->default(0);
            $table->integer('selling')->default(0);
            $table->integer('balance')->default(0);
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
        Schema::dropIfExists('selling_products');
    }
};
