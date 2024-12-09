<?php

namespace App\Http\Controllers\Api;

use App\Constants\DashboardConstants;
use App\Http\Controllers\Controller;
use App\Models\Outlet;
use App\Models\SalesActivity;
use App\Traits\HasAuthUser;
use Carbon\Carbon;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Symfony\Component\HttpFoundation\Response as HTTPCode;

use function PHPUnit\Framework\callback;

class DashboardController extends Controller
{
    use  HasAuthUser;
    public function index()
    {
        $user = $this->getAuthUser();
        $now = Carbon::now();
        $outlet_query = Outlet::where('user_id', $user->id);

        $total_outlet = (int) DB::table(DB::raw("({$outlet_query->toSql()}) as query"))
            ->mergeBindings($outlet_query->getQuery())
            ->count();

        $total_actual_plan = (int) SalesActivity::where('user_id', $user->id)
            ->whereDate('checked_in', $now)
            ->whereNotNull('checked_out')
            ->count();

        $week_type = "ODD";
        $currentDayNumber = $now->dayOfWeek;
        if ($currentDayNumber == 0) $currentDayNumber = 7;
        if ($now->weekOfYear % 2 == 0) $week_type = "EVEN";

        $total_call_plan = (int) DB::table(DB::raw("({$outlet_query->toSql()}) as query"))
            ->mergeBindings($outlet_query->getQuery())
            ->where('visit_day', $currentDayNumber)
            ->where(function (Builder $query) use ($week_type) {
                $query->where('cycle', '1x1')
                    ->orWhere(function (Builder $query) use ($week_type) {
                        $query->where('cycle', '1x2')
                            ->where('week_type', $week_type);
                    });
            })
            ->count();

        $current_outlet = $this->getCurrentOutlet($user, $now, $currentDayNumber, $week_type);

        // Add distance calculation for current outlet if check-in coordinates exist
        if ($current_outlet && isset($current_outlet['check_in_latitude']) && isset($current_outlet['check_in_longitude'])) {
            $current_outlet['distance_to_outlet'] = $this->calculateDistance(
                $current_outlet['check_in_latitude'],
                $current_outlet['check_in_longitude'],
                $current_outlet['outlet_latitude'],
                $current_outlet['outlet_longitude']
            );
        }

        $power_skus = DB::table('power_skus as ps')
            ->join('products as p', 'ps.product_id', '=', 'p.id')
            ->select('p.sku', 'ps.product_id')
            ->get()
            ->map(function ($powerSku) use ($user) {
                $total_outlets = DB::table('outlets')
                    ->where('user_id', $user->id)
                    ->count();

                $available_count = DB::table('outlets as o')
                    ->join('sales_activities as sa', 'sa.outlet_id', '=', 'o.id')
                    ->join('sales_surveys as ss', 'ss.sales_activity_id', '=', 'sa.id')
                    ->join('survey_questions as sq', function ($join) use ($powerSku) {
                        $join->on('ss.survey_question_id', '=', 'sq.id')
                            ->where('sq.type', '=', 'bool')
                            ->where('sq.product_id', '=', $powerSku->product_id);
                    })
                    ->where('o.user_id', $user->id)
                    ->where('ss.answer', '=', 'true')
                    ->distinct('o.id')
                    ->count('o.id');

                return [
                    'sku' => $powerSku->sku,
                    'total_outlets' => $total_outlets,
                    'available_count' => $available_count,
                    'availability_percentage' => $total_outlets ?
                        round(($available_count / $total_outlets) * 100, 2) : 0
                ];
            })
            ->sortByDesc('availability_percentage')
            ->values()
            ->all();

        $latest_performance_update = SalesActivity::where('user_id', $user->id)
            ->whereNotNull('checked_out')
            ->latest('checked_out')
            ->first()
            ->checked_out ?? null;

        $latest_power_sku_update = DB::table('sales_surveys as ss')
            ->join('sales_activities as sa', 'sa.id', '=', 'ss.sales_activity_id')
            ->join('survey_questions as sq', 'ss.survey_question_id', '=', 'sq.id')
            ->join('power_skus as ps', 'ps.product_id', '=', 'sq.product_id')
            ->where('sa.user_id', $user->id)
            ->whereNotNull('sa.checked_out')
            ->latest('sa.checked_out')
            ->first()
            ->checked_out ?? null;

        $performance_update = $latest_performance_update ?
            Carbon::parse($latest_performance_update)->format('d F Y') :
            $now->format('d F Y');

        $power_sku_update = $latest_power_sku_update ?
            Carbon::parse($latest_power_sku_update)->format('d F Y') :
            $now->format('d F Y');

        return $this->successResponse(
            DashboardConstants::GET_MOBILE_DASH,
            HTTPCode::HTTP_OK,
            [
                'city' => $user->city,
                'region' => $user->region,
                'role' => 'Sales',
                'total_outlet' => $total_outlet,
                'total_actual_plan' => $total_actual_plan,
                'total_call_plan' => $total_call_plan,
                'plan_percentage' => $total_actual_plan && $total_call_plan ?
                    round($total_actual_plan / $total_call_plan * 100) : 0,
                'current_outlet' => $current_outlet,
                'power_skus' => $power_skus,
                'last_performance_update' => $performance_update,
                'last_power_sku_update' => $power_sku_update
            ]
        );
    }

