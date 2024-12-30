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
            // Add check-in timestamp
            $table->timestamp('checked_in')->nullable()->after('id');

            // Add check-out timestamp
            $table->timestamp('checked_out')->nullable()->after('checked_in');

            // Add duration in minutes
            $table->integer('duration')->nullable()->after('checked_out')
                ->comment('Duration of the selling activity in seconds');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('sellings', function (Blueprint $table) {
            // Drop the added columns if migration needs to be rolled back
            $table->dropColumn(['checked_in', 'checked_out', 'duration']);
        });
    }
};
