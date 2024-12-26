<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Models\SalesActivity;
use Illuminate\Http\Request;

class SurveyController extends Controller
{
    public function index(){
        return view('pages.survey.index');
    } 
    
    public function getData(Request $request)
    {
        $query = SalesActivity::with('outlet', 'user');
        
        if ($request->filled('search_term')) {
            $searchTerm = $request->search_term;
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
                    'id' => $item->id, // Tambahkan id product
                    'sales' => $item->user->name,
                    'outlet' => $item->outlet->name,
                    'visit_day' => getVisitDayByNumber($item->outlet->visit_day),
                    'checkin' => $item->checked_in,
                    'checkout' => $item->checked_out,
                    'views' => $item->views_knowledge,
                    'actions' => view('pages.survey.action', [
                        'surveyId' => $item->id
                    ])->render()
                ];
            })
        ]);
    }
    public function detail($id){
        $salesActivity = SalesActivity::with(['user:id,name', 'outlet:id,name,visit_day'])->find($id);
        return view('pages.survey.detail', [
            'salesActivity' => $salesActivity,
        ]);
    }
}
