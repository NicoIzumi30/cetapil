<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('outlets', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('user_id');  // Buat kolom UUID dulu
            $table->foreign('user_id')  // Baru tambahkan foreign key
                ->references('id')
                ->on('users');  // Opsional
            $table->foreignUuid('city_id')->references('id')->on('cities');
            $table->foreignUuid('channel_id')->nullable()->references('id')->on('channels');
            $table->string('code')->nullable()->unique();
            $table->string('name');
            $table->text('tipe_outlet')->nullable();
            $table->text('account')->nullable();
            $table->string('category');
            $table->string('distributor')->nullable();
            $table->string('TSO')->nullable();
            $table->string('KAM')->nullable();
            $table->char('visit_day', 1);
            $table->string('longitude')->nullable();
            $table->string('latitude')->nullable();
            $table->text('address')->nullable();
            $table->enum('status', ['APPROVED', 'PENDING', 'REJECTED'])->default('PENDING');
            $table->enum('cycle', ['1x1', '1x2', '1x4'])->default('1x1');
            $table->enum('week', ['1', '2', '3', '4', '1&3', '2&4'])->nullable();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('outlets');
    }
};
