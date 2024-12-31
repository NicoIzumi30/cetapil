<?php

namespace App\Http\Controllers\Api;

use App\Constants\DashboardConstants;
use App\Http\Controllers\Controller;
use App\Models\Outlet;
use App\Models\SalesActivity;
use App\Models\Selling;
use App\Traits\HasAuthUser;
use Carbon\Carbon;
use Carbon\CarbonPeriod;
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

        $currentDayNumber = $now->dayOfWeek;
        $currentDayNumber = $currentDayNumber === 0 ? 7 : $currentDayNumber;

        $currentWeek = $now->weekOfMonth;
        $weekNumber = $currentWeek > 4 ? $currentWeek % 4 : $currentWeek;

        $outlet_query = Outlet::where('user_id', $user->id)
            ->whereNull('deleted_at')
            ->approved()
            ->where(function ($query) use ($currentDayNumber, $weekNumber) {
                $query->orWhere(function ($q) use ($currentDayNumber) {
                    $q->where('cycle', '1x1')
                        ->where('visit_day', $currentDayNumber);
                });

                $query->orWhere(function ($q) use ($currentDayNumber, $weekNumber) {
                    $q->where('cycle', '1x2')
                        ->where('visit_day', $currentDayNumber)
                        ->where(function ($w) use ($weekNumber) {
                            $w->orWhere('week', (string)$weekNumber);
                            if (in_array($weekNumber, [1, 3])) {
                                $w->orWhere('week', '1&3');
                            }
                            if (in_array($weekNumber, [2, 4])) {
                                $w->orWhere('week', '2&4');
                            }
                        });
                });

                $query->orWhere(function ($q) use ($currentDayNumber, $weekNumber) {
                    $q->where('cycle', '1x4')
                        ->where('visit_day', $currentDayNumber)
                        ->where('week', (string)$weekNumber);
                });
            });

        $total_outlet = (int) DB::table(DB::raw("({$outlet_query->toSql()}) as query"))
            ->mergeBindings($outlet_query->getQuery())
            ->count();

        $total_actual_plan = (int) SalesActivity::where('user_id', $user->id)
            ->whereNull('deleted_at')
            ->whereDate('checked_in', $now)
            ->whereNotNull('checked_out')
            ->count();

        $total_call_plan = (int) DB::table(DB::raw("({$outlet_query->toSql()}) as query"))
            ->mergeBindings($outlet_query->getQuery())
            ->count();

        $current_outlet = $this->getCurrentOutlet($user, $now, $currentDayNumber, $weekNumber);

        if ($current_outlet && isset($current_outlet['check_in_latitude']) && isset($current_outlet['check_in_longitude'])) {
            $current_outlet['distance_to_outlet'] = $this->calculateDistance(
                $current_outlet['check_in_latitude'],
                $current_outlet['check_in_longitude'],
                $current_outlet['outlet_latitude'],
                $current_outlet['outlet_longitude']
            );
        }

        $power_skus = DB::table('power_skus as ps')
            ->whereNull('ps.deleted_at')
            ->join('products as p', 'ps.product_id', '=', 'p.id')
            ->where('p.deleted_at', null)
            ->select('p.sku', 'ps.product_id')
            ->get()
            ->map(function ($powerSku) use ($user) {
                $total_outlets = DB::table('outlets')
                    ->where('user_id', $user->id)
                    ->whereNull('deleted_at')
                    ->count();

                $available_count = DB::table('outlets as o')
                    ->whereNull('o.deleted_at')
                    ->join('sales_activities as sa', 'sa.outlet_id', '=', 'o.id')
                    ->whereNull('sa.deleted_at')
                    ->join('sales_surveys as ss', 'ss.sales_activity_id', '=', 'sa.id')
                    ->whereNull('ss.deleted_at')
                    ->join('survey_questions as sq', function ($join) use ($powerSku) {
                        $join->on('ss.survey_question_id', '=', 'sq.id')
                            ->where('sq.type', '=', 'bool')
                            ->where('sq.product_id', '=', $powerSku->product_id)
                            ->whereNull('sq.deleted_at');
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
            ->whereNull('deleted_at')
            ->whereNotNull('checked_out')
            ->latest('checked_out')
            ->first()
            ->checked_out ?? null;

        $latest_power_sku_update = DB::table('sales_surveys as ss')
            ->whereNull('ss.deleted_at')
            ->join('sales_activities as sa', 'sa.id', '=', 'ss.sales_activity_id')
            ->whereNull('sa.deleted_at')
            ->join('survey_questions as sq', 'ss.survey_question_id', '=', 'sq.id')
            ->whereNull('sq.deleted_at')
            ->join('power_skus as ps', 'ps.product_id', '=', 'sq.product_id')
            ->whereNull('ps.deleted_at')
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

    public function getCalendarActivities(Request $request)
    {
        $user = $this->getAuthUser();

        // Get month and year from request, default to current month/year
        $month = $request->month ?? now()->month;
        $year = $request->year ?? now()->year;

        // Create date range for the specified month
        $startDate = Carbon::createFromDate($year, $month, 1)->startOfMonth();
        $endDate = Carbon::createFromDate($year, $month, 1)->endOfMonth();

        // Get sales activities
        $salesActivities = SalesActivity::where('user_id', $user->id)
            ->whereNotNull('checked_out')
            ->whereYear('checked_in', $year)
            ->whereMonth('checked_in', $month)
            ->get()
            ->groupBy(function ($activity) {
                return Carbon::parse($activity->checked_in)->format('Y-m-d');
            });

        // Get outlets created
        $outlets = Outlet::where('user_id', $user->id)
            ->whereYear('created_at', $year)
            ->whereMonth('created_at', $month)
            ->get()
            ->groupBy(function ($outlet) {
                return Carbon::parse($outlet->created_at)->format('Y-m-d');
            });

        // Get selling activities
        $sellingActivities = Selling::where('user_id', $user->id)
            ->whereYear('created_at', $year)
            ->whereMonth('created_at', $month)
            ->get()
            ->groupBy(function ($selling) {
                return Carbon::parse($selling->created_at)->format('Y-m-d');
            });

        // Create date range array for the month
        $period = CarbonPeriod::create($startDate, $endDate);

        $calendarData = [];
        foreach ($period as $date) {
            $dateString = $date->format('Y-m-d');
            $calendarData[] = [
                'date' => $dateString,
                'day' => $date->day,
                'activities' => [
                    'sales' => [
                        'has_activity' => isset($salesActivities[$dateString]),
                        'total' => isset($salesActivities[$dateString]) ? count($salesActivities[$dateString]) : 0
                    ],
                    'outlets' => [
                        'has_activity' => isset($outlets[$dateString]),
                        'total' => isset($outlets[$dateString]) ? count($outlets[$dateString]) : 0
                    ],
                    'selling' => [
                        'has_activity' => isset($sellingActivities[$dateString]),
                        'total' => isset($sellingActivities[$dateString]) ? count($sellingActivities[$dateString]) : 0
                    ]
                ],
                'has_any_activity' => (
                    isset($salesActivities[$dateString]) ||
                    isset($outlets[$dateString]) ||
                    isset($sellingActivities[$dateString])
                )
            ];
        }

        $response = [
            'month' => $month,
            'year' => $year,
            'total_days' => count($calendarData),
            'calendar_data' => $calendarData
        ];

        return $this->successResponse(
            'Calendar data retrieved successfully',
            HTTPCode::HTTP_OK,
            $response
        );
    }
}
