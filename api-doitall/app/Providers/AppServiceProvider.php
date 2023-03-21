<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Validator;
class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        Validator::extend('cpf', function ($attribute, $value, $parameters, $validator) {
            $cpf = preg_replace('/[^0-9]/', '', $value);

            // Verifica se o CPF possui 11 caracteres
            if (strlen($cpf) != 11) {
                return false;
            }

            // Verifica se todos os dígitos são iguais
            if (preg_match('/(\d)\1{10}/', $cpf)) {
                return false;
            }

            // Verifica se o primeiro dígito verificador é válido
            $sum = 0;
            for ($i = 0; $i < 9; $i++) {
                $sum += ((10 - $i) * intval($cpf[$i]));
            }
            $mod = $sum % 11;
            if ($mod < 2) {
                $digit = 0;
            } else {
                $digit = 11 - $mod;
            }
            if ($digit != $cpf[9]) {
                return false;
            }

            // Verifica se o segundo dígito verificador é válido
            $sum = 0;
            for ($i = 0; $i < 10; $i++) {
                $sum += ((11 - $i) * intval($cpf[$i]));
            }
            $mod = $sum % 11;
            if ($mod < 2) {
                $digit = 0;
            } else {
                $digit = 11 - $mod;
            }
            if ($digit != $cpf[10]) {
                return false;
            }

            return true;
        });
    }

}
