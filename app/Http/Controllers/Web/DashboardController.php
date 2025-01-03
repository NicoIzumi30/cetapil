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
        $provinces = Province::select('id', 'name', 'maps_code')->get();
        $dataStock = [];

        foreach ($provinces as $province) {
            $availability = DB::table('sales_availabilities')
                ->join('outlets', 'sales_availabilities.outlet_id', '=', 'outlets.id')
                ->join('cities', 'outlets.city_id', '=', 'cities.id')
                ->join('provinces', 'provinces.code', '=', 'cities.province_code')
                ->select('provinces.id', 'provinces.name', 'provinces.maps_code', DB::raw('SUM(sales_availabilities.stock_inventory) as total_stock'))
                ->where('provinces.id', $province->id)
                ->groupBy('cities.province_code')
                ->first();

            $stock = $availability ? (int) $availability->total_stock : 0;

            // Pastikan maps_code memiliki prefix 'id-'
            $mapsCode = strpos($province->maps_code, 'id-') === 0
                ? $province->maps_code
                : 'id-' . strtolower($province->maps_code);

            $dataStock[] = [$mapsCode, $stock];
        }

        return $dataStock;
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
    public function avg_availability(){
        return json_encode([
            'time_avg'=> '03:00:00',
            'time_gt'=> '05m:30s',
            'time_mt'=> '10m:30s',
        ]);
    } 
    public function avg_visibility(){
        return json_encode([
            'time_avg'=> '01:40:12',
            'time_gt'=> '04m:30s',
            'time_mt'=> '01m:30s',
        ]);
    } 
    public function avg_survey(){
        return json_encode([
            'time_avg'=> '00:10:12',
            'time_gt'=> '09m:30s',
            'time_mt'=> '08m:30s',
        ]);
    } 
}
