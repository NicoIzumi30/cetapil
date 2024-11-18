<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\Web\UserController;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Auth\LogoutController;
use App\Http\Controllers\Web\DashboardController;

// Guest Routes
Route::middleware('guest')->group(function () {
    Route::get('/login', [LoginController::class, 'index'])->name('login');
    Route::post('/login', [LoginController::class, 'login']);
});

// Authenticated Routes
Route::middleware('auth')->group(function () {
    // Dashboard
    Route::get('/', [DashboardController::class, 'index'])->name('dashboard');
    
    // Profile
    Route::get('/profile', function () {
        return view('pages.profile');
    })->name('profile');

    // Routing Management
    Route::prefix('routing')->name('routing.')->middleware('permission:menu_routing')->group(function () {
        Route::get('/', function () {
            return view('pages.routing.index');
        })->name('index');
        Route::get('/create', function () {
            return view('pages.routing.create');
        })->name('create');
        Route::get('/edit', function () {
            return view('pages.routing.edit');
        })->name('edit');
    });

    // Visibility Management
    Route::prefix('visibility')->name('visibility.')->middleware('permission:menu_visibility')->group(function () {
        Route::get('/', function () {
            return view('pages.visibility.index');
        })->name('index');
    });

    // Selling Management
    Route::prefix('selling')->name('selling.')->middleware('permission:menu_selling')->group(function () {
        Route::get('/', function () {
            return view('pages.selling.index');
        })->name('index');
    });

    // User Management
    Route::resource('users', UserController::class)->middleware('permission:menu_user');

    // Product Management
    Route::prefix('products')->name('products.')->middleware('permission:menu_product')->group(function () {
        Route::get('/', [ProductController::class, 'index'])->name('index'); 
        Route::get('/create', [ProductController::class, 'create'])->name('create');
        Route::post('/', [ProductController::class, 'store'])->name('store');
        Route::get('/{product}/edit', [ProductController::class, 'edit'])->name('edit');
        Route::put('/{product}', [ProductController::class, 'update'])->name('update');
        Route::delete('/{product}', [ProductController::class, 'destroy'])->name('destroy');
        
    });

    // Logout
    Route::get('/logout', LogoutController::class)->name('logout');
});

// Unauthorized Access
Route::get('/unauthorized', function () {
    return view('pages.unauthorized');
})->name('unauthorized');