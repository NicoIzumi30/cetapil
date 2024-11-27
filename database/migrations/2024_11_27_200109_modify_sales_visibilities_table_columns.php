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
        Schema::table('sales_visibilities', function (Blueprint $table) {
            $table->foreignUuid('sales_activity_id')->references('id')->on('sales_activities');
            $table->dropColumn([
                'filename',
                'path'
            ]);

            $table->string('filename1')->nullable();
            $table->string('path1')->nullable();

            $table->string('filename2')->nullable();
            $table->string('path2')->nullable();
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
