<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Carbon\Carbon;

class DashboardController extends Controller
{
    public function index()
    {
        Carbon::setLocale('id');
        $tanggal = Carbon::now()->translatedFormat('l, d F Y');
        return view('pages.dashboard.index',['tanggal'=> $tanggal]);
    }
}
