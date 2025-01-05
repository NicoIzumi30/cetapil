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

            $table->integer('price')->default(0);
            $table->integer('qty')->default(0);
            $table->integer('total')->default(0);
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
