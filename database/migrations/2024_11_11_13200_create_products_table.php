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
        Schema::create('products', function (Blueprint $table) {
            $table->uuid('id')->primary()->unique();
            $table->foreignUuid("category_id")->references('id')->on('categories');
            $table->foreignUuid("product_account_type_id")->nullable()->references('id')->on('product_account_types');
            $table->string("sku")->unique();
            $table->integer("average_stock")->default(0);
            $table->string("filename")->nullable();
            $table->string("path")->nullable();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};
