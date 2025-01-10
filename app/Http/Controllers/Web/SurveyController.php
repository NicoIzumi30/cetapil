<?php

namespace App\Http\Controllers\Web;

use App\Models\SalesSurvey;
use Illuminate\Http\Request;
use App\Exports\SurveyExport;
use App\Models\SalesActivity;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;
use Maatwebsite\Excel\Facades\Excel;

class SurveyController extends Controller
{
    public function index(){
        return view('pages.survey.index');
    } 
    
    public function getData(Request $request)
    {
        $query = SalesActivity::with('outlet', 'user');
        
        if ($request->filled('search_term')) {
            $searchTerm = htmlspecialchars(trim($request->search_term));
            $query->where(function($q) use ($searchTerm) {
                $q->whereHas('outlet', function($q) use ($searchTerm) {
                    $q->where('name', 'like', "%{$searchTerm}%");
                })
                  ->orWhereHas('user', function($q) use ($searchTerm) {
                      $q->where('name', 'like', "%{$searchTerm}%");
                  });
            });
        }
        
        $filteredRecords = (clone $query)->count();
        
        $result = $query->skip($request->start)
                       ->take($request->length)
                       ->get();
        return response()->json([   
            'draw' => intval($request->draw),
            'recordsTotal' => $filteredRecords,
            'recordsFiltered' => $filteredRecords,
            'data' => $result->map(function($item) {
                return [
                    'id' => (int)$item->id,
                    'sales' => htmlspecialchars($item->user->name),
                    'outlet' => htmlspecialchars($item->outlet->name),
                    'visit_day' => htmlspecialchars(getVisitDayByNumber($item->outlet->visit_day)),
                    'checkin' => htmlspecialchars($item->checked_in),
                    'checkout' => htmlspecialchars($item->checked_out),
                    'views' => (int)$item->views_knowledge,
                    'actions' => (view('pages.survey.action', [
                        'surveyId' => $item->id
                    ])->render())
                ];
            })
        ]);
    }
    public function downloadData()
    {
        try {
            $data = SalesActivity::with([
                'user:id,name',
                'outlet:id,name,TSO,code,account,tipe_outlet,channel_id,visit_day',
                'outlet.channel:id,name',
                'surveys.survey'
            ])->where('status','SUBMITTED')->get();
            $filename = 'market_survey_' . date('Y-m-d_His') . '.xlsx';
            return Excel::download(new SurveyExport($data), $filename);
        } catch (\Exception $e) {
            Log::error('Error downloading market survey data: ' . $e->getMessage());
            return response()->json(['error' => 'Failed to download data'], 500);
        }
    }
    public function detail($id)
    {
        $salesActivity = SalesActivity::with(['user:id,name', 'outlet:id,name,visit_day'])->find($id);
        
        // Fetch surveys with related survey question and its category
        $surveys = SalesSurvey::with(['survey.category'])
            ->where('sales_activity_id', $id)
            ->get();
    
        // Group surveys by category name
        $groupedSurveys = $surveys->groupBy(function($item) {
            return $item->survey->category->name ?? 'Uncategorized';
        });
    
        return view('pages.survey.detail', [
            'salesActivity' => $salesActivity,
            'groupedSurveys' => $groupedSurveys
        ]);
    }
}
