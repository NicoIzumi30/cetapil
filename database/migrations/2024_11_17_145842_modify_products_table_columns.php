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
            // Menghapus kolom-kolom yang tidak diperlukan
            $table->dropForeign(['product_account_type_id']);
            
            // Menghapus kolom-kolom yang tidak diperlukan
            $table->dropColumn([
                'product_account_type_id',
                'average_stock',
                'filename',
                'path'
            ]);


            // Menambahkan kolom baru
            $table->integer('md_price')->after('sku');
            $table->integer('sales_price')->after('md_price');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('products', function (Blueprint $table) {
            $table->foreignUuid("product_account_type_id")->nullable()->references('id')->on('product_account_types')->after('sku');
            $table->integer('average_stock')->nullable()->after('product_account_type_id');
            $table->string('filename')->nullable()->after('average_stock');
            $table->string('path')->nullable()->after('filename');

            $table->dropColumn(['md_price', 'sales_price']);
        });
    }
};
