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
        Schema::create('visibilities', function (Blueprint $table) {
            $table->uuid('id')->primary()->unique();
            $table->foreignUuid('outlet_id')->references('id')->on('outlets');
            $table->foreignUuid('user_id')->references('id')->on('users');
            $table->foreignUuid('product_id')->references('id')->on('products');
            $table->foreignUuid('city_id')->references('id')->on('cities');
            $table->foreignUuid('posm_type_id')->references('id')->on('posm_types');
            $table->foreignUuid('visual_type_id')->references('id')->on('visual_types');
            $table->string('filename')->nullable();
            $table->string('path')->nullable();
            $table->date('program_date')->after('path');
            $table->string('banner', 255)->nullable()->after('program_date');
            $table->timestamp('started_at')->nullable();
            $table->timestamp('ended_at')->nullable();
            $table->enum('status', ['ACTIVE', 'INACTIVE'])->default('ACTIVE')->nullable();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('visibilities');
    }
};
