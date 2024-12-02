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
use App\Exports\OutletExport;
use App\Models\OutletProduct;
use App\Imports\RoutingImport;
use App\Models\OutletFormAnswer;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;
use Maatwebsite\Excel\Facades\Excel;
use App\Http\Requests\Routing\CreateOutletRequest;
use App\Http\Requests\Routing\UpdateOutletRequest;


class RoutingController extends Controller
{
    protected $waktuKunjungan = [
        ['name' => 'Senin', 'value' => 1],
        ['name' => 'Selasa', 'value' => 2],
        ['name' => 'Rabu', 'value' => 3],
        ['name' => 'Kamis', 'value' => 4],
        ['name' => 'Jumat', 'value' => 5],
        ['name' => 'Sabtu', 'value' => 6],
        ['name' => 'Minggu', 'value' => 7],
    ];
    protected $weekType = [
        [
            "name" => "Ganjil",
            "value" => "ODD"
        ],
        [
            "name" => "Genap",
            "value" => "EVEN"
        ]
    ];
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $channels = Channel::all();
        $waktuKunjungan = $this->waktuKunjungan;
        $countPending = Outlet::where('status', 'PENDING')->count();
        return view("pages.routing.index", compact('channels', 'waktuKunjungan','countPending'));
    }
    public function getData(Request $request)
    {
        $query = Outlet::with('user');

        if ($request->filled('search_term')) {
            $searchTerm = $request->search_term;
            $query->where(function ($q) use ($searchTerm) {
                $q->where('name', 'like', "%{$searchTerm}%")
                    ->orWhereHas('user', function ($q) use ($searchTerm) {
                        $q->where('name', 'like', "%{$searchTerm}%");
                    });
            });
        }
        if ($request->filled('filter_day')) {
            $filter_day = $request->filter_day;
            if($filter_day != 'all') {
                $query->where(function ($q) use ($filter_day) {
                    $q->where('visit_day', 'like', "%{$filter_day}%");
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
                return [
                    'id' => $item->id,
                    'sales' => $item->user->name,
                    'outlet' => $item->name,
                    'area' => $item->longitude . ', ' . $item->latitude,
                    'visit_day' => getVisitDayByNumber($item->visit_day),
                    'actions' => view('pages.routing.action', [
                        'item' => $item,
                        'outletId' => $item->id
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
        $waktuKunjungan = $this->waktuKunjungan;
        $cycles = ["1x1", "1x2"];
        $cities = City::all();
        $channels = Channel::all();
        $category_product = Category::all();
        $outletForms = OutletForm::all();
        $categories = Category::with('products')->get();
        $weekType = $this->weekType;
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
            $data = Arr::except($request->validated(), ['city', 'img_front', 'img_banner', 'img_main_road', 'product_category']);
            $outlet = new Outlet($data);
            $outlet->status = 'APPROVED';
            $outlet->city_id = $request->city;
            $outlet->save();
            $images = ['img_front', 'img_banner', 'img_main_road'];
            foreach ($images as $key => $image) {
                if ($request->hasFile($image)) {
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
            foreach ($request->product_category as $category) {
                $products = Product::where('category_id', $category)->get();
                foreach ($products as $product) {
                    OutletProduct::create([
                        'outlet_id' => $outlet->id,
                        'product_id' => $product->id,
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
            return to_route('routing.index')->with('success', 'Outlet berhasil ditambahkan');
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
        $waktuKunjungan = $this->waktuKunjungan;
        $cycles = ["1x1", "1x2"];
        $cities = City::all();
        $channels = Channel::all();
        $category_product = Category::all();
        $outletForms = OutletForm::with([
            'answers' => function ($query) use ($id) {
                $query->where('outlet_id', $id);
            }
        ])->get();
        $categories = Category::with([
            'products' => function ($query) {
                $query->select('products.id', 'products.sku', 'products.category_id');
            },
            'products.outlets' => function ($query) use ($id) {
                $query->where('outlets.id', $id)
                    ->select('outlets.id');
            }
        ])->get();
        $categories->each(function ($category) {
            $category->hasProductInOutlet = $category->products->some(function ($product) {
                return $product->outlets->isNotEmpty();
            });
        });
        $weekType = $this->weekType;
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

    public function request(){
        $outletRequest = Outlet::with('user')->where('status', 'PENDING')->orWhere('status', 'REJECTED')->orderBy('created_at', 'desc')->get();
        return view('pages.routing.request', compact('outletRequest'));
    } 
    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateOutletRequest $request, string $id)
    {
        try {
            DB::beginTransaction();
            $data = Arr::except($request->validated(), ['city', 'img_front', 'img_banner', 'img_main_road', 'product_category']);
            $outlet = Outlet::findOrFail($id);
            $outlet->fill($data);
            $outlet->city_id = $request->city;
            $outlet->save();
            $images = ['img_front', 'img_banner', 'img_main_road'];
            foreach ($images as $key => $image) {
                if ($request->hasFile($image)) {
                    $file = $request->file($image);
                    $media = saveFile($file, "outlets/$outlet->id");
                    // Remove existing file
                    $img = OutletImage::where('outlet_id', $outlet->id)->where('position', $key + 1)->first();
                    if ($img) {
                        removeFile($img->path);
                        $img->filename = $media['filename'];
                        $img->path = $media['path'];
                        $img->save();
                    } else {
                        OutletImage::create([
                            'outlet_id' => $outlet->id,
                            'position' => $key + 1,
                            'filename' => $media['filename'],
                            'path' => $media['path']
                        ]);
                    }
                }
            }

            $validProductIds = Product::whereIn('category_id', $request->product_category)
                ->pluck('id');
            OutletProduct::where('outlet_id', $outlet->id)
                ->whereNotIn('product_id', $validProductIds)
                ->delete();
            $existingProductIds = OutletProduct::where('outlet_id', $outlet->id)
                ->pluck('product_id');
            $newProductIds = $validProductIds->diff($existingProductIds);
            if ($newProductIds->isNotEmpty()) {
                $products = $newProductIds->map(function ($productId) use ($outlet) {
                    OutletProduct::create(attributes: [
                        'outlet_id' => $outlet->id,
                        'product_id' => $productId,
                    ]);
                });
            }
            foreach ($request->survey as $formId => $answer) {
                $data = OutletFormAnswer::where('outlet_id', $outlet->id)->where('outlet_form_id', $formId)->first();
                if ($data) {
                    $data->answer = $answer;
                    $data->save();
                } else {
                    OutletFormAnswer::create([
                        'outlet_id' => $outlet->id,
                        'outlet_form_id' => $formId,
                        'answer' => $answer,
                    ]);
                }
            }
            DB::commit();
            return to_route('routing.index')->with('success', 'Outlet berhasil ditambahkan');
        } catch (Exception $e) {
            DB::rollBack();
            throw $e;
        }
    }

    public function downloadExcel()
    {
        try {
            return Excel::download(new OutletExport(), 'outlet_data_' . now()->format('Y-m-d_His') . '.xlsx', \Maatwebsite\Excel\Excel::XLSX);
        } catch (\Exception $e) {
            Log::error('Excel Download Error', [
                'message' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine()
            ]);

            return response()->json([
                'status' => 'error',
                'message' => 'Gagal membuat file Excel: ' . $e->getMessage()
            ], 500);
        }
    }
    public function bulk(Request $request)
    {
        $request->validate([
            'excel_file' => 'required|mimes:xlsx|max:10240'
        ]);

        try {
            $file = $request->file('excel_file');
            $fileName = $file->getClientOriginalName();
            $import = new RoutingImport($fileName);
            Excel::import($import, $file);

            if ($import->response['status'] == 'error') {
                throw new Exception($import->response['message']);
            }

            return response()->json(['message' => 'Import success'], 200);
        } catch (\Exception $e) {
            return response()->json(['message' => $e->getMessage()], 500);
        }
    }
    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $outlet = Outlet::findOrFail($id);
        $outlet->delete();
        return to_route('routing.index')->with('success', 'Outlet berhasil dihapus');
    }
}
