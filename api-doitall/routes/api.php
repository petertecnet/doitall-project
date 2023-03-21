<?php

use App\Http\Controllers\{AuthController, CompanyController, ProductController, UserController};
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

//auth
Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'Login']);
Route::post('/auth/logout', [AuthController::class, 'Logout']);
Route::get('/auth/list', [AuthController::class, 'List']);
Route::post('/auth/sendemailcode', [AuthController::class, 'sendemailcode']);
Route::post('/auth/codevalidation', [AuthController::class, 'codevalidation']);
Route::post('/auth/sendCodeForgotPassword', [AuthController::class, 'sendCodeForgotPassword']);
Route::post('/auth/codevalidationPassword', [AuthController::class, 'codevalidationPassword']);

//User
Route::post('/user/changeemailcodevalidation', [UserController::class, 'changeemailcodevalidation']);
Route::post('/user/show', [UserController::class, 'show']);
Route::put('/user/userupdate', [UserController::class, 'update']);
Route::put('/user/updateAddress', [UserController::class, 'updateAddress']);
Route::post('/user/updateImage', [UserController::class, 'updateImage']);
Route::get('/user/list', [UserController::class, 'List']);

//Company
Route::post('/company/store', [CompanyController::class, 'store']);
Route::post('/company/companyemailverification', [CompanyController::class, 'companyemailverification']);
Route::post('/company/show', [CompanyController::class, 'show']);
Route::post('/company/showByCompany', [CompanyController::class, 'showByCompany']);
Route::post('/company/updateImage', [CompanyController::class, 'updateImage']);

//Product
Route::post('/product/index', [ProductController::class, 'index']);
Route::post('/product/store', [ProductController::class, 'store']);
