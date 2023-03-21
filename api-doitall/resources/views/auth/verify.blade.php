{{ __('Please click the button below to verify your email address.') }}

@component('mail::button', ['url' => route('verification.verify', ['id' => $user->id, 'code' => $user->verification_code])])
Verify Email
@endcomponent

{{ __('If you did not create an account, no further action is required.') }}

{{ __('Verification Code: ') }} {{ $user->verification_code }}
