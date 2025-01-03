<?php

namespace App\Http\Controllers\Web;

use Carbon\Carbon;
use App\Models\City;
use App\Models\Product;
use App\Models\Province;
use Illuminate\Http\Request;
use App\Exports\OutletExport;
use App\Models\SalesActivity;
use App\Exports\ProductExport;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Exports\SalesActivityExport;
use App\Http\Controllers\Controller;
use Maatwebsite\Excel\Facades\Excel;

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
    public function downloadActivity(Request $request) {
        try {
            $query = SalesActivity::with(['outlet:id,name,visit_day,city_id','user:id,name']);
            $dates = explode(' to ', $request->activity_date);
            $startDate = isset($dates[0]) ? trim($dates[0]) : null;
            $endDate = isset($dates[1]) ? trim($dates[1]) : null; 
            $query->whereBetween('checked_in', [
                Carbon::parse($startDate)->startOfDay(),
                Carbon::parse($endDate)->endOfDay()
            ]);
            // Apply region filter
            if ($request->filled('activity_region') && $request->activity_region !== 'all') {
                $query->whereHas('outlet', function ($q) use ($request) {
                    $q->whereHas('city', function ($q) use ($request) {
                        $q->where('province_code', $request->activity_region);
                    });
                });
            }
            // Get data
            $data = $query->get();
            // Generate filename with timestamp
            $filename = 'sales_activity_' . now()->format('Y-m-d_His') . '.xlsx';
            // Return Excel download
            return Excel::download(
                new SalesActivityExport($data),
                $filename,
                \Maatwebsite\Excel\Excel::XLSX
            );
        } catch (\Exception $e) {
            Log::error('Download Error:', [
                'message' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengunduh file: ' . $e->getMessage()
            ], 500);
        }
    } 
}