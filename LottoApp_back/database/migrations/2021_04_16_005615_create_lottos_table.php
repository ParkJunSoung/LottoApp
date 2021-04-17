<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateLottosTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('lottos', function (Blueprint $table) {
            $table->id();
            $table->bigInteger('drwNo')->comment('로또 회차');
            $table->date('drwNoDate')->comment('추첨일');
            $table->bigInteger('totSellamnt')->comment('총 상금액');
            $table->bigInteger('firstWinamnt')->comment('1등 상금액');
            $table->integer('firstPrzwnerCo')->comment('1등 담청인원');
            $table->bigInteger('firstAccumamnt');
            $table->integer('drwtNo1')->comment('로또번호1');
            $table->integer('drwtNo2')->comment('로또번호2');
            $table->integer('drwtNo3')->comment('로또번호3');
            $table->integer('drwtNo4')->comment('로또번호4');
            $table->integer('drwtNo5')->comment('로또번호5');
            $table->integer('drwtNo6')->comment('로또번호6');
            $table->integer('bnusNo')->comment('보너스번호');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('lottos');
    }
}
