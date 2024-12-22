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
        Schema::table('av3ms', function (Blueprint $table) {
            // Drop the foreign key constraint first
            $table->dropForeign('av3ms_channel_id_foreign');

            // Drop the channel_id column
            $table->dropColumn('channel_id');

            // Add outlet_id column with foreign key reference

            $table->foreignUuid('outlet_id')->references('id')->on('outlets');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('av3ms', function (Blueprint $table) {
            // Drop the new foreign key and column
            $table->dropForeign(['outlet_id']);
            $table->dropColumn('outlet_id');
            $table->foreignUuid('outlet_id')->references('id')->on('outlets');

        });
    }
};
