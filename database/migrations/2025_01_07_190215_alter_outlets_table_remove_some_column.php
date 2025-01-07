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
        Schema::table('outlets', function (Blueprint $table) {
            $table->dropColumn('week');
            $table->dropColumn('cycle');
            $table->dropColumn('visit_day');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('outlets', function (Blueprint $table) {
            $table->enum('cycle', ['1x1', '1x2', '1x4'])->default('1x1');
            $table->enum('week', ['1', '2', '3', '4', '1&3', '2&4'])->nullable();
            $table->char('visit_day', 1);
        });
    }
};
