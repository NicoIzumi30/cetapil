<?php

namespace App\Http\Controllers\Web;

use Carbon\Carbon;
use App\Models\User;
use App\Models\Outlet;
use App\Models\Province;
use Illuminate\Http\Request;

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
            'total' => User::role(['sales', 'merchandiser'])->count(),
            'date' => Carbon::parse(User::role(['sales', 'merchandiser'])
                ->orderBy('updated_at', 'desc')
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
        $visibility_activity = [
            'total' => SalesVisibility::count(),
            'date' => Carbon::parse(SalesVisibility::
                orderBy('updated_at', 'desc')
                ->value('updated_at'))
                ->isoFormat('DD MMMM YYYY')
        ];
        $stock = json_encode($this->getStockAvailabilityPerCity());
        $count = json_encode($this->getCountVisibilityPerCity());
        return view('pages.dashboard.index', compact('tanggal', 'user', 'routes', 'visibility_activity', 'stock','count'));
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
                ->select('provinces.id', 'provinces.name', 'provinces.maps_code', DB::raw('SUM(sales_availabilities.stock_on_hand) as total_stock'))
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
    public function getCountVisibilityPerCity()
{
    // Gunakan query builder untuk menghindari perulangan
    $visibilityData = DB::table('sales_visibilities')
        ->join('sales_activities', 'sales_visibilities.sales_activity_id', '=', 'sales_activities.id')
        ->join('outlets', 'sales_activities.outlet_id', '=', 'outlets.id')
        ->join('cities', 'outlets.city_id', '=', 'cities.id')
        ->join('provinces', 'provinces.code', '=', 'cities.province_code')
        ->select(
            'provinces.id', 
            'provinces.name', 
            'provinces.maps_code', 
            DB::raw('COUNT(sales_visibilities.id) as total_visibility')
        )
        ->where('sales_visibilities.created_at', '>=', Carbon::now()->subDays(30))
        ->groupBy('provinces.id', 'provinces.name', 'provinces.maps_code')
        ->get();

    $dataCount = $visibilityData->map(function ($province) {
        // Pastikan maps_code memiliki prefix 'id-'
        $mapsCode = strpos($province->maps_code, 'id-') === 0
            ? $province->maps_code
            : 'id-' . strtolower($province->maps_code);

        return [
            $mapsCode, 
            (int) $province->total_visibility
        ];
    })->toArray();

    return $dataCount;
}
    public function getRoutingPercentage()
    {
        $currentDateTime = Carbon::now();
        $currentDayNumber = $currentDateTime->dayOfWeek;
        // $start_date = $request->input('start_date', null);
        // $end_date = $request->input('end_date', null);
        // $cities = $request->input('city_ids') ? explode(',', $request->city_ids): null;
        // $sales = $request->input('sales_ids') ? explode(',', $request->sales_ids): null;

        $query = Outlet::query()
            ->leftJoin('sales_activities', 'sales_activities.outlet_id', '=', 'outlets.id');


        // if ($start_date && $end_date) {
        // $from = Carbon::parse($start_date)->startOfDay();
        // $to = Carbon::parse($end_date)->endOfDay();
        // $query->whereBetween('checked_in', [$from, $to]);
        // } else {
        // $query->whereDate('checked_in', $currentDateTime);
        // }

        if ($currentDayNumber == 0)
            $currentDayNumber = 7;
        $week_type = "ODD";
        if ($currentDateTime->weekOfYear % 2 == 0)
            $week_type = "EVEN";
        $query->where('visit_day', $currentDayNumber)->where(function (Builder $query) use ($week_type) {
            $query->where('cycle', '1x1')
                ->orWhere(function (Builder $query) use ($week_type) {
                    $query->where('cycle', '1x2')
                        ->where('week_type', $week_type);
                });
        });

        // if ($cities) {
        //     $query->whereIn('outlets.city_id', $cities);
        // }

        // if ($sales) {
        //     $query->whereIn('outlets.user_id', $sales);
        // }
        $query->groupBy('outlets.id', 'sales_activities.id', 'outlets.category')
            ->select(
                'sales_activities.id as sales_activities_id',
                'outlets.id as outlet_id',
                'outlets.category as outlet_category'
            );

        $total_data = (int) DB::table(DB::raw("({$query->toSql()}) as query"))
            ->mergeBindings($query->getQuery())
            ->count();

        $total_visited_routing = (int) DB::table(DB::raw("({$query->toSql()}) as query"))
            ->mergeBindings($query->getQuery())
            ->whereNotNull('sales_activities_id')
            ->count();

        $total_gt = (int) DB::table(DB::raw("({$query->toSql()}) as query"))
            ->mergeBindings($query->getQuery())
            ->where('outlet_category', 'GT')
            ->count();

        $gt_percentage = $total_data > 0 ? round($total_gt / $total_data * 100) : 0;

        $total_mt = (int) DB::table(DB::raw("({$query->toSql()}) as query"))
            ->mergeBindings($query->getQuery())
            ->where('outlet_category', 'MT')
            ->count();

        $mt_percentage = $total_data > 0 ? round($total_mt / $total_data * 100) : 0;

        $total_visited_routing_percentage = $total_data > 0 ? round($total_visited_routing / $total_data * 100) : 0;

        return [
            'total_data' => $total_data,
            'total_visited_routing' => $total_visited_routing,
            'total_visited_routing_percentage' => $total_visited_routing_percentage,
            'total_gt' => $total_gt,
            'gt_percentage' => $gt_percentage,
            'total_mt' => $total_mt,
            'mt_percentage' => $mt_percentage
        ];
    }
}
