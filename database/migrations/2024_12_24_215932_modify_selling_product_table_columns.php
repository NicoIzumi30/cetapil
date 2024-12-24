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
        Schema::table('selling_products', function (Blueprint $table) {
            $table->dropColumn(['stock', 'selling', 'balance', 'filename', 'path']);

            $table->integer('qty')->default(0);
            $table->integer('total')->default(0);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('selling_products', function (Blueprint $table) {
            $table->dropColumn(['qty', 'total']);

            $table->integer('stock')->default(0);
            $table->integer('selling')->default(0);
            $table->integer('balance')->default(0);
            $table->string('filename', 255)->nullable();
            $table->string('path', 255)->nullable();
        });
    }
};
