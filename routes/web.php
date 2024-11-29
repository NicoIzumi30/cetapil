<?php

use App\Http\Controllers\Web\OutletControler;
use App\Http\Controllers\Web\ProductKnowledgeControler;
use App\Http\Controllers\Web\RoutingController;
use App\Http\Controllers\Web\VisualController;
use App\Models\Visibility;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Web\UserController;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Auth\LogoutController;
use App\Http\Controllers\Web\ProductController;
use App\Http\Controllers\Web\DashboardController;
use App\Http\Controllers\Web\VisibilityController;
use App\Http\Controllers\Web\PosmController;


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
    // Route::prefix('routing')->name('routing.')->middleware('permission:menu_routing')->group(function () {
    //     Route::get('/', function () {
    //         return view('pages.routing.index');
    //     })->name('index');
    //     Route::get('/create', function () {
    //         return view('pages.routing.create');
    //     })->name('create');
    //     Route::get('/edit', function () {
    //         return view('pages.routing.edit');
    //     })->name('edit');
    //     Route::get('/request', function () {
    //         return view('pages.routing.request');
    //     });
    //     Route::get('/routingrequest/detail', function () {
    //         return view('pages.routing.detail-request');
    //     });
    //     Route::get('/sales-activity', function () {
    //         return view('pages.routing.sales-activity');
    //     });
    //     Route::get('/av3m', function () {
    //         return view('pages.routing.av3m');
    //     });
    // });
    Route::get('/routing/request', function () {
        return view('pages.routing.request');
        });
    Route::get('/routing/request/detail', function () {
            return view('pages.routing.detail-request');
        });
    Route::get('routing/generate-excel',[RoutingController::class,'downloadExcel'])->name('routing.generae-excel')->middleware('permission:menu_routing');
    Route::get('routing/data',[RoutingController::class,'getData'])->name('routing.data')->middleware('permission:menu_routing');
    Route::resource('routing',RoutingController::class)->middleware('permission:menu_routing');
    Route::put('update-product-knowledge', [ProductKnowledgeControler::class, 'update'])->name('update-product-knowledge')->middleware('permission:menu_routing');

    // Visibility Management
    Route::middleware('permission:menu_visibility')->group(function () {
        Route::resource('visibility', VisibilityController::class);
            
        // Route::get('/visibility/data', [VisibilityController::class, 'getData'])->name('visibility.data');
        
        Route::post('/visibility/data', [VisibilityController::class, 'store'])->name('visibility.data');
        Route::get('visibility/{visibility}/edit', [VisibilityController::class, 'edit'])->name('visibility.edit');

        Route::post('posm/update-image', [PosmController::class, 'updateImage'])
            ->name('posm.update-image')
            ->middleware('permission:menu_visibility');
        
        Route::post('visual', [VisualController::class, 'store'])->name('visual.store');
        Route::post('posm-types', [PosmController::class, 'store'])->name('posm.store');
    
        Route::get('/visibility/products/{category}', [VisibilityController::class, 'getProducts'])
            ->name('visibility.products');

    });


    // Selling Management
    Route::prefix('selling')->name('selling.')->middleware('permission:menu_selling')->group(function () {
        Route::get('/', function () {
            return view('pages.selling.index');
        })->name('index');
        Route::get('/create', function () {
            return view('pages.selling.create');
        });
        Route::get('/edit', function () {
            return view('pages.selling.edit');
        });
    });

    // User Management
    Route::resource('users', UserController::class)->middleware('permission:menu_user');

    // Product Management
    Route::prefix('products')->name('products.')->middleware('permission:menu_product')->group(function () {
        Route::get('/', [ProductController::class, 'index'])->name('index');
        Route::get('/create', [ProductController::class, 'create'])->name('create');
        Route::post('/', [ProductController::class, 'store'])->name('store');
        Route::get('{product}/edit', [ProductController::class, 'edit'])->name('edit');
        Route::put('/{product}', [ProductController::class, 'update'])->name('update');
        Route::delete('/{product}', [ProductController::class, 'destroy'])->name('destroy');
        Route::post('/bulk', [ProductController::class, 'bulk'])->name('bulk');
        Route::get('/download-template', [ProductController::class,'downloadTemplate'])->name('downloadTemplate');
        Route::get('/{product}/av3m', [ProductController::class, 'getAv3m'])->name('products.getAv3m');
        Route::post('/{product}/av3m', [ProductController::class, 'updateAv3m'])->name('products.updateAv3m');
        Route::get('/generate-excel', [ProductController::class, 'downloadExcel'])
        ->name('generate-excel');
        Route::get('/data', [ProductController::class, 'getData'])->name('data');
    });
    // Logout
    Route::get('/logout', LogoutController::class)->name('logout');
// Unauthorized Access
Route::get('/unauthorized', function () {
    return view('pages.unauthorized');
})->name('unauthorized');

});

