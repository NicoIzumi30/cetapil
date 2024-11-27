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

class RoutingController extends Controller
{
    use HasAuthUser, OutletTrait;
    public function index(Request $request)
    {
        Carbon::setLocale('id');
        $weekNumber = date('W');
        $currentDay = Carbon::now()->dayOfWeek;
        $currentDay = $currentDay === 0 ? '7' : (string) $currentDay;

        $week = 'ODD';
        if ($weekNumber % 2 == 0) {
            $week = 'EVEN';
        }

        $user = $this->getAuthUser();
        $outlets = Outlet::query()
            ->approved()
            ->where('user_id', $user->id)
            ->where(function ($query) use ($week) {
                $query->where('cycle', '1x1')
                    ->orWhere(function ($q) use ($week) {
                        $q->where('cycle', '1x2')
                            ->where('week_type', $week);
                    });
            })
            ->with(['salesActivities' => function ($query) use ($user) {
                $query->where('user_id', $user->id)
                    ->whereDate('checked_in', Carbon::today())
                    ->select('id', 'outlet_id', 'checked_in', 'checked_out', 'status');
            }])
            ->where(function ($query) use ($currentDay, $user) {
                $query->where('visit_day', $currentDay)
                    ->orWhereHas('salesActivities', function ($q) use ($user) {
                        $q->where('user_id', $user->id)
                            ->whereDate('checked_in', Carbon::today());
                    });
            });

        // if ($request->filled('keyword')) {
        //     $outlets->where(function ($query) use ($request) {
        //         $query->where('name', 'like', '%' . $request->keyword . '%');
        //     });
        // }

        $outlets = $outlets->get();
        return new RoutingCollection($outlets);
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

        $activity = SalesActivity::whereDate('checked_in', $now)
            ->where([
                ['outlet_id', $data['outlet_id']],
                ['user_id', $user->id]
            ])->first();
        if (!$activity) {
            $activity = SalesActivity::create([
                'checked_in' => $data['checked_in'],
                'outlet_id' => $data['outlet_id'],
                'user_id' => $user->id
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
}
