<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;

Route::get('/', function () {
    return view('pages.dashboard.index');
});

Route::get('/login', function () {
    return view('pages.login');
});

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


