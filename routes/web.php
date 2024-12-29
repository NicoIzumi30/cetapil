<?php

use App\Http\Controllers\Web\SurveyController;
use App\Models\Visibility;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Web\PosmController;
use App\Http\Controllers\Web\UserController;
use App\Http\Controllers\Web\OutletControler;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Web\VisualController;
use App\Http\Controllers\Auth\LogoutController;
use App\Http\Controllers\Web\ProductController;
use App\Http\Controllers\Web\RoutingController;
use App\Http\Controllers\Web\SellingController;
use App\Http\Controllers\Web\DashboardController;
use App\Http\Controllers\Web\VisibilityController;
use App\Http\Controllers\Web\ProfileController;
use App\Http\Controllers\Web\RoutingRequestControler;
use App\Http\Controllers\Web\SalesActivityController;
use App\Http\Controllers\Web\ProductKnowledgeControler;
use App\Http\Controllers\Web\PowerSkuController;

// Guest Routes
Route::middleware('guest')->group(function () {
    Route::get('/login', [LoginController::class, 'index'])->name('login');
    Route::post('/login', [LoginController::class, 'login']);
});

// Authenticated Routes
Route::middleware('auth')->group(function () {
    // Dashboard
    Route::get('/', [DashboardController::class, 'index'])->name('dashboard');
    Route::get('/getRouting', [DashboardController::class, 'getRoutingPercentage'])->name('getRoutingPercentage');

    //profile
    Route::get('/profile', [ProfileController::class, 'index'])->name('profile');

    Route::post('/profile/update-password', [ProfileController::class, 'updatePassword'])->name('profile.update-password');
    Route::post('/profile/update', [ProfileController::class, 'updateProfile'])->name('profile.update');

    Route::prefix('routing/sales/activity')->name('routing.sales.activity.')->middleware('permission:menu_routing')->group(function () {
        Route::get('/data', [SalesActivityController::class, 'getData'])->name('data');
        Route::get('/{id}', [SalesActivityController::class, 'detail'])->name('detail');
    });
    Route::prefix('routing/request')->name('routing.request.')->middleware('permission:menu_routing')->group(function () {
        Route::get('/', [RoutingRequestControler::class, 'index'])->name('index');
        Route::get('/data', [RoutingRequestControler::class, 'getData'])->name('data');
        Route::get('/{id}/edit', [RoutingRequestControler::class, 'edit'])->name('edit');
        Route::put('/{id}/approve', [RoutingRequestControler::class, 'approve'])->name('approve');
        Route::put('/{id}/reject', [RoutingRequestControler::class, 'reject'])->name('reject');
        Route::delete('/delete/', [RoutingRequestControler::class, 'destroy'])->name('delete');
    });

    Route::get('/routing/download-filtered', [RoutingController::class, 'downloadFilteredExcel'])
        ->name('routing.download-filtered')
        ->middleware('permission:menu_routing');


    Route::get('/routing/download-sales-activity', [RoutingController::class, 'downloadSalesActivityExcel'])
    ->name('routing.download-sales-activity')
    ->middleware('permission:menu_routing');

    Route::post('/routing/bulk', [RoutingController::class, 'bulk'])->name('routing.bulk')->middleware('permission:menu_routing');
    Route::get('routing/generate-excel', [RoutingController::class, 'downloadExcel'])->name('routing.generae-excel')->middleware('permission:menu_routing');
    Route::get('routing/data', [RoutingController::class, 'getData'])->name('routing.data')->middleware('permission:menu_routing');
    Route::resource('routing', RoutingController::class)->middleware('permission:menu_routing');
    // Route::delete('/routing/{id}', [RoutingController::class, 'destroy'])->name('routing.destroy');

    Route::put('update-product-knowledge', [ProductKnowledgeControler::class, 'update'])->name('update-product-knowledge')->middleware('permission:menu_routing');
    Route::get('/visibility/download-activity', [VisibilityController::class, 'downloadActivityData'])
        ->name('visibility.download-activity');
    // Visibility Management
    Route::middleware('permission:menu_visibility')->group(function () {
        Route::get('/visibility/data', [VisibilityController::class, 'getData'])->name('visibility.data');
        Route::get('visibility/activity/data', [VisibilityController::class, 'getDataActivity'])->name('visibility.activity.data');
        Route::get('visibility/activity/{id}/detail', [VisibilityController::class, 'detail_activity'])->name('visibility.activity.detail');
        Route::resource('visibility', VisibilityController::class);
        Route::get('posm/get-images', [PosmController::class, 'getImages'])
            ->name('posm.get-images');
        Route::post('posm/update-image', [PosmController::class, 'updateImage'])
            ->name('posm.update-image');
        Route::post('visual', [VisualController::class, 'store'])->name('visual.store');
        Route::post('posm-types', [PosmController::class, 'store'])->name('posm.store');
        Route::get('/visibility/products/{category}', [VisibilityController::class, 'getProducts'])
            ->name('visibility.products');
    });

    // Survey Management
    Route::prefix('survey')->name('survey.')->group(function () {
        Route::get('/', [SurveyController::class, 'index'])->name('index');
        Route::get('/data', [SurveyController::class, 'getData'])->name('data');
        Route::get('/{id}/detail', [SurveyController::class, 'detail'])->name('detail');

    });

    // Selling Management
    Route::prefix('selling')->name('selling.')->middleware('permission:menu_selling')->group(function () {
        Route::get('/', [SellingController::class, 'index'])->name('index');
        Route::get('/create', function () {
            return view('pages.selling.create');
        });
        Route::get('/download', [SellingController::class, 'downloadData'])->name('download');
        Route::get('/{id}/detail', [SellingController::class, 'detail'])->name('detail');
        Route::get('/data', [SellingController::class, 'getData'])->name('data');
    });


    // User Management
    Route::get('users/data', [UserController::class, 'getData'])->name('users.data');
    Route::resource('users', UserController::class)->middleware('permission:menu_user');

    // Product Management
    Route::prefix('products')->name('products.')->middleware('permission:menu_product')->group(function () {

        Route::post('/bulk', [ProductController::class, 'bulk'])->name('bulk');
        Route::get('/download-template', [ProductController::class, 'downloadTemplate'])->name('downloadTemplate');
        Route::get('/{product}/av3m', [ProductController::class, 'getAv3m'])->name('products.getAv3m');
        Route::post('/{product}/av3m', [ProductController::class, 'updateAv3m'])->name('products.updateAv3m');
        Route::get('/generate-excel', [ProductController::class, 'downloadExcel'])
            ->name('generate-excel');
        Route::get('/data', [ProductController::class, 'getData'])->name('data');
        Route::get('/data-stock-on-hand', [ProductController::class, 'getDataStockOnHand'])->name('data-stock-on-hand');
        Route::get('/download-stock-on-hand', [ProductController::class, 'downloadStockOnHand'])
            ->name('download-stock-on-hand');
        Route::get('/get-products-by-category/{category}', [ProductController::class, 'getProductsByCategory'])
        ->name('get-products-by-category');
        Route::prefix('power-skus')->name('power-skus.')->group(function() {
            Route::get('/data', [PowerSkuController::class, 'data'])->name('data');
            Route::post('/', [PowerSkuController::class, 'store'])->name('store');
            Route::get('/{powerSku}/edit', [PowerSkuController::class, 'edit'])->name('edit');
            Route::put('/{powerSku}', [PowerSkuController::class, 'update'])->name('update');
            Route::delete('/{powerSku}', [PowerSkuController::class, 'destroy'])->name('destroy');
        });
        Route::prefix('av3ms')->name('av3ms.')->group(function() {
            Route::post('/bulk', [ProductController::class, 'av3mBulk'])->name('bulk');
            Route::get('/download', [ProductController::class, 'downloadAv3m'])->name('download');
            Route::get('/template', [ProductController::class, 'templateAv3m'])->name('template');
        });

    });

    Route::resource('products', ProductController::class)->middleware('permission:menu_product');
    // Logout

    Route::get('/logout', LogoutController::class)->name('logout');
    // Unauthorized Access
    Route::get('/unauthorized', function () {
        return view('pages.unauthorized');
    })->name('unauthorized');
});
