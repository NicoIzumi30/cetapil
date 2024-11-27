<?php

use App\Http\Controllers\Api\Auth\AuthController;
use App\Http\Controllers\Api\OutletController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\RoutingController;
use App\Http\Controllers\Api\SalesActivityController;
use App\Http\Controllers\Api\SurveyController;
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
Route::middleware(['auth_api', 'role:sales'])->group(function () {
    Route::get('/user', [AuthController::class, 'detailUser']);
    Route::post('/logout', [AuthController::class, 'logout']);

    Route::controller(DashboardController::class)
        ->prefix('dashboard')
        ->group(function () {
            Route::get('/', 'index');
            Route::get('/performance', 'performanceIndex');
        });

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
    Route::prefix("routing")->group(function () {
        Route::get('/', [RoutingController::class, 'index']);
        Route::post('/check_in', [RoutingController::class, 'checkIn']);
        Route::post('/check_out', [RoutingController::class, 'checkOut']);
        Route::get('/detail/{id}', [OutletController::class, 'show']);
    });
    Route::prefix("activity")->group(function () {
        Route::get('/', [SalesActivityController::class, 'getSalesAcitivityList']);
        Route::get('/product-categories', [SalesActivityController::class, 'categoryList']);
        Route::post('/product', [SalesActivityController::class, 'productByCategoryList']);
        Route::get('/{outlet_id}/visibilities', [SalesActivityController::class, 'getVisibilityList']);
        Route::get('/visual', [SalesActivityController::class, 'getVisualTypeList']);

        // Route::post('products', 'productByCategoryList');

        // Route::get('/cities', 'getCityList');
        // Route::get('/outlets', 'getOutletList');
        // Route::get('/visual', 'getVisualTypeList');
        // Route::get('/posm', 'getPosmTypeList');

        Route::controller(SurveyController::class)
            ->prefix('surveys')
            ->group(function () {
                Route::get('/', 'index');
                Route::post('/', 'saveSurvey');
            });
    });
    Route::middleware('permission:menu_outlet')->group(function () {});
});
