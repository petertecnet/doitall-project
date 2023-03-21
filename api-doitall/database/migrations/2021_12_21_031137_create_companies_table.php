<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateCompaniesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('companies', function (Blueprint $table) {
            $table->id();
            $table->integer('user_id')->unsigned()->nullable();
            $table->string('name')->nullable();
            $table->string('logo')->nullable();
            $table->string('cnpj')->nullable();
            $table->string('cep')->nullable();
            $table->string('address')->nullable();
            $table->string('city',60)->nullable();
            $table->string('uf',2)->nullable();
            $table->string('email')->nullable();
            $table->string('phone',60)->nullable();
            $table->string('opendate',60)->nullable();
            $table->string('lastupdate',60)->nullable();
            $table->string('jurisnature',60)->nullable();
            $table->string('complement',60)->nullable();
            $table->string('type',60)->nullable();
            $table->string('fantasyname',60)->nullable();
            $table->string('neiborhood',60)->nullable();
            $table->string('socialcapital',60)->nullable();
            $table->string('status',60)->nullable();
            $table->string('size',60)->nullable();
            $table->string('addressnumber',60)->nullable();
            $table->json('employers')->nullable();
            $table->rememberToken();
            $table->timestamps();
            $table->softDeletes();
        });

    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('companies');
    }

}
