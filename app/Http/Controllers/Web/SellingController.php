<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;

use App\Models\Selling;
use Carbon\Carbon;
use Illuminate\Http\Request;
use function GuzzleHttp\json_encode;

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
                $totalSelling = $item->products->sum('selling');
                return [
                    'id' => $item->id, // Tambahkan id product
                    'waktu' => Carbon::parse($item->created_at)->format('d-m-Y H:i:s'),
                    'sales' => $item->user->name,
                    'outlet' => $item->outlet_name,
                    'total' => $totalSelling,
                    'actions' => view('pages.selling.action', [
                        'sellingId' => $item->id
                    ])->render()
                ];
            })
        ]);
    }
    public function detail($id){
        $selling = Selling::select([
            'id',
            'user_id',
            'outlet_name',
            'longitude', 
            'latitude'
        ])
        ->with([
            'user:id,name',
            'products:id,selling_id,product_id,stock,selling,balance,price',
            'products.product:id,sku,category_id',
            'products.product.category:id,name'
        ])
        ->where('id', $id)
        ->first();
        
        // Transform dan group data
        $groupedProducts = $selling->products->groupBy(function($sellingProduct) {
            return $sellingProduct->product->category->name;
        })->map(function($products, $categoryName) {
            return [
                'category_name' => $categoryName,
                'products' => $products->map(function($sellingProduct) {
                    return [
                        'id' => $sellingProduct->id,
                        'product_name' => $sellingProduct->product->sku,
                        'stock' => $sellingProduct->stock,
                        'selling' => $sellingProduct->selling,
                        'balance' => $sellingProduct->balance,
                        'price' => $sellingProduct->price
                    ];
                })
            ];
        })->values();
        
        $response = [
            'id' => $selling->id,
            'user_id' => $selling->user_id,
            'outlet_name' => $selling->outlet_name,
            'longitude' => $selling->longitude,
            'latitude' => $selling->latitude,
            'user' => [
                'id' => $selling->user->id,
                'name' => $selling->user->name
            ],
            'products_by_category' => $groupedProducts
        ];
        return view('pages.selling.detail', compact('response'));
    } 
}
