<?php

use App\Http\Controllers\Auth\LoginController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;

Route::get('/', function () {
    return view('pages.dashboard.index');
})->name('dashboard');

Route::get('/login',[LoginController::class,'index'])->name('login');
Route::post('/login', [LoginController::class, 'login']);

Route::get('/profile', function () {
    return view('pages.profile');
});

Route::get('/routing', function () {
    return view('pages.routing.index');
});

Route::get('/routing/create', function () {
    return view('pages.routing.create');
});


Route::get('/product', [ProductController::class, 'index'])->name('pages.product.index');


