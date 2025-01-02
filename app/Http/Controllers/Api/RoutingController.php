<?php

namespace App\Http\Controllers\Api;

use App\Constants\RoutingConstants;
use App\Http\Controllers\Controller;
use App\Http\Requests\Routing\CheckInRequest;
use App\Http\Requests\Routing\CheckOutRequest;
use App\Http\Resources\Routing\RoutingCollection;
use App\Http\Resources\SalesActivity\SalesActivityResource;
use App\Models\Outlet;
use App\Models\SalesActivity;
use App\Models\SalesSurvey;
use App\Traits\HasAuthUser;
use App\Traits\OutletTrait;
use Illuminate\Http\Request;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Carbon;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\FacadesDB;
use Illuminate\Support\Facades\Log;

class RoutingController extends Controller
{
    use HasAuthUser, OutletTrait;
    public function index(Request $request)
    {
        Carbon::setLocale('id');
        $now = Carbon::now('Asia/Jakarta');

        $currentWeek = $now->weekOfMonth;
        $currentDay = $now->dayOfWeek;
        $currentDay = $currentDay === 0 ? '7' : (string) $currentDay;
        $weekNumber = $currentWeek > 4 ? $currentWeek % 4 : $currentWeek;
        $user = $this->getAuthUser();

        $outlets = Outlet::query()
            ->approved()
            ->where('user_id', $user->id)
            ->where(function ($query) use ($currentDay, $weekNumber, $user, $now) {
                $query->where(function ($q) use ($currentDay, $weekNumber) {
                    // 1x1 cycle
                    $q->orWhere(function ($inner) use ($currentDay) {
                        $inner->where('cycle', '1x1')
                            ->where('visit_day', $currentDay);
                    });

                    // 1x2 cycle
                    $q->orWhere(function ($inner) use ($currentDay, $weekNumber) {
                        $inner->where('cycle', '1x2')
                            ->where('visit_day', $currentDay)
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

                    // 1x4 cycle
                    $q->orWhere(function ($inner) use ($currentDay, $weekNumber) {
                        $inner->where([
                            ['cycle', '1x4'],
                            ['visit_day', $currentDay],
                            ['week', (string)$weekNumber]
                        ]);
                    });
                })
                    ->orWhereHas('salesActivities', function ($q) use ($user, $now) {
                        $q->where('user_id', $user->id)
                            ->whereDate('checked_in', $now->toDateString());
                    });
            })
            ->with(['salesActivities' => function ($query) use ($user, $now) {
                $query->where('user_id', $user->id)
                    ->whereDate('checked_in', $now->toDateString())
                    ->select('id', 'outlet_id', 'checked_in', 'checked_out', 'status');
            }]);

        $result = $outlets->get();
        return new RoutingCollection($result);
    }

    public function checkIn(CheckInRequest $request)
    {
        $now = Carbon::now();
        $data = $request->validated();
        $user = $this->getAuthUser();

        $not_checked_out = SalesActivity::whereDate('checked_in', $now)
            ->where('user_id', $user->id)
            ->where('outlet_id', '<>', $data['outlet_id'])
            ->whereNull('checked_out')
            ->first();
        if ($not_checked_out) {
            return $this->failedResponse(RoutingConstants::FAILED_CHECK_IN, Response::HTTP_BAD_REQUEST);
        }

        // Get outlet for location calculation
        $outlet = Outlet::findOrFail($data['outlet_id']);

        // Calculate radius using Haversine formula
        $radius = $this->calculateDistance(
            $data['latitude'],
            $data['longitude'],
            $outlet->latitude,
            $outlet->longitude
        );

        // Determine radius status
        $radius_status = $this->determineRadiusStatus($radius);

        $activity = SalesActivity::whereDate('checked_in', $now)
            ->where([
                ['outlet_id', $data['outlet_id']],
                ['user_id', $user->id]
            ])->first();

        if (!$activity) {
            $activity = SalesActivity::create([
                'checked_in' => $data['checked_in'],
                'outlet_id' => $data['outlet_id'],
                'user_id' => $user->id,
                'latitude' => $data['latitude'],
                'longitude' => $data['longitude'],
                'radius' => $radius,
                'radius_status' => $radius_status
            ]);
        }

        return $this->successResponse(RoutingConstants::CHECK_IN, Response::HTTP_OK, new SalesActivityResource($activity));
    }

    public function checkOut(CheckOutRequest $request)
    {
        $data = Arr::except($request->validated(), 'sales_activity_id');
        $activity = SalesActivity::completeRelation()->findOrFail($request->sales_activity_id);
        $activity->fill($data);
        $survey_exists = SalesSurvey::where('sales_activity_id', $request->sales_activity_id)->first();
        if ($survey_exists) {
            $activity->status = 'SUBMITTED';
        }
        $activity->save();

        return $this->successResponse(RoutingConstants::CHECK_OUT, Response::HTTP_OK, new SalesActivityResource($activity));
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
        return round($r * $c, 2);
    }

    /**
     * Determine radius status based on distance
     */
    private function determineRadiusStatus($radius)
    {
        if ($radius <= 100) {
            return 'ONSITE';
        } else {
            return 'OFFSITE';
        }
    }
}
