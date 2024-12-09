<?php

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
use App\Http\Controllers\Web\RoutingRequestControler;
use App\Http\Controllers\Web\SalesActivityController;
use App\Http\Controllers\Web\ProductKnowledgeControler;

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


    Route::post('/routing/bulk', [RoutingController::class, 'bulk'])->name('routing.bulk')->middleware('permission:menu_routing');
    Route::get('routing/generate-excel', [RoutingController::class, 'downloadExcel'])->name('routing.generae-excel')->middleware('permission:menu_routing');
    Route::get('routing/data', [RoutingController::class, 'getData'])->name('routing.data')->middleware('permission:menu_routing');
    Route::resource('routing', RoutingController::class)->middleware('permission:menu_routing');

    Route::put('update-product-knowledge', [ProductKnowledgeControler::class, 'update'])->name('update-product-knowledge')->middleware('permission:menu_routing');

    // Visibility Management
    Route::middleware('permission:menu_visibility')->group(function () {
        Route::get('/visibility/data', [VisibilityController::class, 'getData'])->name('visibility.data');
        Route::get('visibility/activity/data',[VisibilityController::class,'getDataActivity'])->name('visibility.activity.data');
        Route::get('visibility/activity/{id}/detail',[VisibilityController::class,'detail_activity'])->name('visibility.activity.detail');
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


    // Selling Management
    Route::prefix('selling')->name('selling.')->middleware('permission:menu_selling')->group(function () {
        Route::get('/', [SellingController::class, 'index'])->name('index');
        Route::get('/create', function () {
            return view('pages.selling.create');
        });
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
    });
    Route::resource('products', ProductController::class)->middleware('permission:menu_product');
    // Logout

    Route::get('/logout', LogoutController::class)->name('logout');
    // Unauthorized Access
    Route::get('/unauthorized', function () {
        return view('pages.unauthorized');
    })->name('unauthorized');

});

