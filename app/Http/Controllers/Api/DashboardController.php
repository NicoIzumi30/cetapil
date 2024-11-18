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

            // There's a routing today
            // CASE ready to check in
            $checked_in_outlet = $current_outlet ? [
                'outlet_id' => $current_outlet->id,
                'sales_activity_id' => null,
                'name' => $current_outlet->name,
                'checked_in' => null,
                'checked_out' => null,
            ] : [
                // There's no routing today
                'outlet_id' => null,
                'sales_activity_id' => null,
                'name' => '-',
                'checked_in' => null,
                'checked_out' => null,
            ];
        } else {
            // There's a checked in data
            // CASE ready to check out
            $checked_in_outlet = [
                'outlet_id' => $current_outlet->outlet->id,
                'sales_activity_id' => $current_outlet->id,
                'name' => $current_outlet->outlet->name,
                'checked_in' => $current_outlet->checked_in,
                'checked_out' => null,
            ];
        }

        $data = [
            'city' => $user->city,
            'region' => $user->region,
            'role' => 'Sales',
            'total_outlet' => $total_outlet,
            'total_actual_plan' => $total_actual_plan,
            'total_call_plan' => $total_call_plan,
            'plan_percentage' => $total_actual_plan && $total_call_plan ? round($total_actual_plan / $total_call_plan * 100) : 0,
            'current_outlet' => $checked_in_outlet
        ];

        return $this->successResponse(DashboardConstants::GET_MOBILE_DASH, HTTPCode::HTTP_OK, $data);
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
}
