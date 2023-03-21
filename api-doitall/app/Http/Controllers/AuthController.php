<?php

namespace App\Http\Controllers;

use Exception;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Password;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Mail;
use App\Mail\VerificationCodeMail;
use App\Mail\VerificationCodePasswordMail;
use Illuminate\Support\Carbon;

class AuthController extends Controller
{



    function register(Request $request){
        $rules = [
            'name' => 'required|string',
            'email' => 'required|email|unique:users,email,'.$request->id,
            'phone' => 'required|string|regex:/^\d{11}$/',
            'cpf' => 'required|cpf|unique:users,cpf,'.$request->id,

        ];

        $messages = [
            'name.required' => 'O nome não pode ser vazio.',
            'cpf.required' => 'O CPF não pode ser vazio',
            'cpf.cpf' => 'O CPF informádo é inválido',
            'cpf.unique' => 'Este CPF já está sendo utilizado por outro usuário.',
            'email.required' => 'O email não pode ser vazio.',
            'email.email' => 'O email informado é inválido.',
            'email.unique' => 'Este email já está sendo utilizado por outro usuário.',
            'phone.required' => 'O número de telefone não pode ser vazio.',
            'phone.regex' => 'O número de telefone informado é inválido. Informe o DDD e o restante do telefone respeitando o formato XXXXXXXXXX'
        ];
        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()->first(), 'status'=> 400]);
        }else{



            $user = new User();
            $user->name = $request->name;
            $user->phone = $request->phone;
            $user->cpf = $request->cpf;
            $user->email = $request->email;
            $user->password = Hash::make($request->password);
            $user->verification_code = mt_rand(100000, 999999);
            $user->save();
            Mail::to($user->email)->send(new VerificationCodeMail($user->name, $user->verification_code));
            $response=['status' => 200, 'message' => 'Usuario registrado com sucesso', 'user'=> $user];
            return response()->json($response);

         }
    }
    function Login(Request $R){
        $user = User::where('email', $R->email)->first();
        if(!$user){
            $response = ['status'=> 500, 'message'=> 'Email ou senha incorretos!'];
            return response()->json($response);
        }

        if($user !='[]' && Hash::check($R->password,$user->password)){
            $token = $user->createToken('Personal Acess Token')->plainTextToken;
            $response = ['status'=> 200, 'token'=> $token, 'user'=> $user, 'message'=> 'Login efetuado com sucesso'];
            return response()->json($response);
        }else{

            $response = ['status'=> 500, 'message'=> 'Email ou senha incorretos!'];
            return response()->json($response);
        }
    }

    function Reset(Request $R){
        $user = User::where('email', $R->email)->first();

        if($user !='[]'){
            $token = $user->createToken('Personal Acess Token')->plainTextToken;
            $response = ['status'=> 200, 'token'=> $token, 'user'=> $user, 'message'=> 'Login efetuado com sucesso'];
            return response()->json($response);
        }else{

            $response = ['status'=> 500, 'message'=> 'Email ou senha incorretos!'];
            return response()->json($response);
        }
    }

   public function List(){
        try{
            $users = User::all();
            $response=['status' => 200, 'users' => $users];
            return response()->json($response);
        }catch(Exception $e){

            $response = ['status'=> 500, 'message'=> $e];
        }
    }
        /* Funções de envio de link para mudança de senha
    /**
     * Send a reset link to the given user.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\RedirectResponse|\Illuminate\Http\JsonResponse
     */
    public function sendResetLinkEmail(Request $request)
    {
        $this->validateEmail($request);

        $response = $this->broker()->sendResetLink(
            $this->credentials($request)
        );

         $response == Password::RESET_LINK_SENT
                    ? $this->sendResetLinkResponse($request, $response)
                    : $this->sendResetLinkFailedResponse($request, $response);

                    $response = ['status'=> 200, 'message'=> 'Email enviado com sucesso'];
                    return response()->json($response);
    }

    /**
     * Validate the email for the given request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return void
     */
    protected function validateEmail(Request $request)
    {
        $request->validate(['email' => 'required|email']);
    }

    /**
     * Get the needed authentication credentials from the request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    protected function credentials(Request $request)
    {
        return $request->only('email');
    }

    /**
     * Get the response for a successful password reset link.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  string  $response
     * @return \Illuminate\Http\RedirectResponse|\Illuminate\Http\JsonResponse
     */
    protected function sendResetLinkResponse(Request $request, $response)
    {
         $request->wantsJson()
                    ? new JsonResponse(['message' => 'Email enviado com sucesso'], 200)
                    : back()->with('status', trans($response));
                    return response()->json($response);
    }

    /**
     * Get the response for a failed password reset link.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  string  $response
     * @return \Illuminate\Http\RedirectResponse
     *
     * @throws \Illuminate\Validation\ValidationException
     */


    /**
     * Get the broker to be used during password reset.
     *
     * @return \Illuminate\Contracts\Auth\PasswordBroker
     */
    public function broker()
    {
        return Password::broker();
    }
    /**Funções para  reenvio de email para verificação */
    public function resend(Request $request)
    {
        $id = $request->id;
        $user= User::find($id);


        $user->sendEmailVerificationNotification();


                    $response = ['status'=> 200, 'message'=> 'Email enviado com sucesso',  'user'=> $user];
                    return response()->json($response);
    }

  

    public function sendemailcode(Request $request){


        $user = User::findOrFail($request->id);
        $user->verification_code = mt_rand(100000, 999999);
        $user->save();
        Mail::to($user->email)->send(new VerificationCodeMail($user->name, $user->verification_code));


        return response()->json(['message' => 'Um novo codigo de verificação enviado  para o email: '.$user->email. 'com sucesso', 'status'=> 200, 'user' => $user]);


    }
    public function codevalidation(Request $request){

        $user = User::findOrFail($request->id);
        if($user->verification_code == $request->verification_code)
        {
            $user->email_verified_at = Carbon::now();
            $user->verification_code = mt_rand(100000, 999999);
            $user->save();
            return response()->json(['message' => 'Codigo de verificação confirmado com sucesso', 'status'=> 200, 'user' => $user]);


        }else{

            return response()->json(['message' => 'Codigo de verificação incorreto', 'status'=> 400, 'user' => $user]);

        }
    }
    public function sendCodeForgotPassword(Request $request){



        $user = User::where('email', $request->email)->first();
        if(!$user){
        return response()->json(['message' => 'O email: '.$request->email. 'não se encontra em nossa base de dados. Faça um novo cadastro!', 'status'=> 400]);
        }

        $user->forgotpassword_code = mt_rand(100000, 999999);
        $user->save();
        Mail::to($user->email)->send(new VerificationCodePasswordMail($user->name, $user->forgotpassword_code));


        return response()->json(['message' => 'Um novo codigo de verificação enviado  para o email: '.$user->email. 'com sucesso', 'status'=> 200, 'user' => $user]);


    }

    public function codevalidationPassword(Request $request){

        $user = User::where('email', $request->email)->first();
        if(!$user){
        return response()->json(['message' => 'O email: '.$request->email. 'não se encontra em nossa base de dados. Faça um novo cadastro!', 'status'=> 400]);
        }
        if($user->forgotpassword_code == $request->forgotpassword_code)
        {
            $user->forgotpassword_code = mt_rand(100000, 999999);
            $user->password = Hash::make($request->password);
            $user->save();
            return response()->json(['message' => 'Senha alterada com sucesso', 'status'=> 200, 'user' => $user]);


        }else{

            return response()->json(['message' => 'Codigo de verificação incorreto', 'status'=> 400, 'user' => $user]);

        }
    }
}
