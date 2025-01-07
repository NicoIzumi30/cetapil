<?php

namespace App\Http\Controllers\Web;

use App\Models\OutletRouting;
use Exception;
use Carbon\Carbon;
use App\Models\City;
use App\Models\User;
use App\Models\Outlet;
use App\Models\Channel;
use App\Models\Av3m;
use App\Models\Product;
use App\Models\Category;
use App\Models\OutletForm;
use App\Models\OutletImage;
use Illuminate\Support\Arr;
use Illuminate\Http\Request;
use App\Exports\OutletExport;
use App\Models\OutletProduct;
use App\Models\SalesActivity;
use App\Imports\RoutingImport;
use App\Models\OutletFormAnswer;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Exports\SalesActivityExport;
use App\Http\Controllers\Controller;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\OutletFilteredExport;
use App\Http\Requests\Outlet\CreateOutletRequest;
use App\Http\Requests\Routing\UpdateOutletRequest;
use Illuminate\Support\Str;




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
    protected $weekOptions = [
        '1x4' => [
            ['name' => 'Week 1', 'value' => '1'],
            ['name' => 'Week 2', 'value' => '2'],
            ['name' => 'Week 3', 'value' => '3'],
            ['name' => 'Week 4', 'value' => '4']
        ],
        '1x2' => [
            ['name' => 'Week 1 & 3', 'value' => '13'],
            ['name' => 'Week 2 & 4', 'value' => '24']
        ]
    ];
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $channels = Channel::all();
        $waktuKunjungan = $this->waktuKunjungan;
        $cities = City::all();
        $countPending = Outlet::where('status', 'PENDING')->count();

        return view("pages.routing.index", compact('channels', 'waktuKunjungan','countPending', 'cities'));
    }
    public function getData(Request $request)
    {
        $query = Outlet::with('user');

        if ($request->filled('search_term')) {
            $searchTerm = trim($request->search_term);
            $query->where('name', 'like', "%{$searchTerm}%");
            $query->orWhere('code', 'like', "%{$searchTerm}%");
            $query->orWhereHas('user', function ($q) use ($searchTerm) {
                $q->where('name', 'like', "%{$searchTerm}%");
            });
        }
        
        if ($request->filled('filter_day')) {
            $filter_day = $request->filter_day;
            if ($filter_day != 'all') {
                $query->whereHas('outletRoutings', function ($q) use ($filter_day) {
                    $q->where('visit_day', $filter_day);
                });
            }
        }
        $query->where('status','APPROVED');
        $query->orderBy('created_at', 'desc');
        $filteredRecords = (clone $query)->count();

        $result = $query->skip($request->start)
            ->take($request->length)
            ->get();

        return response()->json([
            'draw' => intval($request->draw),
            'recordsTotal' => $filteredRecords,
            'recordsFiltered' => $filteredRecords,
            'data' => $result->map(function ($item) {
                $visitDays = getVisitDays($item->id);
                $visitWeeks = getWeeks($item->id);
                return [
                    'id' => $item->id,
                    'sales' => $item->user->name,
                    'outlet' => $item->name,
                    'code' => $item->code,
                    'area' => $item->longitude ? $item->longitude . ', ' . $item->latitude :'',
                    'visit_day' => $visitDays,
                    'visit_week' => $visitWeeks,
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
        $cycles = ["1x1", "1x2", "1x4"];
        $cities = City::all();
        $channels = Channel::all();
        $category_product = Category::all();
        $outletForms = OutletForm::all();
        $categories = Category::with('products')->get();
        $weekType = $this->weekOptions;
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

            // Create outlet
            $outlet = new Outlet();
            $outlet->status = 'APPROVED';
            $outlet->user_id = $request->user_id;
            $outlet->city_id = $request->city;
            $outlet->channel_id = $request->channel;
            $outlet->code = $request->code;
            $outlet->name = $request->name;
            $outlet->category = $request->category;
            $outlet->visit_day = $request->visit_day;
            $outlet->longitude = $request->longitude;
            $outlet->latitude = $request->latitude;
            $outlet->address = $request->address;
            $outlet->cycle = $request->cycle;
            $outlet->tipe_outlet = $request->outlet_type;
            $outlet->account = $request->account_type;

            if (in_array($request->cycle, ['1x2', '1x4'])) {
                if (empty($request->week)) {
                    throw new Exception('Week is required when cycle is 1x2 or 1x4');
                }
                $outlet->week = $request->cycle === '1x2' ?
                    ($request->week === '13' ? '1&3' : '2&4') :
                    $request->week;
            }

            $outlet->save();


            // Store AV3M data
            foreach ($request->product_category as $category) {
                $products = Product::where('category_id', $category)->get();
                foreach ($products as $product) {
                    // Create AV3M record
                    Av3m::create([
                        'id' => Str::uuid(),
                        'outlet_id' => $outlet->id,
                        'product_id' => $product->id,
                        'av3m' => $request->av3m[$product->sku] ?? 0,
                    ]);

                    // Create outlet product relationship
                    OutletProduct::create([
                        'outlet_id' => $outlet->id,
                        'product_id' => $product->id,
                    ]);
                }
            }

            // Handle images
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

            // Store survey answers
            foreach ($request->survey as $formId => $answer) {
                OutletFormAnswer::create([
                    'outlet_id' => $outlet->id,
                    'outlet_form_id' => $formId,
                    'answer' => $answer,
                ]);
            }

            DB::commit();

            // Return success response for Ajax
            return response()->json([
                'status' => 'success',
                'message' => 'Outlet berhasil ditambahkan'
            ]);
        } catch (Exception $e) {
            DB::rollBack();
            // Return error response for Ajax
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal menambahkan outlet: ' . $e->getMessage()
            ], 422);
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
        $cycles = ["1x1", "1x2", "1x4"];
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
        $weekType = $this->weekOptions;
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

    public function request()
    {
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

            $outlet = Outlet::findOrFail($id);
            $outlet->user_id = $request->user_id;
            $outlet->city_id = $request->city;
            $outlet->channel_id = $request->channel;
            $outlet->code = $request->code;
            $outlet->name = $request->name;
            $outlet->category = $request->category;
            $outlet->visit_day = $request->visit_day;
            $outlet->longitude = $request->longitude;
            $outlet->latitude = $request->latitude;
            $outlet->address = $request->address;
            $outlet->cycle = $request->cycle;
            $outlet->tipe_outlet = $request->outlet_type;
            $outlet->account = $request->account_type;

            if (in_array($request->cycle, ['1x2', '1x4'])) {
                if (empty($request->week)) {
                    throw new Exception('Week is required when cycle is 1x2 or 1x4');
                }
                $outlet->week = $request->cycle === '1x2' ?
                    ($request->week === '13' ? '1&3' : '2&4') :
                    $request->week;
            }

            $outlet->save();

            // Update AV3M data
            if ($request->product_category) {
                // Delete existing AV3M records
                Av3m::where('outlet_id', $outlet->id)->delete();

                // Create new AV3M records
                foreach ($request->product_category as $category) {
                    $products = Product::where('category_id', $category)->get();
                    foreach ($products as $product) {
                        Av3m::create([
                            'id' => Str::uuid(),
                            'outlet_id' => $outlet->id,
                            'product_id' => $product->id,
                            'av3m' => $request->av3m[$product->sku] ?? 0,
                        ]);
                    }
                }
            }

            // Update outlet products
            if ($request->product_category) {
                OutletProduct::where('outlet_id', $outlet->id)->delete();
                foreach ($request->product_category as $category) {
                    $products = Product::where('category_id', $category)->get();
                    foreach ($products as $product) {
                        OutletProduct::create([
                            'outlet_id' => $outlet->id,
                            'product_id' => $product->id,
                        ]);
                    }
                }
            }

            // Handle images
            $images = ['img_front', 'img_banner', 'img_main_road'];
            foreach ($images as $key => $image) {
                if ($request->hasFile($image)) {
                    $file = $request->file($image);
                    $media = saveFile($file, "outlets/$outlet->id");

                    // Update or create image record
                    $imageRecord = OutletImage::where('outlet_id', $outlet->id)
                        ->where('position', $key + 1)
                        ->first();

                    if ($imageRecord) {
                        removeFile($imageRecord->path);
                        $imageRecord->update([
                            'filename' => $media['filename'],
                            'path' => $media['path']
                        ]);
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

            // Update survey answers
            if ($request->survey) {
                foreach ($request->survey as $formId => $answer) {
                    OutletFormAnswer::updateOrCreate(
                        [
                            'outlet_id' => $outlet->id,
                            'outlet_form_id' => $formId
                        ],
                        ['answer' => $answer]
                    );
                }
            }

            DB::commit();

            return response()->json([
                'status' => 'success',
                'message' => 'Outlet berhasil diperbarui'
            ]);
        } catch (Exception $e) {
            DB::rollBack();
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal memperbarui outlet: ' . $e->getMessage()
            ], 422);
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
        try {
            DB::beginTransaction();

            // Hapus data terkait terlebih dahulu
            OutletProduct::where('outlet_id', $id)->delete();
            OutletFormAnswer::where('outlet_id', $id)->delete();
            OutletImage::where('outlet_id', $id)->delete();

            // Kemudian hapus outlet
            $outlet = Outlet::findOrFail($id);
            $outlet->delete();

            DB::commit();
            return response()->json([
                'status' => 'success',
                'message' => 'Outlet berhasil dihapus'
            ]);
        } catch (Exception $e) {
            DB::rollBack();
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal menghapus outlet: ' . $e->getMessage()
            ], 500);
        }
    }
    public function salesActivity($id)
    {
        return view('pages.routing.sales-activity', compact('id'));
    }


    public function downloadFilteredExcel(Request $request)
    {
        try {
            $query = Outlet::with(['user', 'city', 'channel']);


            // Apply search filter
            if ($request->filled('search_term')) {
                $searchTerm = $request->search_term;
                $query->where(function ($q) use ($searchTerm) {
                    $q->where('name', 'like', "%{$searchTerm}%")
                        ->orWhereHas('user', function ($q) use ($searchTerm) {
                            $q->where('name', 'like', "%{$searchTerm}%");
                        });
                });
            }

            // Apply day filter

            if ($request->filter_day != null && $request->filter_day != "null" && $request->filled('filter_day') && $request->filter_day != 'all') {
                $query->where('visit_day', $request->filter_day);
            }
            $data = $query->get();

            return Excel::download(
                new OutletFilteredExport($data),
                'routing_data_' . now()->format('Y-m-d_His') . '.xlsx'
            );
        } catch (\Exception $e) {
            Log::error('Routing Excel Download Error', [
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
    public function downloadSalesActivityExcel(Request $request)
    {
        try {
            DB::enableQueryLog();
            $query = SalesActivity::with([
                'outlet' => function ($q) {
                    $q->select('id', 'name', 'visit_day', 'city_id');
                },
                'user' => function ($q) {
                    $q->select('id', 'name');
                }
            ]); // Make sure to only get non-deleted records
            $query->where('status', 'SUBMITTED');
            // Apply day filter
            if ($request->filled('filter_day_sales') && $request->filter_day_sales != 'all' && $request->filter_day_sales != 'null') {
                $query->whereHas('outlet', callback: function ($q) use ($request) {
                    $q->where('visit_day', $request->filter_day_sales);
                });
            }

            // Apply area filter
            if ($request->filled('filter_area') && $request->filter_area != 'all' && $request->filter_area != 'null') {
                $query->whereHas('outlet', function ($q) use ($request) {
                    $q->where('city_id', $request->filter_area);
                });
            }

            // Apply date filter
            if ($request->filled('date') && $request->date !== 'Date Range') {
                $dateRange = explode(' to ', $request->date);
                if (count($dateRange) == 2) {
                    $query->whereBetween('checked_in', [
                        Carbon::parse($dateRange[0])->startOfDay(),
                        Carbon::parse($dateRange[1])->endOfDay()
                    ]);
                } else {
                    $query->whereDate('checked_in', Carbon::parse($request->date));
                }
            }

            // Apply search term
            if ($request->filled('search_term')) {
                $searchTerm = $request->search_term;
                $query->where(function ($q) use ($searchTerm) {
                    $q->whereHas('user', function ($q) use ($searchTerm) {
                        $q->where('name', 'like', "%{$searchTerm}%");
                    })
                        ->orWhereHas('outlet', function ($q) use ($searchTerm) {
                            $q->where('name', 'like', "%{$searchTerm}%");
                        });
                });
            }

            // Log query information
            Log::info('Download Query Parameters:', [
                'filters' => $request->all(),
                'sql' => $query->toSql(),
                'bindings' => $query->getBindings()
            ]);

            // Get data
            $data = $query->get();
            // Log retrieved data
            Log::info('Downloaded Data:', [
                'count' => $data->count(),
                'first_record' => $data->first()
            ]);

            // Generate filename with timestamp
            $filename = 'sales_activity_' . now()->format('Y-m-d_His') . '.xlsx';

            // Return Excel download
            return Excel::download(
                new SalesActivityExport($data),
                $filename,
                \Maatwebsite\Excel\Excel::XLSX
            );
        } catch (\Exception $e) {
            Log::error('Download Error:', [
                'message' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengunduh file: ' . $e->getMessage()
            ], 500);
        }
    }
}
