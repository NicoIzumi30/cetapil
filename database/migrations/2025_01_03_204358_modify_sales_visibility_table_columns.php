<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('sales_visibilities', function (Blueprint $table) {
            $table->string('competitor_brand_name')->nullable();
            $table->text('competitor_promo_mechanism')->nullable();
            $table->date('competitor_promo_start')->nullable();
            $table->date('competitor_promo_end')->nullable();
            $table->string('display_photo_2')->nullable();

            // Alter existing enum columns to add 'COMPETITOR' option
            DB::statement("ALTER TABLE sales_visibilities MODIFY COLUMN category ENUM('CORE', 'BABY', 'COMPETITOR') NULL");
            DB::statement("ALTER TABLE sales_visibilities MODIFY COLUMN type ENUM('PRIMARY', 'SECONDARY', 'COMPETITOR') NULL");
        });
    }

    public function down()
    {
        Schema::table('sales_visibilities', function (Blueprint $table) {
            $table->dropColumn([
                'competitor_brand_name',
                'competitor_promo_mechanism',
                'competitor_promo_start',
                'competitor_promo_end',
                'display_photo',
                'display_photo_2'
            ]);

            // Revert enum columns back to original values
            DB::statement("ALTER TABLE sales_visibilities MODIFY COLUMN category ENUM('CORE', 'BABY') NULL");
            DB::statement("ALTER TABLE sales_visibilities MODIFY COLUMN type ENUM('PRIMARY', 'SECONDARY') NULL");
        });
    }
};
