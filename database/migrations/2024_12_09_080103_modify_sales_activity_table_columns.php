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
        // Add columns to sales_activities table
        Schema::table('sales_activities', function (Blueprint $table) {
            $table->decimal('latitude', 10, 8)->nullable()->after('checked_out');
            $table->decimal('longitude', 11, 8)->nullable()->after('latitude');
            $table->decimal('radius', 10, 2)->nullable()->after('longitude')->comment('Distance from outlet in meters');
            $table->enum('radius_status', ['ONSITE', 'OFFSITE'])->nullable()->after('radius');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {

        Schema::table('sales_activities', function (Blueprint $table) {
            $table->dropColumn(['latitude', 'longitude', 'radius', 'radius_status']);
        });
    }
};
