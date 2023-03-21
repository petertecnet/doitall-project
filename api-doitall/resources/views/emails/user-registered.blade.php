@component('mail::message')
# Introduction
Teste

@component('mail::button', ['url' => 'localhost:8000'])
Button Text
@endcomponent

Obrigado Teste,<br>
{{ config('app.name') }}
@endcomponent
