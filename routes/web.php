<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProductController;

Route::get('/', function () {
    $dataChartStock = [
        ['id-ac', 113], // aceh
        ['id-jt', 124], // jawa tengah
        ['id-be', 133], // bengkulu
        ['id-bt', 141], // banten
        ['id-kb', 153], // kalimantan barat
        ['id-bb', 161], // bangka belitung
        ['id-ba', 17], // bali
        ['id-ji', 18], // Jawa Timur
        ['id-ks', 19], // kalimantan selatan
        ['id-nt', 20], // NTT
        ['id-se', 21], // sulawesi selatan
        ['id-kr', 22], // kelulauan riau
        ['id-ib', 230], // irian jaya barat
        ['id-su', 24], // sumatra utara
        ['id-ri', 25], // riau
        ['id-sw', 26], // sulawesi utara
        ['id-ku', 27], // kalimantan utara
        ['id-la', 28], // maluku utara
        ['id-sb', 29], // sumatra barat
        ['id-ma', 30], // maluku
        ['id-nb', 31], // NTB
        ['id-sg', 32], // sulawesi tenggara
        ['id-st', 33], // sulawesi tengah
        ['id-pa', 34], // papua
        ['id-jr', 35], // jawa barat
        ['id-ki', 36], // kalimantan timur
        ['id-1024', 37], // lampung
        ['id-jk', 38], // jakarta raya
        ['id-go', 39], // gorontalo
        ['id-yo', 40], // yogyakarta
        ['id-sl', 41], // sumatra selatan
        ['id-sr', 42], // sulawesi barat
        ['id-ja', 43], // jambi
        ['id-kt', 44] // kalimantan tengah
    ];

    $dataChartVisibility = [
        ['id-ac', 11], // aceh
        ['id-jt', 12], // jawa tengah
        ['id-be', 13], // bengkulu
        ['id-bt', 14], // banten
        ['id-kb', 15], // kalimantan barat
        ['id-bb', 16], // bangka belitung
        ['id-ba', 17], // bali
        ['id-ji', 18], // Jawa Timur
        ['id-ks', 19], // kalimantan selatan
        ['id-nt', 20], // NTT
        ['id-se', 21], // sulawesi selatan
        ['id-kr', 22], // kelulauan riau
        ['id-ib', 23], // irian jaya barat
        ['id-su', 24], // sumatra utara
        ['id-ri', 25], // riau
        ['id-sw', 26], // sulawesi utara
        ['id-ku', 27], // kalimantan utara
        ['id-la', 28], // maluku utara
        ['id-sb', 29], // sumatra barat
        ['id-ma', 30], // maluku
        ['id-nb', 31], // NTB
        ['id-sg', 32], // sulawesi tenggara
        ['id-st', 33], // sulawesi tengah
        ['id-pa', 34], // papua
        ['id-jr', 35], // jawa barat
        ['id-ki', 36], // kalimantan timur
        ['id-1024', 37], // lampung
        ['id-jk', 38], // jakarta raya
        ['id-go', 39], // gorontalo
        ['id-yo', 40], // yogyakarta
        ['id-sl', 41], // sumatra selatan
        ['id-sr', 42], // sulawesi barat
        ['id-ja', 43], // jambi
        ['id-kt', 44] // kalimantan tengah
    ];
    return view('pages.dashboard.index', compact('dataChartStock', 'dataChartVisibility'));
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
