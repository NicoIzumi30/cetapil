<?php

namespace App\Http\Controllers\Web;

use Exception;
use App\Models\City;
use App\Models\User;
use App\Models\Outlet;
use App\Models\Channel;
use App\Models\Product;
use App\Models\Category;
use App\Models\OutletForm;
use App\Models\OutletImage;
use Illuminate\Support\Arr;
use Illuminate\Http\Request;
use App\Models\OutletProduct;
use App\Models\OutletFormAnswer;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use App\Http\Requests\Routing\CreateOutletRequest;

class RoutingController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return view("pages.routing.index");
    }
    public function getData(Request $request)
    {
        $query = Outlet::with('user');
        
        if ($request->filled('search_term')) {
            $searchTerm = $request->search_term;
            $query->where(function($q) use ($searchTerm) {
                $q->where('name', 'like', "%{$searchTerm}%")
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
                    'outlet' => $item->name,
                    'area' => $item->longitude.', '.$item->latitude,
                    'visit_day' => getVisitDayByNumber($item->visit_day),
                    'actions' => view('pages.routing.action', [
                        'item' => $item,
                        'outletId' => $item->id // Pass product id ke view actions
                    ])->render()
                ];
            })
        ]);
    }
    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $salesUsers = User::role('sales')->get();
        $waktuKunjungan = [
            ['name'=> 'Senin', 'value' => 1],
            ['name'=> 'Selasa', 'value' => 2],
            ['name'=> 'Rabu', 'value' => 3],
            ['name'=> 'Kamis', 'value'=> 4],
            ['name'=> 'Jumat', 'value'=> 5],
            ['name'=> 'Sabtu', 'value'=> 6],
            ['name'=> 'Minggu', 'value'=> 7],
        ];
        $cycles = ["1x1", "1x2"];
        $cities = City::all();
        $channels = Channel::all();
        $category_product = Category::all();
        $outletForms = OutletForm::all();
        $categories = Category::with('products')->get();
        $weekType = [
            [

                "name" => "Ganjil",
                "value" => "ODD"
            ],
            [
                "name" => "Genap",
                "value" => "EVEN"
            ]
        ];
        return view("pages.routing.create", [
            "salesUsers" => $salesUsers,
            "waktuKunjungan" => $waktuKunjungan,
            "cycles" => $cycles,
            "cities" => $cities,
            "channels" => $channels,
            "category_product" => $category_product,
            "outletForms" => $outletForms,
            "weekType" => $weekType,
            'categories' => $categories
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(CreateOutletRequest $request)
    {
        try {
            DB::beginTransaction();
            $data = Arr::except($request->validated(), ['city', 'img_front', 'img_banner', 'img_main_road','product_category']);
            $outlet = new Outlet($data);
            $outlet->status = 'APPROVED';
            $outlet->city_id = $request->city;
            $outlet->save();
            $images = ['img_front', 'img_banner', 'img_main_road'];
            foreach ($images as $key => $image) {
                if($request->hasFile($image)) {
                    $file = $request->file($image);
                    $media = saveFile($file, "outlets/$outlet->id");
                    OutletImage::create([
                        'outlet_id' => $outlet->id,
                        'position' => $key + 1,
                        'filename' => $media['filename'],
                        'path' => $media['path']
                    ]);
                }
            }
            foreach($request->product_category as $category){
                $products = Product::where('category_id', $category)->get();
                foreach($products as $product){
                    OutletProduct::create([
                        'outlet_id'=> $outlet->id,
                        'product_id'=> $product->id,
                    ]);
                }
            }
            foreach ($request->survey as $formId => $answer) {
                OutletFormAnswer::create([
                    'outlet_id' => $outlet->id,
                    'outlet_form_id' => $formId,
                    'answer' => $answer,
                ]);
            }
            DB::commit();
            return to_route('routing.index')->with('success','Outlet berhasil ditambahkan');
        } catch (Exception $e) {
            DB::rollBack();
            throw $e;
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        $outlet = Outlet::findOrFail($id);
        $salesUsers = User::role('sales')->get();
        $waktuKunjungan = [
            ['name'=> 'Senin', 'value' => 1],
            ['name'=> 'Selasa', 'value' => 2],
            ['name'=> 'Rabu', 'value' => 3],
            ['name'=> 'Kamis', 'value'=> 4],
            ['name'=> 'Jumat', 'value'=> 5],
            ['name'=> 'Sabtu', 'value'=> 6],
            ['name'=> 'Minggu', 'value'=> 7],
        ];
        $cycles = ["1x1", "1x2"];
        $cities = City::all();
        $channels = Channel::all();
        $category_product = Category::all();
        $outletForms = OutletForm::with(['answers' => function($query) use($id) {
            $query->where('outlet_id', $id);
         }])->get();
        $categories = Category::with(['products' => function($query) use($id) {
            $query->whereHas('outlets', function($q) use($id) {
                $q->where('outlets.id', $id);
            });
         }])->get();
        $weekType = [
            [
                "name" => "Ganjil",
                "value" => "ODD",],
            [
                "name"=> "Genap",
                "value" => "EVEN",
            ]
            ];
            return view("pages.routing.edit", [
                "salesUsers" => $salesUsers,
                "waktuKunjungan" => $waktuKunjungan,
                "cycles" => $cycles,
                "cities" => $cities,
                "channels" => $channels,
                "category_product" => $category_product,
                "outletForms" => $outletForms,
                "weekType" => $weekType,
                'categories' => $categories,
                "outlet" => $outlet
            ]);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $outlet = Outlet::findOrFail($id);
        $outlet->delete();
        return to_route('routing.index')->with('success','Outlet berhasil dihapus');
    }
}
