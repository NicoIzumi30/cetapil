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
        Schema::table('product_knowledge', function (Blueprint $table) {
            // First drop the foreign key constraint
            $table->dropForeign('product_knowledge_channel_id_foreign');
            // Then drop the column
            $table->dropColumn('channel_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('product_knowledge', function (Blueprint $table) {
            // Recreate the column
            $table->char(36)->nullable();
            // Recreate the foreign key
            $table->foreign('channel_id')->references('id')->on('channels');
        });
    }
};
