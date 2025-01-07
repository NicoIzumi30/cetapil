<?php

namespace App\Http\Controllers\Web;

use Carbon\Carbon;
use App\Models\User;
use App\Models\Outlet;
use App\Models\Selling;
use App\Models\Province;
use Illuminate\Http\Request;

use App\Models\SalesActivity;
use App\Models\SalesVisibility;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Cache;
use Illuminate\Contracts\Database\Eloquent\Builder;

class DashboardController extends Controller
{
    public function index()
    {
        Carbon::setLocale('id');
        $tanggal = Carbon::now()->translatedFormat('l, d F Y');
        $user = [
            'total' => User::count(),
            'date' => Carbon::parse(User::orderBy('updated_at', 'desc')
                ->value('updated_at'))
                ->isoFormat('DD MMMM YYYY')
        ];
        $visit = [
            'total' => SalesActivity::count(),
            'date' => Carbon::parse(SalesActivity::orderBy('updated_at', 'desc')
                ->value('updated_at'))
                ->isoFormat('DD MMMM YYYY')
        ];
        $selling = [
            'total' => Selling::count(),
            'date' => Carbon::parse(Selling::orderBy('updated_at', 'desc')
                ->value('updated_at'))
                ->isoFormat('DD MMMM YYYY')
        ];
        $routes = [
            'total' => Outlet::where('status', 'APPROVED')->count(),
            'date' => Carbon::parse(Outlet::where('status', 'APPROVED')
                ->orderBy('updated_at', 'desc')
                ->value('updated_at'))
                ->isoFormat('DD MMMM YYYY')
        ];
        $stock = json_encode($this->getStockAvailabilityPerCity());
        $shelving = json_encode($this->getShelvingPerCity());
        // dd($stock);
        return view('pages.dashboard.index', compact('tanggal', 'user', 'routes', 'selling', 'visit', 'stock', 'shelving'));
    }
    public function getStockAvailabilityPerCity()
    {
        // Cache key dengan timestamp untuk invalidasi otomatis setiap jam
        $cacheKey = 'stock_availability_per_city_' . now()->format('Y-m-d_H');
        
        return Cache::remember($cacheKey, now()->addHour(), function() {
            $provinces = Province::select('id', 'name', 'maps_code')->get();
            $dataStock = [];
            
            // Cache query untuk setiap provinsi
            foreach ($provinces as $province) {
                $provinceStockKey = "province_stock_{$province->id}_" . now()->format('Y-m-d');
                
                $stock = Cache::remember($provinceStockKey, now()->addHours(1), function() use ($province) {
                    $availability = DB::table('sales_availabilities')
                        ->join('outlets', 'sales_availabilities.outlet_id', '=', 'outlets.id')
                        ->join('cities', 'outlets.city_id', '=', 'cities.id')
                        ->join('provinces', 'provinces.code', '=', 'cities.province_code')
                        ->select('provinces.id', 'provinces.name', 'provinces.maps_code', 
                            DB::raw('SUM(sales_availabilities.stock_inventory) as total_stock'))
                        ->where('provinces.id', $province->id)
                        ->where('sales_availabilities.created_at', '>=', now()->subDays(30))
                        ->groupBy('cities.province_code')
                        ->first();
    
                    return $availability ? (int) $availability->total_stock : 0;
                });
    
                // Pastikan maps_code memiliki prefix 'id-'
                $mapsCode = strpos($province->maps_code, 'id-') === 0
                    ? $province->maps_code
                    : 'id-' . strtolower($province->maps_code);
    
                $dataStock[] = [$mapsCode, $stock];
            }
    
            return $dataStock;
        });
    }
    public function clearStockCache()
    {
        $provinces = Province::select('id')->get();

        // Clear cache untuk setiap provinsi
        foreach ($provinces as $province) {
            $provinceStockKey = "province_stock_{$province->id}_" . now()->format('Y-m-d');
            Cache::forget($provinceStockKey);
        }

        // Clear cache untuk keseluruhan data
        Cache::forget('stock_availability_per_city_' . now()->format('Y-m-d_H'));
    }

