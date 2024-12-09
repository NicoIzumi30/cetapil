<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;

use App\Models\Selling;
use Carbon\Carbon;
use Illuminate\Http\Request;

class SellingController extends Controller
{

    public function index(){
        return view('pages.selling.index');
    } 
    public function getData(Request $request)
    {
        $query = Selling::with('user');
        
        if ($request->filled('search_term')) {
            $searchTerm = $request->search_term;
            $query->where(function($q) use ($searchTerm) {
                $q->where('outlet_name', 'like', "%{$searchTerm}%")
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
                    'waktu' => Carbon::parse($item->created_at)->format('d-m-Y H:i:s'),
                    'sales' => $item->user->name,
                    'outlet' => $item->outlet_name,
                    'actions' => view('pages.selling.action', [
                        'sellingId' => $item->id
                    ])->render()
                ];
            })
        ]);
    }
}
