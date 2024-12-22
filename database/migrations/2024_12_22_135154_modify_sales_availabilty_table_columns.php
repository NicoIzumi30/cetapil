<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('sales_availabilities', function (Blueprint $table) {
            // Rename columns
            $table->renameColumn('availability_stock', 'stock_on_hand');
            $table->renameColumn('average_stock', 'stock_inventory');
            $table->renameColumn('ideal_stock', 'av3m');

            // Drop detail column
            $table->dropColumn('detail');
            $table->dropColumn('status');

            // Add new columns
            $table->enum('status', ['IDEAL', 'MINUS', 'OVER'])->nullable();
            $table->integer('rekomendasi')->nullable(); // Can be minus
            $table->enum('availability', ['Y', 'N'])->default('N');
        });
    }

    public function down()
    {
        Schema::table('sales_availabilities', function (Blueprint $table) {
            // Reverse the changes
            $table->renameColumn('stock_on_hand', 'availability_stock');
            $table->renameColumn('stock_inventory', 'average_stock');
            $table->renameColumn('av3m', 'ideal_stock');

            // Recreate detail column
            $table->enum('detail', ['IDEAL', 'MINUS', 'OVER'])->nullable();

            // Remove new columns
            $table->dropColumn('rekomendasi');
            $table->dropColumn('availability');
        });
    }
};
