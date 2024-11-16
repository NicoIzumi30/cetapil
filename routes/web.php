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

Route::get('/routing/edit', function () {
    return view('pages.routing.edit');
});

Route::get('/visibility', function () {
    return view('pages.visibility.index');
});

Route::get('/selling', function () {
    return view('pages.selling.index');
});

Route::get('/users', function () {
    return view('pages.users.index');
});

Route::get('/users/create', function () {
    return view('pages.users.create');
});

Route::get('/users/edit', function () {
    return view('pages.users.edit');
});

Route::get('/unauthorized', function () {
    return view('pages.unauthorized');
});

Route::get('/product', [ProductController::class, 'index'])->name('pages.product.index');
