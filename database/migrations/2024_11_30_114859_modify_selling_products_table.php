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
            $table->integer('price')->default(0);
        });
        Schema::table('sellings', function (Blueprint $table) {
            $table->string('category_outlet')->default("MT");
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        //
    }
};
