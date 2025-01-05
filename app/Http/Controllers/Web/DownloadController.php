<?php

namespace App\Http\Controllers\Web;

use App\Exports\CityExport;
use App\Exports\ProgramExport;
use App\Exports\StockOnHandExport;
use Carbon\Carbon;
use App\Models\Av3m;
use App\Models\City;
use App\Models\Product;
use App\Models\Province;
use App\Exports\Av3mExport;
use Illuminate\Http\Request;
use App\Exports\SurveyExport;
use App\Models\SalesActivity;
use App\Exports\ProductExport;
use App\Models\SalesAvailability;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Exports\SalesActivityExport;
use App\Http\Controllers\Controller;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\RoutingDownloadExport;
use App\Exports\SellingDownloadExport;
use App\Exports\PenggunaDownloadExport;
use App\Exports\VisibilityActivityExport;

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
    public function downloadProgram()
    {
        try {
            return Excel::download(
                new ProgramExport(),
                'Program_' . date('Y-m-d_His') . '.xlsx'
            );
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Gagal mengunduh data program',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    public function downloadCity()
    {
        try {
            return Excel::download(
                new CityExport(),
                'Kota_' . date('Y-m-d_His') . '.xlsx'
            );
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Gagal mengunduh data kota',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    public function downloadRouting(Request $request)
    {
        try {
            $filename = 'routing_' . now()->format('Y-m-d_His') . '.xlsx';
            return Excel::download(
                new RoutingDownloadExport(
                    $request->routing_week,
                    $request->routing_region
                ),
                $filename,
                \Maatwebsite\Excel\Excel::XLSX
            );
        } catch (\Exception $e) {
            Log::error('Routing Download Error:', [
                'message' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengunduh data routing: ' . $e->getMessage()
            ], 500);
        }
    }
    public function downloadActivity(Request $request)
    {
        try {
            $query = SalesActivity::with(['outlet:id,name,visit_day,city_id', 'user:id,name']);
            $dates = explode(' to ', $request->activity_date);
            $startDate = isset($dates[0]) ? trim($dates[0]) : null;
            $endDate = isset($dates[1]) ? trim($dates[1]) : null;
            if ($request->activity_date != '') {
                $query->whereBetween('checked_in', [
                    Carbon::parse($startDate)->startOfDay(),
                    Carbon::parse($endDate)->endOfDay()
                ]);
            }

            // Apply region filter
            if ($request->filled('activity_region') && $request->activity_region !== 'all') {
                $query->whereHas('outlet', function ($q) use ($request) {
                    $q->whereHas('city', function ($q) use ($request) {
                        $q->where('province_code', $request->activity_region);
                    });
                });
            }
            $query->where('status', 'SUBMITTED');

            // Get data
            $data = $query->get();
            // Generate filename with timestamp
            $filename = 'Sales_Activity_' . now()->format('Y-m-d_His') . '.xlsx';
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
    public function downloadVisibility(Request $request)
    {
        try {
            $query = SalesActivity::with([
                'outlet',
                'user',
                'salesVisibilities',
                'salesVisibilities.posmType', // Load the posm_type relationship
            ]);
            $dates = explode(' to ', $request->visibility_date);
            $startDate = isset($dates[0]) ? trim($dates[0]) : null;
            $endDate = isset($dates[1]) ? trim($dates[1]) : null;
            if ($request->visibility_date != '') {
                $query->whereBetween('checked_in', [
                    Carbon::parse($startDate)->startOfDay(),
                    Carbon::parse($endDate)->endOfDay()
                ]);
            }
            // Apply region filter
            if ($request->filled('visibility_region') && $request->visibility_region !== 'all') {
                $query->whereHas('outlet', function ($q) use ($request) {
                    $q->whereHas('city', function ($q) use ($request) {
                        $q->where('province_code', $request->visibility_region);
                    });
                });
            }
            $query->where('status', 'SUBMITTED');
            // Get data
            $data = $query->get();
            // Generate filename with timestamp
            $filename = 'Visibility_Activity_' . now()->format('Y-m-d_His') . '.xlsx';
            // Return Excel download
            return Excel::download(
                new VisibilityActivityExport($data),
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
    public function downloadAvailability(Request $request)
    {
        try {
            $query = SalesAvailability::with([
                'salesActivity:id,time_availability',
                'product:id,sku',
                'outlet:id,name,code,tipe_outlet,TSO,city_id,channel_id,user_id,account',
                'outlet.user:id,name',
                'outlet.city:id,name',
                'outlet.channel:id,name'
            ]);
            $dates = explode(' to ', $request->availability_date);
            $startDate = isset($dates[0]) ? trim($dates[0]) : null;
            $endDate = isset($dates[1]) ? trim($dates[1]) : null;
            if ($request->availability_date != '') {
                $query->whereBetween('created_at', [
                    Carbon::parse($startDate)->startOfDay(),
                    Carbon::parse($endDate)->endOfDay()
                ]);
            }
            // Apply region filter
            if ($request->filled('availability_region') && $request->availability_region !== 'all') {
                $query->whereHas('outlet', function ($q) use ($request) {
                    $q->whereHas('city', function ($q) use ($request) {
                        $q->where('province_code', $request->availability_region);
                    });
                });
            }
            // Get data
            $data = $query->get();
            // Generate filename with timestamp
            $filename = 'Availability_' . now()->format('Y-m-d_His') . '.xlsx';
            // Return Excel download
            return Excel::download(
                new StockOnHandExport($data),
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
    public function downloadSurvey(Request $request)
    {
        try {
            $query = SalesActivity::with([
                'user:id,name',
                'outlet:id,name,TSO,code,account,tipe_outlet,channel_id,visit_day',
                'outlet.channel:id,name',
                'surveys.survey'
            ]);
            $dates = explode(' to ', $request->survey_date);
            $startDate = isset($dates[0]) ? trim($dates[0]) : null;
            $endDate = isset($dates[1]) ? trim($dates[1]) : null;
            if ($request->survey_date != '') {
                $query->whereBetween('checked_in', [
                    Carbon::parse($startDate)->startOfDay(),
                    Carbon::parse($endDate)->endOfDay()
                ]);
            }
            // Apply region filter
            if ($request->filled('survey_region') && $request->survey_region !== 'all') {
                $query->whereHas('outlet', function ($q) use ($request) {
                    $q->whereHas('city', function ($q) use ($request) {
                        $q->where('province_code', $request->survey_region);
                    });
                });
            }
            // Get data
            $data = $query->get();
            // Generate filename with timestamp
            $filename = 'Market_Survey_' . now()->format('Y-m-d_His') . '.xlsx';
            // Return Excel download
            return Excel::download(
                new SurveyExport($data),
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
    public function downloadSelling(Request $request)
    {
        try {
            if ($request->filled('selling_date')) {
                $dates = explode(' to ', $request->selling_date);
                $startDate = isset($dates[0]) ? Carbon::parse(trim($dates[0])) : null;
                $endDate = isset($dates[1]) ? Carbon::parse(trim($dates[1])) : null;
            }

            return Excel::download(
                new SellingDownloadExport($startDate, $endDate, $request->selling_region),
                'selling_' . now()->format('Y-m-d_His') . '.xlsx'
            );
        } catch (\Exception $e) {
            Log::error('Selling Download Error:', [
                'message' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengunduh data penjualan'
            ], 500);
        }
    }

    public function downloadPengguna()
    {
        try {
            return Excel::download(
                new PenggunaDownloadExport(),
                'users_' . now()->format('Y-m-d_His') . '.xlsx',
                \Maatwebsite\Excel\Excel::XLSX
            );
        } catch (\Exception $e) {
            Log::error('User Download Error:', [
                'message' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengunduh data pengguna'
            ], 500);
        }
    }
    public function downloadAv3m()
    {
        try {
            $data = Av3m::with([
                'product' => function ($query) {
                    $query->select('id', 'sku', 'code');
                },
                'outlet' => function ($query) {
                    $query->select('id', 'name', 'code');
                }
            ])
                ->has('product')
                ->has('outlet')
                ->get();
            return Excel::download(
                new Av3mExport($data),
                'av3m_data_' . now()->format('Y-m-d_His') . '.xlsx',
                \Maatwebsite\Excel\Excel::XLSX
            );
        } catch (\Exception $e) {
            Log::error('Av3m Download Error:', [
                'message' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengunduh data av3m: ' . $e->getMessage()
            ], 500);
        }
    }
}
