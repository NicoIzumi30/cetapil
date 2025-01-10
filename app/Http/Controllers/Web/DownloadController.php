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
use App\Exports\OrderExport;
use App\Models\SalesAvailability;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\RoutingDownloadExport;
use App\Exports\SellingDownloadExport;
use App\Exports\PenggunaDownloadExport;
use App\Exports\VisibilityActivityExport;
use App\Traits\Downloadable;
use App\Exports\SalesActivityExport;


class DownloadController extends Controller
{
    use Downloadable;

    public function index()
    {
        $provinces = Province::orderBy('name')->get();
        $cities = City::orderBy('name')->get();

        return view('pages.download.index', compact('provinces', 'cities'));
    }

    public function downloadProduct()
    {
        return $this->handleDownload(
            ProductExport::class,
            'products'
        );
    }
    public function downloadProgram()
    {
        return $this->handleDownload(
            ProgramExport::class,
            'program'
        );
    }
    public function downloadCity()
    {
        return $this->handleDownload(
            CityExport::class,
            'kota'
        );
    }
    public function downloadRouting(Request $request)
    {
        return $this->handleDownload(
            RoutingDownloadExport::class,
            'routing',
            [$request->routing_week, $request->routing_region]
        );
    }

   // In DownloadController.php
   public function downloadActivity(Request $request)
   {
       try {
           // Initialize query with proper joins and eager loading
           $query = SalesActivity::with([
               'outlet' => function($q) {
                   $q->select('id', 'name', 'city_id')
                     ->with(['outletRoutings' => function($q) {
                         $q->select('outlet_id', 'visit_day', 'week');
                     }]);
               },
               'user' => function($q) {
                   $q->select('id', 'name');
               }
           ])->where('status', 'SUBMITTED');
   
           // Process date range if provided
           if ($request->has('activity_date') && !empty($request->activity_date)) {
               [$startDate, $endDate] = $this->processDateRange($request->activity_date);
               
               $query->whereBetween('checked_in', [
                   Carbon::parse($startDate)->startOfDay(),
                   Carbon::parse($endDate)->endOfDay()
               ]);
           }
   
           // Apply region filter if provided
           if ($request->has('activity_region') && $request->activity_region !== 'all') {
               $query->whereHas('outlet', function($q) use ($request) {
                   $q->whereHas('city', function($q) use ($request) {
                       $q->where('province_code', $request->activity_region);
                   });
               });
           }
   
           $data = $query->get();
   
           return $this->handleDownload(
               SalesActivityExport::class,
               'sales_activity',
               [$data]
           );
   
       } catch (\Exception $e) {
           Log::error('Activity download failed', [
               'error' => $e->getMessage(),
               'trace' => $e->getTraceAsString()
           ]);
   
           return response()->json([
               'message' => 'Terjadi kesalahan saat mengunduh data aktivitas: ' . $e->getMessage()
           ], 500);
       }
   }
    public function downloadVisibility(Request $request) 
    {
        [$startDate, $endDate] = $this->processDateRange($request->visibility_date);

        $query = SalesActivity::with([
            'outlet',
            'user',
            'salesVisibilities',
            'salesVisibilities.posmType'
        ])->where('status', 'SUBMITTED');

        $query = $this->applyFilters(
            $query,
            'checked_in',
            $startDate,
            $endDate,
            $request->visibility_region
        );

        $data = $query->get();

        return $this->handleDownload(
            VisibilityActivityExport::class,
            'visibility_activity',
            [$data]
        );
    }
    public function downloadAvailability(Request $request)
    {
        [$startDate, $endDate] = $this->processDateRange($request->availability_date);

        $query = SalesAvailability::with([
            'salesActivity:id,time_availability',
            'product:id,sku',
            'outlet:id,name,code,tipe_outlet,TSO,city_id,channel_id,user_id,account',
            'outlet.user:id,name',
            'outlet.city:id,name',
            'outlet.channel:id,name'
        ]);

        $query = $this->applyFilters(
            $query,
            'created_at',
            $startDate,
            $endDate,
            $request->availability_region
        );

        $data = $query->get();

        return $this->handleDownload(
            StockOnHandExport::class,
            'availability',
            [$data]
        );
    }

    public function downloadSurvey(Request $request)
    {
        try {
            [$startDate, $endDate] = $this->processDateRange($request->survey_date);
    
            Log::info('Survey download requested:', [
                'startDate' => $startDate?->format('Y-m-d'),
                'endDate' => $endDate?->format('Y-m-d'),
                'region' => $request->survey_region
            ]);
            
            return $this->handleDownload(
                SurveyExport::class,
                'market_survey',
                [$startDate, $endDate, $request->survey_region]
            );
    
        } catch (\Exception $e) {
            Log::error('Survey download failed', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengunduh data market_survey'
            ], 500);
        }
    }

    public function downloadSelling(Request $request)
    {
        try {
            Log::info('Selling download request', [
                'date_range' => $request->selling_date,
                'region' => $request->selling_region
            ]);
    
            // Handle dates
            $dates = explode(' to ', $request->selling_date);
            $startDate = Carbon::parse(trim($dates[0]));
            $endDate = Carbon::parse(trim($dates[1]));
    
            Log::info('Parsed dates', [
                'start' => $startDate->format('Y-m-d'),
                'end' => $endDate->format('Y-m-d')
            ]);
    
            // Handle region
            $region = $request->selling_region;
            if ($region === 'Semua Regional' || $region === 'all') {
                $region = 'all';
            }
    
            return $this->handleDownload(
                SellingDownloadExport::class,
                'selling',
                [$startDate, $endDate, $region]
            );
    
        } catch (\Exception $e) {
            Log::error('Selling download failed', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
    
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengunduh data selling'
            ], 500);
        }
    }

    public function downloadPengguna()
    {
        return $this->handleDownload(
            PenggunaDownloadExport::class,
            'users'
        );
    }
    public function downloadAv3m()
    {
        return $this->handleDownload(
            Av3mExport::class,
            'av3m_data'
        );
    }

    public function downloadOrders(Request $request)
    {
        [$startDate, $endDate] = $this->processDateRange($request->orders_date);

        return $this->handleDownload(
            OrderExport::class,
            'orders',
            [$startDate, $endDate, $request->orders_region]
        );
    }
}
