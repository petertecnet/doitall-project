<?php

namespace App\Http\Controllers;

use App\Mail\VerificationUpdateEmailCodeMail;
use App\Models\Image;
use App\Models\User;
use Carbon\Carbon;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\File;
 use GuzzleHttp\Client;

class UserController extends Controller
{
    public function updateImage(Request $request)
    {
        $user = User::findOrFail($request->id);

        if (!$user) {
            return response()->json(['message' => 'Não autorizado.', 'status' => 401]);
        }

        if (!$request->avatar) {
            return response()->json(['message' => 'Arquivo de imagem não enviado.', 'status' => 400, 'user'=> $user]);
        }

        $avatar = $request->avatar;
        if (!$avatar->isValid() || !in_array($avatar->getClientOriginalExtension(), ['jpg', 'jpeg', 'png', 'gif'])) {
            return response()->json(['message' => 'Arquivo de imagem inválido.', 'status' => 400]);
        }

        $fileName = $user->id.'-'.$user->cpf. '-avatar.' . $avatar->getClientOriginalExtension();
        $directoryName = $user->id . '-' . $user->cpf;

        $directoryPath = public_path('avatars/' . $directoryName);

        if (!File::exists($directoryPath)) {
            File::makeDirectory($directoryPath, 0755, true);
        }

        // Check if there's a file with the same name as the uploaded file
        if (File::exists($directoryPath . '/' . $avatar->getClientOriginalName())) {

            // Generate a new unique file name by adding a number to the end of the original file name
            $count = 1;
            $newFileName = pathinfo($avatar->getClientOriginalName(), PATHINFO_FILENAME) . '_' . $count . '.' . $avatar->getClientOriginalExtension();

            while (File::exists($directoryPath . '/' . $newFileName)) {
                $count++;
                $newFileName = pathinfo($avatar->getClientOriginalName(), PATHINFO_FILENAME) . '_' . $count . '.' . $avatar->getClientOriginalExtension();
            }

            // Rename the existing file with the new unique name
            File::move($directoryPath . '/' . $avatar->getClientOriginalName(), $directoryPath . '/' . $newFileName);
        }

        $avatar->move($directoryPath, $fileName);
        $user->avatar = $fileName;
        $user->save();
        $image = New Image();
        $image->name = $fileName;
        $image->origin = 'user';
        $image->type = 'avatar';
        $image->origin_id = $user->id;
        $image->save();

        return response()->json(['message' => 'Sua imagem foi atualizada com sucesso.', 'status' => 200, 'user' => $user]);
    }



    public function update(Request $request)
    {
        $rules = [
            'name' => 'required|string',
            'email' => 'required|email|unique:users,email,' . $request->id,
            'phone' => 'required|string|regex:/^\d{11}$/',
            'cpf' => 'required|cpf|unique:users,cpf,' . $request->id,
            'newPassword' => 'string|min:8|regex:/^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+])[A-Za-z0-9!@#$%^&*()_+]+$/',

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
            'phone.regex' => 'O número de telefone informado é inválido. Informe o DDD e o restante do telefone respeitando o formato XXXXXXXXXX',
            'newPassword.min' => 'A senha deve ter no mínimo :min caracteres.',
            'newPassword.regex' => 'A senha deve conter pelo menos uma letra maiúscula, um número e um caractere especial (!@#$%^&*()_+).',

        ];



        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()->first(), 'status' => 400]);
        }

        $user = User::findOrFail($request->id);


            if ($request->email != $user->email) {

                $email= $user->email;
                $user->temporaryemail = $request->email;
                $user->fill($request->all());
                $user->email = $email;
                $user->verification_code = mt_rand(100000, 999999);
                Mail::to($request->email)->send(new VerificationUpdateEmailCodeMail($user->name, $user->verification_code));
                $user->save();
                return response()->json(['message' => 'Usuário atualizado com sucesso. Como o email foi  alterado, será necessário confirmação de email para concluir a atenração.', 'status' => 200, 'user' => $user]);
            }


        if ($request->newPassword && $request->currentlyPassword) {

            if (Hash::check($request->newPassword, $user->password)) {
                return response()->json(['message' => 'A senha digita é a mesma que a antiga', 'status' => 400, 'user' => $user]);
            }
            if (Hash::check($request->currentlyPassword, $user->password)) {
                $user->password = Hash::make($request->newPassword);
                $user->save();
                return response()->json(['message' => 'Senha foi  alterada com sucesso', 'status' => 200, 'user' => $user]);
            }
            if (!(Hash::check($request->currentlyPassword, $user->password))) {
                return response()->json(['message' => 'A senha digitada esta incorreta!', 'status' => 400, 'user' => $user]);
            }
        } else {
            $user->fill($request->all());
            $user->save();

            return response()->json(['message' => 'Dados pessoais atualizado com sucesso ', 'status' => 200, 'user' => $user]);
        }
    }
    public function updateAddress(Request $request)
    {
        $rules = [
            'complement' => 'required|string',
            'cep' => 'required|string',
        ];
        $messages = [
            'complement.required' => 'O complemento não pode ser vazio. Voce pode adicionar o numero, lote, apatarmento e nome do edificio ',
            'cep.required' => 'O CEP não pode ser vazio.',
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()->first(), 'status' => 400]);
        }

        $user = User::findOrFail($request->id);
        if (!$user) {
            return response()->json(['message' => 'Não autorizado.', 'status' => 401]);
        }

        $client = new \GuzzleHttp\Client();
        $res = $client->request('GET', 'https://viacep.com.br/ws/'.$request->cep.'/json/');
        $json = $res->getBody();
        $data = json_decode($json, true);
        $user->uf = $data['uf'];
        $user->city = $data['localidade'];
        $user->street = $data['logradouro'];
        $user->neighborhood = $data['bairro'];
$user->cep = $request->cep;
$user->complement = $request->complement;
        $user->fill($request->all());
        $user->save();

        return response()->json(['message' => 'Endereço atualizado com sucesso', 'status' => 200, 'user' => $user]);
    }

    public function changeemailcodevalidation(Request $request){

        $user = User::findOrFail($request->id);
        if($user->verification_code == $request->verification_code)
        {
            $user->email_verified_at = Carbon::now();
            $lastemail = $user->email;
            $user->email = $user->temporaryemail;
            $user->lastemail = $lastemail;

            $user->temporaryemail = null;
            $user->verification_code = mt_rand(100000, 999999);
            $user->save();
            return response()->json(['message' => 'Email alterado com sucesso', 'status'=> 200, 'user' => $user]);


        }else{

            return response()->json(['message' => 'Codigo de verificação incorreto!', 'status'=> 400, 'user' => $user]);

        }
    }
    public function show(Request $request)
    {
        $user= User::find($request->user_id);


                    $response = ['status'=> 200, 'message'=> 'Usuário encontrado com sucesso',  'user'=> $user];
                    return response()->json($response);
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
}