    private function calculateDistance($lat1, $lon1, $lat2, $lon2)
    {
        // Convert decimal degrees to radians
        $lat1 = deg2rad($lat1);
        $lon1 = deg2rad($lon1);
        $lat2 = deg2rad($lat2);
        $lon2 = deg2rad($lon2);

        // Haversine formula
        $dlat = $lat2 - $lat1;
        $dlon = $lon2 - $lon1;
        $a = sin($dlat / 2) * sin($dlat / 2) + cos($lat1) * cos($lat2) * sin($dlon / 2) * sin($dlon / 2);
        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

        // Earth's radius in meters
        $r = 6371000;

        // Calculate distance
        return $r * $c;
    }

    private function formatDistance($meters)
    {
        if ($meters >= 1000) {
            return round($meters / 1000, 2) . ' km';
        } elseif ($meters >= 1) {
            return round($meters, 1) . ' m';
        } else {
            // For distances less than 1 meter, convert to centimeters
            return round($meters * 100, 1) . ' cm';
        }
    }

    private function getCurrentOutlet($user, $now, $currentDayNumber, $week_type)
    {
        $current_outlet = SalesActivity::completeRelation()
            ->where('user_id', $user->id)
            ->whereDate('checked_in', $now)
            ->whereNull('checked_out')
            ->with('outlet')
            ->first();

        if (!$current_outlet) {
            $current_outlet = Outlet::where('user_id', $user->id)
                ->where('visit_day', $currentDayNumber)
                ->where(function ($query) use ($week_type) {
                    $query->where('cycle', '1x1')
                        ->orWhere(function ($query) use ($week_type) {
                            $query->where('cycle', '1x2')
                                ->where('week_type', $week_type);
                        });
                })
                ->where(function ($builder) use ($now) {
                    $builder
                        ->whereHas(
                            relation: 'salesActivities',
                            callback: fn($activity) => $activity->where(function ($q) use ($now) {
                                $q->where(function ($q1) use ($now) {
                                    $q1->whereDate('checked_in', $now)->whereNull('checked_out');
                                })
                                    ->orWhere(function ($q2) use ($now) {
                                        $q2->whereDate('checked_in', '!=', $now);
                                    });
                            })
                        )
                        ->orWhereDoesntHave('salesActivities');
                })
                ->first();

            return $current_outlet ? [
                'outlet_id' => $current_outlet->id,
                'sales_activity_id' => null,
                'name' => $current_outlet->name,
                'checked_in' => null,
                'checked_out' => null,
                'outlet_latitude' => $current_outlet->latitude,
                'outlet_longitude' => $current_outlet->longitude,
                'radius' => null
            ] : [
                'outlet_id' => null,
                'sales_activity_id' => null,
                'name' => '-',
                'checked_in' => null,
                'checked_out' => null,
                'radius' => null
            ];
        }

        $radius = null;
        if (
            $current_outlet->latitude && $current_outlet->longitude &&
            $current_outlet->outlet->latitude && $current_outlet->outlet->longitude
        ) {
            $meters = $this->calculateDistance(
                $current_outlet->latitude,
                $current_outlet->longitude,
                $current_outlet->outlet->latitude,
                $current_outlet->outlet->longitude
            );

            $radius = $this->formatDistance($meters);
        }

        return [
            'outlet_id' => $current_outlet->outlet->id,
            'sales_activity_id' => $current_outlet->id,
            'name' => $current_outlet->outlet->name,
            'checked_in' => $current_outlet->checked_in,
            'checked_out' => null,
            'outlet_latitude' => $current_outlet->outlet->latitude,
            'outlet_longitude' => $current_outlet->outlet->longitude,
            'check_in_latitude' => $current_outlet->latitude,
            'check_in_longitude' => $current_outlet->longitude,
            'radius' => $radius
        ];
    }

