<?php

namespace App\Http\Controllers;

use App\Models\Company;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Mail;
use App\Mail\NewCompanyVerificationEmailCodeMail;
use Carbon\Carbon;
use Illuminate\Support\Facades\File;
use App\Models\Image;
use Respect\Validation\Validator as v;


class CompanyController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */



    public function index()
    {



    }
    public function updateImage(Request $request)
    {
        $user = User::findOrFail($request->user_id);
        $company = Company::findOrFail($user->company_id);

        if (!$user) {
            return response()->json(['message' => 'Não autorizado.', 'status' => 401]);
        }
        if (!$company) {
            return response()->json(['message' => 'Não autorizado.', 'status' => 401]);
        }

        if (!$request->logo) {
            return response()->json(['message' => 'Arquivo de imagem não enviado.', 'status' => 400, 'user'=> $user]);
        }

        $logo = $request->logo;
        if (!$logo->isValid() || !in_array($logo->getClientOriginalExtension(), ['jpg', 'jpeg', 'png', 'gif'])) {
            return response()->json(['message' => 'Arquivo de imagem inválido.', 'status' => 400]);
        }

        $fileName = $company->id.'-'.$company->cnpj. '-logo.' . $logo->getClientOriginalExtension();
        $directoryName = $company->id . '-' . $company->cnpj;

        $directoryPath = public_path('logos/' . $directoryName);

        if (!File::exists($directoryPath)) {
            File::makeDirectory($directoryPath, 0755, true);
        }

        // Check if there's a file with the same name as the uploaded file
        if (File::exists($directoryPath . '/' . $logo->getClientOriginalName())) {

            // Generate a new unique file name by adding a number to the end of the original file name
            $count = 1;
            $newFileName = pathinfo($logo->getClientOriginalName(), PATHINFO_FILENAME) . '_' . $count . '.' . $logo->getClientOriginalExtension();

            while (File::exists($directoryPath . '/' . $newFileName)) {
                $count++;
                $newFileName = pathinfo($logo->getClientOriginalName(), PATHINFO_FILENAME) . '_' . $count . '.' . $logo->getClientOriginalExtension();
            }

            // Rename the existing file with the new unique name
            File::move($directoryPath . '/' . $logo->getClientOriginalName(), $directoryPath . '/' . $newFileName);
        }

        $logo->move($directoryPath, $fileName);
        $company->logo = $fileName;
        $company->save();
        $image = New Image();
        $image->name = $fileName;
        $image->origin = 'company';
        $image->type = 'logo';
        $image->origin_id = $company->id;
        $image->save();

        return response()->json(['message' => 'Logo foi atualizada com sucesso.', 'status' => 200, 'user' => $user, 'company' => $company]);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {


    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */

     public function show(Request $request)
     {


        $user = User::find($request->user_id);
        $company = Company::find($user->company_id);
         if($company)
         {
            return response()->json(['message' => '', 'status' => 200, 'user'=> $user, 'company'=> $company]);
         }

     }
     public function showByCompany(Request $request)
     {


         $company = Company::find($request->company_id);
         if($company)
         {
            return response()->json(['message' => '', 'status' => 200,'company'=> $company]);
         }

     }
    public function store(Request $request)
{

    $isCnpjValid = v::cnpj()->validate($request->cnpj);

        if (!$isCnpjValid) {
            return response()->json([
                'message' => 'CNPJ inválido!!.',
                'status' => 400,
            ]);
        }

    $existingCompany = Company::where('cnpj', $request->cnpj)->first();
if ($existingCompany) {
    return response()->json([
        'message' => 'Já existe uma empresa cadastrada com este CNPJ.',
        'status' => 400,
    ]);
}

$user = User::findOrFail($request->userid);
if ($user->company_id != null) {
    return response()->json([
        'message' => 'Você já possui uma empresa cadastrada.',
        'status' => 400,
    ]);
}
    $rules = [
        'cnpj' => 'required|unique:companies,cnpj,'
    ];

    $messages = [
        'cnpj.unique' => 'O CNPJ informado já foi cadastrado por outra empresa.',
        'cnpj.required' => 'O campo CNPJ é obrigatório.',
    ];

    $validator = Validator::make($request->all(), $rules, $messages);

    if ($validator->fails()) {
        return response()->json([
            'message' => $validator->errors()->first(),
            'status' => 400,
        ]);
    }

    // Verifica se já existe uma empresa com o mesmo CNPJ
    $existingCompany = Company::where('cnpj', $request->cnpj)->first();
    if ($existingCompany) {
        return response()->json([
            'message' => 'Já existe uma empresa cadastrada com o CNPJ informado.',
            'status' => 400,
        ]);
    }

    $client = new \GuzzleHttp\Client();
    $res = $client->request('GET', 'https://www.receitaws.com.br/v1/cnpj/'.$request->cnpj);
    $json = $res->getBody();
    $data = json_decode($json, true);

    $company = new Company();
    $company->user_id = $request->userid;
    $company->uf = $data['uf'];
    $company->name = $data['nome'];
    $company->status = $data['situacao'];
    $company->fantasyname = $data['fantasia'];
    $company->phone = $data['telefone'];
    $company->email = $data['email'];
    $company->opendate = $data['data_situacao'];
    $company->neiborhood = $data['bairro'];
    $company->address = $data['logradouro'];
    $company->addressnumber = $data['numero'];
    $company->cep = $data['cep'];
    $company->city = $data['municipio'];
    $company->jurisnature = $data['natureza_juridica'];
    $company->size = $data['porte'];
    $company->cnpj = $request->cnpj;
    $company->socialcapital = $data['capital_social'];
    $company->save();

    $user = User::findOrFail($request->userid);
    $user->company_id = $company->id;
    $user->save();


    $company->verification_code = mt_rand(100000, 999999);
    $company->save();
    Mail::to($company->email)->send(new NewCompanyVerificationEmailCodeMail($user->name, $user->verification_code));

    return response()->json([
        'message' => 'Empresa cadastrada com sucesso',
        'status' => 200,
        'user' => $user,
        'company' => $company,
    ]);
}

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Company  $company
     * @return \Illuminate\Http\Response
     */









    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\Company  $company
     * @return \Illuminate\Http\Response
     */
    public function edit(Request $request)
    {
        $company = Company::find($request->companyid);
        $user = Company::find($request->userid);
        if(!$company):
            return response()->json(['message' => 'Empresa não encontrada', 'status' => 400]);
        endif;
        //Verifica se é gerente e se a empresa é deste gerente
        if($company->user_id == $request->userid )
        {   return response()->json(['message' => 'Empresa não encontrada', 'status' => 200, 'company'=> $company]); }
        //Verifica se é administrador

    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Company  $company
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request)
    {
        $company = Company::find($request->companyid);
        $user = Company::find($request->userid);
        if(!$company):
            return response()->json(['message' => 'Empresa não encontrada', 'status' => 400]);
        endif;
        //Verifica se é gerente e se a empresa é deste gerente
        if($company->user_id == $request->userid )
        {   return response()->json(['message' => 'Empresa não encontrada', 'status' => 200, 'company'=> $company]);

    }
}

public function companyemailverification(Request $request){

    $user = User::findOrFail($request->userid);
    $company = User::findOrFail($request->compnayid);
    if($company->verification_code == $request->verification_code)
    {
        $company->email_verified_at = Carbon::now();
        $company->verification_code = mt_rand(100000, 999999);
        $company->save();
        return response()->json(['message' => 'Sua empresa foi validadda com sucesso', 'status'=> 200,'compnay'=> $company, 'user' => $user]);


    }else{

        return response()->json(['message' => 'Codigo de verificação incorreto!', 'status'=> 400,'compnay'=> $company, 'user' => $user]);

    }
}

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Company  $company
     * @return \Illuminate\Http\Response
     */



}
