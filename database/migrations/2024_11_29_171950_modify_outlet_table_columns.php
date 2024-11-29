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
        // Schema::table('outlets', function (Blueprint $table) {
        //     $table->uuid('channel_id')->nullable();
        // });

        Schema::table('outlets', function (Blueprint $table) {
            $table->foreignUuid('channel_id')->nullable()->references('id')->on('channels');
            $table->dropColumn('channel');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('outlets', function (Blueprint $table) {
            $table->dropForeign(['channel_id']);
            $table->string('channel');
            $table->dropColumn('channel_id');
        });
    }
};
