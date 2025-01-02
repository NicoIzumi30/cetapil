<?php

namespace App\Http\Controllers\Web;

use App\Exports\ProductExport;
use App\Exports\OutletExport;
use App\Http\Controllers\Controller;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Http\Request;
use App\Models\City;
use App\Models\Product;
use App\Models\Province;

class DownloadController extends Controller
{
    public function index()
    {
        $provinces = Province::orderBy('name')->get();
        $cities = City::orderBy('name')->get();
        return view('pages.download.index', compact('provinces', 'cities'));
    }

    public function downloadProduct()
    {
        try {
            return Excel::download(
                new ProductExport(), 
                'products_' . date('Y-m-d_His') . '.xlsx'
            );
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Gagal mengunduh data produk',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function downloadRouting(Request $request)
    {
        try {
            $dates = explode(' to ', $request->routing_date);
            $startDate = isset($dates[0]) ? trim($dates[0]) : null;
            $endDate = isset($dates[1]) ? trim($dates[1]) : null;
            
            return Excel::download(
                new OutletExport($startDate, $endDate, $request->routing_region),
                'routing_' . date('Y-m-d_His') . '.xlsx'
            );
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Gagal mengunduh data routing',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}