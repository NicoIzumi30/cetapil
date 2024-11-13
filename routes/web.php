<?php

use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Auth\LogoutController;
use App\Http\Controllers\Web\DashboardController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;


Route::middleware('guest')->group(function () {
    Route::get('/login', [LoginController::class, 'index'])->name('login');
    Route::post('/login', [LoginController::class, 'login']);
});

Route::middleware('auth')->group(function () {
    Route::get('/', [DashboardController::class, 'index'])->name('dashboard');
    Route::get('/profile', function () {
        return view('pages.profile');
    });
    Route::prefix('routing')->name('routing.')->middleware('permission:menu_routing')->group(function () {
        Route::get('/', function () {
            return view('pages.routing.index');
        });
        Route::get('/create', function () {
            return view('pages.routing.create');
        });

        Route::get('/edit', function () {
            return view('pages.routing.edit');
        });
    });
    Route::prefix('visibility')->name('visibility.')->middleware('permission:menu_visibility')->group(function () {
        Route::get('/', function () {
            return view('pages.visibility.index');
        });
    });
    Route::prefix('selling')->name('selling.')->middleware('permission:menu_selling')->group(function () {
        Route::get('/', function () {
            return view('pages.selling.index');
        });
    });
    Route::prefix('users')->name('users.')->middleware('permission:menu_user')->group(function () {
        Route::get('/', function () {
            return view('pages.users.index');
        });
        Route::get('/create', function () {
            return view('pages.users.create');
        });
    });
    Route::prefix('products')->name('products.')->middleware('permission:menu_product')->group(function () {
        Route::get('/', [ProductController::class, 'index'])->name('pages.product.index');
    });
    Route::get('/logout', LogoutController::class)->name('logout');
});



