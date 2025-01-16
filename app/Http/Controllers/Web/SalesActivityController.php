<?php

namespace App\Http\Controllers\Web;

use Carbon\Carbon;
use App\Models\OutletForm;
use App\Models\SalesSurvey;
use Illuminate\Http\Request;
use App\Models\OutletRouting;
use App\Models\SalesActivity;
use App\Models\OutletFormAnswer;
use App\Http\Controllers\Controller;

class SalesActivityController extends Controller
{
    public function getData(Request $request)
{
    $query = SalesActivity::with(['user:id,name', 'outlet:id,name'])->orderBy('created_at', 'desc');

    if ($request->filled('search_term')) {
        $searchTerm = htmlspecialchars(trim($request->search_term));
        $query->where(function ($q) use ($searchTerm) {
            $q->WhereHas('outlet', function ($q) use ($searchTerm) {
                $q->where('name', 'like', "%{$searchTerm}%");
            })->orWhereHas('user', function ($q) use ($searchTerm) {
                $q->where('name', 'like', "%{$searchTerm}%");
            });
        });
    }

    if ($request->filled('date')) {
        $dateParam = htmlspecialchars($request->date);
        
        if (str_contains($dateParam, ' to ')) {
            [$startDate, $endDate] = explode(' to ', $dateParam);
            $query->whereBetween('created_at', [
                Carbon::parse($startDate)->startOfDay(),
                Carbon::parse($endDate)->endOfDay()
            ]);
        } else {
            $query->whereDate('created_at', Carbon::parse($dateParam));
        }
    }

    if ($request->filled('filter_day')) {
        $filter_day = htmlspecialchars($request->filter_day);
        if ($filter_day != 'all') {
            $query->where(function ($q) use ($filter_day): void {
                $q->WhereHas('outlet', function ($q) use ($filter_day) {
                    $q->whereHas('outletRoutings', function ($q) use ($filter_day) {
                        $q->where('visit_day', $filter_day);
                    });
                });
            });
        }
    }

    if ($request->filled('filter_area')) {
        $filter_area = htmlspecialchars($request->filter_area);
        if ($filter_area != 'all') {
            $query->where(function ($q) use ($filter_area): void {
                $q->WhereHas('outlet', function ($q) use ($filter_area) {
                    $q->where('city_id', $filter_area);
                });
            });
        }
    }

    $filteredRecords = (clone $query)->count();

    $result = $query->skip($request->start)
        ->take($request->length)
        ->get();

    return response()->json([
        'draw' => intval($request->draw),
        'recordsTotal' => $filteredRecords,
        'recordsFiltered' => $filteredRecords,
        'data' => $result->map(function ($item) {
            $visitDays = htmlspecialchars(getVisitDays($item->outlet_id));
            return [
                'id' => (int)$item->id,
                'outlet' => htmlspecialchars($item->outlet->name),
                'sales' => htmlspecialchars($item->user->name),
                'visit_day' => $visitDays,
                'checkin' => htmlspecialchars($item->checked_in),
                'checkout' => htmlspecialchars($item->checked_out),
                'views' => (int)$item->views_knowledge,
                'actions' => (view('pages.routing.action_sales', [
                    'salesActivityId' => $item->id
                ])->render())
            ];
        })
    ]);
}
    public function detail($id){
        $salesActivity = SalesActivity::with(['user:id,name', 'outlet:id,name'])->find($id);
        $outletId = $salesActivity->outlet_id;
        $outletForms = OutletFormAnswer::with('outletForm')->where('outlet_id', $outletId)->get();
        return view('pages.routing.sales-activity', [
            'salesActivity' => $salesActivity,
            'outletForms' => $outletForms
        ]);
    } 
}
