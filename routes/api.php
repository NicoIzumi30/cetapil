<?php

use App\Http\Controllers\Api\Auth\AuthController;
use App\Http\Controllers\Api\OutletController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth_api');

Route::controller(AuthController::class)->group(function () {
    Route::post('/login', 'login');
    Route::post('/forgot-password', 'forgotPassword');
    Route::post('/reset-password', 'resetPassword');
});



// Protected routes
Route::middleware(['auth_api'])->group(function () {
    Route::get('/user', [AuthController::class, 'detailUser']);
    Route::post('/logout', [AuthController::class, 'logout']);

    Route::prefix("outlet")->group(function () {
        Route::get('/', [OutletController::class, 'index']);
        Route::get('/detail/{id}', [OutletController::class, 'show']);
        Route::get('/cities', [OutletController::class, 'getCityList']);

        Route::prefix("forms")->group(function () {
            Route::get('/', [OutletController::class, 'forms']);
            Route::post('/create-with-forms', [OutletController::class, 'createOutletWithForms'])
                ->name('create');
        });
    });
    Route::middleware('permission:menu_outlet')->group(function () {
    });
});
