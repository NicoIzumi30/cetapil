<?php

namespace App\Http\Controllers\Web;

use Carbon\Carbon;

use App\Models\Selling;
use Illuminate\Http\Request;
use App\Exports\SellingExport;
use App\Models\SellingProduct;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;
use function GuzzleHttp\json_encode;
use Maatwebsite\Excel\Facades\Excel;

class SellingController extends Controller
{

    public function index(){
        return view('pages.selling.index');
    } 
    
    public function getData(Request $request)
    {
        $query = Selling::with('user');
        
        if ($request->filled('search_term')) {
            $searchTerm = htmlspecialchars(trim($request->search_term));
            $query->where(function($q) use ($searchTerm) {
                $q->WhereHas('user', function($q) use ($searchTerm) {
                      $q->where('name', 'like', "%{$searchTerm}%");
                  })
                  ->orWhereHas('outlet', function($q) use ($searchTerm) {
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
                $totalSelling = SellingProduct::where('selling_id', $item->id)->sum('total');
                return [
                    'id' => (int)$item->id,
                    'waktu' => htmlspecialchars(Carbon::parse($item->created_at)->format('d-m-Y H:i:s')),
                    'sales' => htmlspecialchars($item->user->name),
                    'outlet' => htmlspecialchars($item->outlet->name),
                    'total' => htmlspecialchars(number_format($totalSelling, 0, ',', '.')),
                    'actions' => (view('pages.selling.action', [
                        'sellingId' => $item->id
                    ])->render())
                ];
            })
        ]);
    }
    public function detail($id){
        $selling = Selling::with('user:id,name', 'products', 'outlet:id,name,TSO,account,channel_id,city_id,tipe_outlet,code', 'outlet.channel:id,name', 'outlet.city:id,name')->where('id', $id)->first();
        $groupedProducts = $selling->products->groupBy(function($sellingProduct) {
            return $sellingProduct->product->category->name;
        })->map(function($products, $categoryName) {
            return [
                'category_name' => $categoryName,
                'products' => $products->map(function($sellingProduct) {
                    return [
                        'id' => $sellingProduct->id,
                        'product_name' => $sellingProduct->product->sku,
                        'qty' => $sellingProduct->qty,
                        'price' => $sellingProduct->price,
                        'total' => $sellingProduct->total
                    ];
                })
            ];
        })->values();
        return view('pages.selling.detail',compact('selling','groupedProducts'));
    } 
    public function detailo($id){
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
            'outlet_name' => $selling->outlet->name,
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

    public function downloadData()
    {
        try {
            $filename = 'selling_data_' . date('Y-m-d_His') . '.xlsx';
            return Excel::download(new SellingExport, $filename);
        } catch (\Exception $e) {
            Log::error('Error downloading selling data: ' . $e->getMessage());
            return response()->json(['error' => 'Failed to download data'], 500);
        }
    }

 
}
