<?php

use App\Http\Controllers\LottoController;
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

Route::get('/lottoAllListStore', [LottoController::class, 'lottoAllListStore']);
Route::get('/lottoNewListStore', [LottoController::class, 'lottoNewListStore']);
Route::get('/recentlyData', [LottoController::class, 'recentlyData']);
Route::get('/lottoAllList', [LottoController::class, 'lottoAllList']);
