<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\Auth\AuthController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\OutletController;
use App\Http\Controllers\Api\ProductKnowledgeController;
use App\Http\Controllers\Api\RoutingController;
use App\Http\Controllers\Api\SalesActivityController;
use App\Http\Controllers\Api\SellingController;
use App\Http\Controllers\Api\SurveyController;

/*
|--------------------------------------------------------------------------
| API Authentication Routes
|--------------------------------------------------------------------------
|
| Routes for handling user authentication including login, password reset,
| and user information retrieval
|
*/
Route::controller(AuthController::class)->group(function () {
    Route::post('/login', 'login');
    Route::post('/forgot-password', 'forgotPassword');
    Route::post('/reset-password', 'resetPassword');
});

/*
|--------------------------------------------------------------------------
| Protected Sales Routes
|--------------------------------------------------------------------------
|
| All routes that require authentication and the 'sales' role
| Grouped by feature/module for better organization
|
*/
Route::middleware(['auth_api', 'role:sales'])->group(function () {
    // User Management Routes
    Route::get('/user', [AuthController::class, 'detailUser']);
    Route::post('/logout', [AuthController::class, 'logout']);

    // Dashboard Routes
    Route::controller(DashboardController::class)
        ->prefix('dashboard')
        ->group(function () {
            Route::get('/', 'index');
            Route::get('/performance', 'performanceIndex');
            Route::get('/power-sku', 'getPowerSkus');
            Route::get('/calendar', 'getCalendarActivities');
        });

    // Outlet Management Routes
    Route::prefix('outlet')->group(function () {
        Route::get('/', [OutletController::class, 'index']);
        Route::get('/detail/{id}', [OutletController::class, 'show']);
        Route::get('/cities', [OutletController::class, 'getCityList']);

        // Outlet Forms Routes
        Route::prefix('forms')->group(function () {
            Route::get('/', [OutletController::class, 'forms']);
            Route::post('/create-with-forms', [OutletController::class, 'createOutletWithForms'])
                ->name('create');
        });
    });

    // Routing Management Routes
    Route::prefix('routing')->group(function () {
        Route::get('/', [RoutingController::class, 'index']);
        Route::post('/check_in', [RoutingController::class, 'checkIn']);
        Route::post('/check_out', [RoutingController::class, 'checkOut']);
        Route::get('/detail/{id}', [OutletController::class, 'show']);
    });

    // Sales Activity Routes
    Route::prefix('activity')->group(function () {
        // Activity Management
        Route::get('/', [SalesActivityController::class, 'getSalesAcitivityList']);
        Route::get('/{activity_id}/detail', [SalesActivityController::class, 'getActivityById']);
        Route::get('/{activity_id}/cancel', [SalesActivityController::class, 'cancelActivity']);
        Route::post('/submit', [SalesActivityController::class, 'storeActivity']);

        // Product Related Routes
        Route::get('/product-categories', [SalesActivityController::class, 'categoryList']);
        Route::post('/product', [SalesActivityController::class, 'productByCategoryList']);
        Route::get('/get-all-product', [SalesActivityController::class, 'getAllProducts']);

        // Store Display Routes
        Route::get('/{outlet_id}/visibilities', [SalesActivityController::class, 'getVisibilityList']);
        Route::get('/visual', [SalesActivityController::class, 'getVisualTypeList']);
        Route::get('/posm', [SalesActivityController::class, 'getPosmTypeList']);
        Route::get('/planogram', [SalesActivityController::class, 'getPlanogram']);

        // Channel Routes
        Route::get('/channels', [SalesActivityController::class, 'getAllChannels']);

        // Survey Routes
        Route::controller(SurveyController::class)
            ->prefix('surveys')
            ->group(function () {
                Route::get('/', 'index');
                Route::post('/', 'saveSurvey');
            });
    });

    // Product Knowledge Routes
    Route::get('/product-knowledge', [ProductKnowledgeController::class, 'index']);

    // Selling Routes
    Route::get('/selling', [SellingController::class, 'index']);
    Route::post('/selling/create', [SellingController::class, 'store']);

    // Routes requiring specific permissions
    // Route::middleware('permission:menu_outlet')->group(function () {
    //     // Add outlet-specific routes here
    // });
});