    public function performanceIndex()
    {
        $user = $this->getAuthUser();
        $now = Carbon::now();
        $outlet_query = Outlet::where('user_id', $user->id);

        $total_1x1_cycle = (int) DB::table(DB::raw("({$outlet_query->toSql()}) as query"))
            ->mergeBindings($outlet_query->getQuery())
            ->where('cycle', '1x1')
            ->count() * 4;

        $total_1x2_cycle = (int) DB::table(DB::raw("({$outlet_query->toSql()}) as query"))
            ->mergeBindings($outlet_query->getQuery())
            ->where('cycle', '1x2')
            ->count() * 2;

        $total_call_plan = $total_1x1_cycle + $total_1x2_cycle;

        $actual_plan_query = SalesActivity::where('user_id', $user->id)
            ->whereMonth('checked_in', $now->month)
            ->whereNotNull('checked_out');

        $last_updated_query = clone $actual_plan_query;
        $last_updated = $last_updated_query->first()?->updated_at->toDateTimeString() ?? null;

        $total_actual_plan = $actual_plan_query->count();

        $plan_percentage = $total_actual_plan && $total_call_plan ? round($total_actual_plan / $total_call_plan * 100) : 0;

        return $this->successResponse(DashboardConstants::GET_PERFORMANCE, HTTPCode::HTTP_OK, compact(
            'total_call_plan',
            'total_actual_plan',
            'plan_percentage',
            'last_updated'
        ));
    }

    public function getPowerSkus()
    {
        $user = $this->getAuthUser();

        $powerSkus = DB::table('power_skus as ps')
            ->join('products as p', 'ps.product_id', '=', 'p.id')
            ->select('p.sku', 'ps.product_id')
            ->get();

        $stats = $powerSkus->map(function ($powerSku) use ($user) {
            $total_outlets = DB::table('outlets')
                ->where('user_id', $user->id)
                ->count();

            $available_count = DB::table('outlets as o')
                ->join('sales_activities as sa', 'sa.outlet_id', '=', 'o.id')
                ->join('sales_surveys as ss', 'ss.sales_activity_id', '=', 'sa.id')
                ->join('survey_questions as sq', function ($join) use ($powerSku) {
                    $join->on('ss.survey_question_id', '=', 'sq.id')
                        ->where('sq.type', '=', 'bool')
                        ->where('sq.product_id', '=', $powerSku->product_id);
                })
                ->where('o.user_id', $user->id)
                ->where('ss.answer', '=', 'true')
                ->distinct('o.id')
                ->count('o.id');

            return [
                'sku' => $powerSku->sku,
                'total_outlets' => $total_outlets,
                'available_count' => $available_count,
                'availability_percentage' => $total_outlets ?
                    round(($available_count / $total_outlets) * 100, 2) : 0
            ];
        })
            ->sortByDesc('availability_percentage')
            ->values()
            ->all();

        return $this->successResponse(
            'Power SKU statistics retrieved successfully',
            HTTPCode::HTTP_OK,
            $stats
        );
    }
}