    // Tambahkan method untuk memperbarui cache ketika ada perubahan stock
    public function updateStockCache($provinceId)
    {
        $provinceStockKey = "province_stock_{$provinceId}_" . now()->format('Y-m-d');
        Cache::forget($provinceStockKey);
        Cache::forget('stock_availability_per_city_' . now()->format('Y-m-d_H'));

        // Trigger regenerate cache
        return $this->getStockAvailabilityPerCity();
    }
    public function getShelvingPerCity()
    {
        $provinces = Province::select('id', 'name', 'maps_code')->get();
        $dataStock = [];

        foreach ($provinces as $province) {
            $visibility = DB::table('sales_visibilities')
                ->join('sales_activities', 'sales_visibilities.sales_activity_id', '=', 'sales_activities.id')
                ->join('outlets', 'sales_activities.outlet_id', '=', 'outlets.id')
                ->join('cities', 'outlets.city_id', '=', 'cities.id')
                ->join('provinces', 'provinces.code', '=', 'cities.province_code')
                ->select('provinces.id', 'provinces.name', 'provinces.maps_code', DB::raw('SUM(sales_visibilities.shelving) as total_shelving'))
                ->where('provinces.id', $province->id)
                ->groupBy('cities.province_code')
                ->first();

            $shelving = $visibility ? (int) $visibility->total_shelving : 0;

            // Pastikan maps_code memiliki prefix 'id-'
            $mapsCode = strpos($province->maps_code, 'id-') === 0
                ? $province->maps_code
                : 'id-' . strtolower($province->maps_code);

            $dataStock[] = [$mapsCode, $shelving];
        }

        return $dataStock;
    }
    private function getAverageMetrics($timeField, Request $request)
    {
        // Base query
        $baseQuery = SalesActivity::where('status', 'SUBMITTED');

        // Apply date filter if exists
        if ($request->date) {
            $dates = explode(' to ', $request->date);
            $startDate = trim($dates[0] ?? '');
            $endDate = trim($dates[1] ?? '');
            $baseQuery->whereBetween('updated_at', [$startDate, $endDate]);
        }

        // Get GT and MT averages menggunakan array associative
        $averages = collect(['GT', 'MT'])->mapWithKeys(function ($category) use ($baseQuery, $request, $timeField) {
            return [
                $category => $baseQuery->clone()
                    ->whereHas('outlet', function ($q) use ($category, $request) {
                        $q->where('category', $category);
                        if ($request->visit_day) {
                            $q->where('visit_day', $request->visit_day);
                        }
                    })
                    ->avg($timeField) ?? 0
            ];
        });

        // Calculate metrics
        $avg_gt = $averages['GT'];
        $avg_mt = $averages['MT'];
        $avg_all = ($avg_gt + $avg_mt) / 2;
        $total = $avg_gt + $avg_mt;
        $max_progres = max($avg_gt, $avg_mt);

        // Calculate percentages
        return [
            'avg_gt' => $this->formatToMinutesSeconds($avg_gt),
            'avg_mt' => $this->formatToMinutesSeconds($avg_mt),
            'avg_all' => gmdate('H:i:s', $avg_all),
            'gt_contribution' => $total > 0 ? number_format(($avg_gt / $total * 100), 2) : 0,
            'mt_contribution' => $total > 0 ? number_format(($avg_mt / $total * 100), 2) : 0,
            'progres_gt' => $max_progres > 0 ? number_format(($avg_gt / $max_progres * 100), 2) : 0,
            'progres_mt' => $max_progres > 0 ? number_format(($avg_mt / $max_progres * 100), 2) : 0
        ];
    }

    private function formatToMinutesSeconds($seconds)
    {
        $minutes = floor($seconds / 60);
        $remainingSeconds = floor($seconds % 60);
        return $minutes . 'm ' . $remainingSeconds . 's';
    }

    public function avg_availability(Request $request)
    {
        return json_encode($this->getAverageMetrics('time_availability', $request));
    }

    public function avg_visibility(Request $request)
    {
        return json_encode($this->getAverageMetrics('time_visibility', $request));
    }

    public function avg_survey(Request $request)
    {
        return json_encode($this->getAverageMetrics('time_survey', $request));
    }
}
