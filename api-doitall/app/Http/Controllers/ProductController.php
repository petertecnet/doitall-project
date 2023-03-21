<?php

namespace App\Http\Controllers;

use App\Models\Company;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use App\Models\Image;
use App\Models\User;
use Exception;

class ProductController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */


    public function index(Request $request)
    {

            try{

                $user = User::findOrFail($request->user_id);
                $products = Product::where('company_id', $request->company_id)
                ->orderByDesc('id')
                ->get();

                $response=['status' => 200, 'products' => $products,'user' => $user, 'companyid' =>$request->company_id];
                return response()->json($response);
            }catch(Exception $e){
                $response = ['status'=> 500, 'message'=> $e];
            }


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
    public function store(Request $request)
    {
        try {
            $user = User::findOrFail($request->user_id);
            $product = Product::create($request->all());

            $product->save();

        if ($request->img_product) {

            $img_product = $request->img_product;
            if (!$img_product->isValid() || !in_array($img_product->getClientOriginalExtension(), ['jpg', 'jpeg', 'png', 'gif'])) {
                return response()->json(['message' => 'Arquivo de imagem inválido.', 'status' => 400]);
            }

            $fileName = $product->id.'-'.$product->company_id. '-img_product.' . $img_product->getClientOriginalExtension();
            $directoryName = $product->id . '-' . $product->company_id;

            $directoryPath = public_path('products/' . $directoryName);

            if (!File::exists($directoryPath)) {
                File::makeDirectory($directoryPath, 0755, true);
            }

            // Check if there's a file with the same name as the uploaded file
            if (File::exists($directoryPath . '/' . $img_product->getClientOriginalName())) {

                // Generate a new unique file name by adding a number to the end of the original file name
                $count = 1;
                $newFileName = pathinfo($img_product->getClientOriginalName(), PATHINFO_FILENAME) . '_' . $count . '.' . $img_product->getClientOriginalExtension();

                while (File::exists($directoryPath . '/' . $newFileName)) {
                    $count++;
                    $newFileName = pathinfo($img_product->getClientOriginalName(), PATHINFO_FILENAME) . '_' . $count . '.' . $img_product->getClientOriginalExtension();
                }

                // Rename the existing file with the new unique name
                File::move($directoryPath . '/' . $img_product->getClientOriginalName(), $directoryPath . '/' . $newFileName);
            }

            $img_product->move($directoryPath, $fileName);
            $product->img_product = $fileName;
            $product->save();

            $image = New Image();
            $image->name = $fileName;
            $image->origin = 'product';
            $image->type = 'imgProduct';
            $image->origin_id = $product->id;
            $image->save();

        }


            $products = Product::where('company_id', $request->company_id)
            ->orderBy('created_at', 'desc')
            ->get();
            $company = Company::where('id', $request->company_id)->get();

            $response = [
                'status' => 200,
                'message' => 'Produto cadastrado com sucesso',
                'user' => $user,
                'products' => $products,
                'company' => $company,
            ];
            return response()->json($response);
        } catch (Exception $e) {
            $response = ['status' => 500, 'message' => $e];
            return response()->json($response);
        }
    }


    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Product  $product
     * @return \Illuminate\Http\Response
     */
    public function show(Product $product)
    {

    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\Product  $product
     * @return \Illuminate\Http\Response
     */
    public function edit(Product $product)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Product  $product
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Product $product)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Product  $product
     * @return \Illuminate\Http\Response
     */
    public function destroy(Product $product)
    {
        //
    }
}
