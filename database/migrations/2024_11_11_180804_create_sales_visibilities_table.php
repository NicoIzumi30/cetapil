<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
    {
        // Create visibility entries table
        Schema::create('sales_visibilities', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('sales_activity_id');
            $table->enum('category', ['CORE', 'BABY','COMPETITOR']);
            $table->enum('type', ['PRIMARY', 'SECONDARY','COMPETITOR']);
            $table->integer('position'); // 1, 2, 3 etc.
            $table->uuid('posm_type_id')->nullable();
            $table->string('visual_type')->nullable();
            $table->enum('condition', ['GOOD', 'BAD'])->nullable();
            $table->string('competitor_brand_name')->nullable();
            $table->text('competitor_promo_mechanism')->nullable();
            $table->date('competitor_promo_start')->nullable();
            $table->date('competitor_promo_end')->nullable();
            $table->integer('shelf_width')->nullable();
            $table->integer('shelving')->nullable();
            $table->enum('has_secondary_display', ['Y', 'N'])->nullable();
            $table->string('display_photo')->nullable();
            $table->string('display_photo_2')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->foreign('sales_activity_id')
                  ->references('id')
                  ->on('sales_activities');

            $table->foreign('posm_type_id')
                  ->references('id')
                  ->on('posm_types');
        });
    }

    public function down()
    {
        Schema::dropIfExists('sales_visibilities');
    }
};
