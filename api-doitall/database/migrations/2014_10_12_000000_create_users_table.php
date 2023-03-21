<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->tinyInteger('status')->default(1)->comment('0 bloqueado - 1 liberado - 2 pendente');
            $table->tinyInteger('role')->default(0)->comment('0-Paciente - 1-Funcionario - 2-Administrador');
            $table->string('name',50);
            $table->string('phone',50)->default(0);
            $table->integer('company_id')->unsigned()->nullable();
            $table->string('cpf',11)->default(0);
            $table->string('cep',8)->default(0);
            $table->string('address')->default(0);
            $table->string('city',60)->default(0);
            $table->string('street',60)->default(0);
            $table->string('neighborhood',60)->default(0);
            $table->string('complement',60)->default(0);
            $table->string('uf',2)->default(0);
            $table->string('email',150)->unique();
            $table->string('temporaryemail')->default(0);
            $table->string('avatar')->default(0);
            $table->string('lastemail')->default(0);
            $table->string('verification_code')->default(0);
            $table->string('forgotpassword_code')->default(0);
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');
            $table->uuid('uid')->default(0);
            //
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
        Schema::dropIfExists('users');
    }
};
