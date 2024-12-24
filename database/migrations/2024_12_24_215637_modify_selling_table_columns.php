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
        Schema::table('sellings', function (Blueprint $table) {
            // Drop existing columns
            $table->dropColumn(['outlet_name', 'category_outlet']);

            $table->foreignUuid('outlet_id')->references('id')->on('outlets');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('sellings', function (Blueprint $table) {
            // Remove foreign key and column
            $table->dropForeign(['outlet_id']);
            $table->dropColumn('outlet_id');

            // Restore original columns
            $table->varchar('outlet_name', 255);
            $table->varchar('category_outlet', 255)->default('MT');
        });
    }
};
