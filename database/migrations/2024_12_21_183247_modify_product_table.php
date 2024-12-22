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

        Schema::table('products', function (Blueprint $table) {
            // Remove existing columns
            $table->dropColumn(['md_price', 'sales_price']);

            // Add new price column
            $table->integer('price')->after('sku');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('products', function (Blueprint $table) {
            // Reverse the changes by adding back the old columns
            $table->decimal('md_price', 10, 2)->after('sku');
            $table->decimal('sales_price', 10, 2)->after('md_price');

            // Remove the new column
            $table->dropColumn('price');
        });
    }
};
