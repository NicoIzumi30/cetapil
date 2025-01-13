<?php

namespace App\Http\Controllers\Web;

use App\Models\Province;
use Carbon\Carbon;
use App\Models\City;
use App\Models\Outlet;
use App\Models\Channel;
use App\Models\Product;
use App\Models\Category;
use App\Models\PosmType;
use App\Models\Visibility;
use App\Models\VisualType;
use Illuminate\Http\Request;
use App\Models\SalesActivity;
use App\Models\SalesVisibility;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\VisibilityActivityExport;
use App\Http\Requests\Visibility\CreateVisibilityRequest;
use App\Http\Requests\Visibility\UpdateVisibilityRequest;

class VisibilityController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $channels = Channel::all();
        $provinces = Province::all();
        return view("pages.visibility.index",compact('channels','provinces') );
    }

    public function getData(Request $request)
    {
        $query = Visibility::with(['user:id,name', 'product:id,sku', 'visualType:id,name', 'posmType:id,name', 'outlet:id,name'])
            ->orderBy('created_at', 'desc');
    
        if ($request->filled('search_term')) {
            $searchTerm = htmlspecialchars(trim($request->search_term));
            $query->where(function ($q) use ($searchTerm) {
                $q->WhereHas('outlet', function ($q) use ($searchTerm) {
                    $q->where('name', 'like', "%{$searchTerm}%");
                })->orWhereHas('product', function ($q) use ($searchTerm) {
                    $q->where('sku', 'like', "%{$searchTerm}%");
                })->orWhereHas('user', function ($q) use ($searchTerm) {
                    $q->where('name', 'like', "%{$searchTerm}%");
                })->orWhereHas('visualType', function ($q) use ($searchTerm) {
                    $q->where('name', 'like', "%{$searchTerm}%");
                });
            });
        }
    
        if ($request->filled('filter_visibility')) {
            $filter_visibility = htmlspecialchars($request->filter_visibility);
            if ($filter_visibility != 'all') {
                $query->where('posm_type_id', $filter_visibility);
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
                    'id' => (int)$item->id,
                    'outlet' => htmlspecialchars($item->outlet->name),
                    'sales' => htmlspecialchars($item->user->name),
                    'product' => htmlspecialchars($item->product->sku),
                    'visual' => htmlspecialchars($item->visualType->name),
                    'status' => htmlspecialchars($item->status),
                    'periode' => htmlspecialchars(Carbon::parse($item->started_at)->format('d F Y') . ' - ' . Carbon::parse($item->ended_at)->format('d F Y')),
                    'actions' => (view('pages.visibility.action', [
                        'item' => $item,
                        'visibilityId' => $item
                    ])->render())
                ];
            })
        ]);
    }
    public function getDataActivity(Request $request) {

        $query = SalesActivity::with(['user:id,name', 'outlet:id,name,tipe_outlet,code,channel_id','outlet.channel:id,name'])->orderBy('created_at', 'desc');
    
        if ($request->filled('search_term')) {
            $searchTerm = $request->search_term;
            $query->where(function ($q) use ($searchTerm) {
                $q->WhereHas('outlet', function ($q) use ($searchTerm) {
                    $q->where('name', 'like', "%{$searchTerm}%");
                })->orWhereHas('user', function ($q) use ($searchTerm) {
                    $q->where('name', 'like', "%{$searchTerm}%");
                });
            });
        }
    
        // Date filter
        if ($request->filled('date')) {
            $dateParam = $request->date;
            
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
                    'outlet' => $item->outlet->name,
                    'sales' => $item->user->name,
                    'code' => $item->outlet->code,
                    'type' => $item->outlet->tipe_outlet,
                    'channel' => $item->outlet->channel->name,
                    'actions' => view('pages.visibility.action_activity', [
                        'activityId' => $item->id
                    ])->render()
                ];
            })
        ]);
    } 

    // public function getDataActivity(Request $request)
    // {
    //     try {
    //         // 1. Create a subquery to get the latest record for each sales_activity_id
    //         $latestRecords = DB::table('sales_visibilities')
    //             ->select('sales_activity_id', DB::raw('MAX(id) as max_id'))
    //             ->whereNull('deleted_at')
    //             ->groupBy('sales_activity_id');
    
    //         // 2. Main query using join with the subquery
    //         $query = SalesVisibility::select('sales_visibilities.*')
    //             ->joinSub($latestRecords, 'latest_records', function ($join) {
    //                 $join->on('sales_visibilities.id', '=', 'latest_records.max_id');
    //             })
    //             ->with([
    //                 'salesActivity' => function ($q) {
    //                     $q->select('id', 'user_id', 'outlet_id');
    //                 },
    //                 'salesActivity.outlet' => function ($q) {
    //                     $q->select('id', 'name', 'code', 'tipe_outlet', 'channel_id');
    //                 },
    //                 'salesActivity.outlet.channel' => function ($q) {
    //                     $q->select('id', 'name');
    //                 },
    //                 'salesActivity.user' => function ($q) {
    //                     $q->select('id', 'name');
    //                 }
    //             ]);
    
    //         // 3. Apply search filter if exists
    //         if ($request->filled('search_term')) {
    //             $searchTerm = $request->search_term;
    //             $query->where(function ($query) use ($searchTerm) {
    //                 $query->whereHas('salesActivity.outlet', function ($q) use ($searchTerm) {
    //                     $q->where(function ($subQ) use ($searchTerm) {
    //                         $subQ->where('name', 'like', "%{$searchTerm}%")
    //                             ->orWhere('code', 'like', "%{$searchTerm}%")
    //                             ->orWhere('tipe_outlet', 'like', "%{$searchTerm}%");
    //                     });
    //                 })->orWhereHas('salesActivity.user', function ($q) use ($searchTerm) {
    //                     $q->where('name', 'like', "%{$searchTerm}%");
    //                 });
    //             });
    //         }
    
    //         // 4. Apply date filter if exists
    //         if ($request->filled('date')) {
    //             $dateParam = $request->date;
    //             if (str_contains($dateParam, ' to ')) {
    //                 [$startDate, $endDate] = explode(' to ', $dateParam);
    //                 $query->whereBetween('sales_visibilities.created_at', [
    //                     Carbon::parse($startDate)->startOfDay(),
    //                     Carbon::parse($endDate)->endOfDay()
    //                 ]);
    //             } else {
    //                 $query->whereDate('sales_visibilities.created_at', Carbon::parse($dateParam));
    //             }
    //         }
    
    //         // 5. Count total filtered records
    //         $filteredRecords = $query->count();
    
    //         // 6. Get paginated results
    //         $result = $query->orderBy('sales_visibilities.created_at', 'desc')
    //             ->skip($request->start)
    //             ->take($request->length)
    //             ->get();
    
    //         // 7. Transform data with chunking for memory efficiency
    //         $transformedData = collect();
    //         foreach ($result->chunk(100) as $chunk) {
    //             $transformedData = $transformedData->concat($chunk->map(function ($item) {
    //                 return [
    //                     'id' => $item->id,
    //                     'outlet' => $item->salesActivity->outlet->name,
    //                     'sales' => $item->salesActivity->user->name,
    //                     'code' => $item->salesActivity->outlet->code,
    //                     'type' => $item->salesActivity->outlet->tipe_outlet,
    //                     'condition' => $item->condition,
    //                     'channel' => $item->salesActivity->outlet->channel->name,
    //                     'actions' => view('pages.visibility.action_activity', [
    //                         'activityId' => $item->salesActivity->id
    //                     ])->render()
    //                 ];
    //             }));
    //         }
    
    //         return response()->json([
    //             'draw' => intval($request->draw),
    //             'recordsTotal' => $filteredRecords,
    //             'recordsFiltered' => $filteredRecords,
    //             'data' => $transformedData
    //         ]);
    
    //     } catch (\Exception $e) {
    //         \Log::error('Error in getDataActivity: ' . $e->getMessage());
    //         return response()->json([
    //             'error' => 'An error occurred while processing your request.'
    //         ], 500);
    //     }
    // }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $cities = City::orderBy('name')->get();
        $categories = Category::orderBy('name')->get();
        $products = Product::orderBy('sku')->get();
        $visualTypes = VisualType::all();
        $posmTypes = PosmType::all();
        // Load outlet with user relation
        $outlets = Outlet::with('user')
            ->where('status', 'APPROVED')
            ->orderBy('name')
            ->get();

        return view("pages.visibility.create", compact(
            'cities',
            'categories',
            'products',
            'visualTypes',
            'posmTypes',
            'outlets'
        ));
    }


    /**
     * Store a newly created resource in storage.
     */
    public function store(CreateVisibilityRequest $request)
    {
        DB::beginTransaction();
        try {
            // Get validated data
            $data = $request->validated();

            // Get user_id from outlet
            $outlet = Outlet::findOrFail($data['outlet_id']);
            $data['user_id'] = $outlet->user_id;

            // Handle file upload first
            if ($request->hasFile('filename')) {
                $file = $request->file('filename');
                $media = saveFile($file, "visibility"); // Remove the ID since record isn't created yet

                // Add file data to visibility data
                $data['filename'] = $media['filename'];
                $data['path'] = $media['path'];
            }

            // Create visibility with all data including file info
            $visibility = Visibility::create($data);

            DB::commit();

            return response()->json([
                'status' => 'success',
                'message' => 'Data visibility berhasil ditambahkan',
                'data' => $visibility->load(['city', 'outlet', 'product'])
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'status' => 'error',
                'message' => 'Terjadi kesalahan saat menyimpan data',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function getProducts($categoryId)
    {
        $products = Product::where('category_id', $categoryId)->get();
        return response()->json($products);
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
        $visibility = Visibility::with(['outlet', 'city', 'product.category', 'visualType', 'posmType'])
            ->findOrFail($id);

        $visualTypes = VisualType::all();
        $products = Product::all();

        $cities = City::orderBy('name')->get();
        $categories = Category::orderBy('name')->get();
        $products = Product::orderBy('sku')->get();
        $visualTypes = VisualType::all();
        $posmTypes = PosmType::all();
        $outlets = Outlet::where('status', 'APPROVED')
            ->orderBy('name')
            ->get();

        return view("pages.visibility.edit", compact(
            'visibility',
            'cities',
            'categories',
            'products',
            'visualTypes',
            'posmTypes',
            'outlets'
        ));
    }

    public function update(UpdateVisibilityRequest $request, string $id)
    {
        DB::beginTransaction();
        try {
            $visibility = Visibility::findOrFail($id);
            $data = $request->validated();

            // Handle file upload if exists
            if ($request->hasFile('filename')) {
                // Remove old file if exists
                if ($visibility->filename) {
                    removeFile($visibility->path);
                }

                $file = $request->file('filename');
                $media = saveFile($file, "visibility/{$visibility->id}");

                $data['filename'] = $media['filename'];
                $data['path'] = $media['path'];
            }

            $visibility->update($data);

            DB::commit();

            return response()->json([
                'status' => 'success',
                'message' => 'Data visibility berhasil diperbarui'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error updating visibility: ' . $e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Terjadi kesalahan saat memperbarui data'
            ], 500);
        }
    }
    public function detail_activity($id)
    {
        $salesActivity = SalesActivity::with(['user:id,name', 'outlet:id,name,code,tipe_outlet', 'outlet.channel:id,name'])->find($id);
        $salesVisibility = SalesVisibility::with(['posmType'])->where('sales_activity_id', $id)->get();
        return view('pages.visibility.visibility-activity', compact('salesActivity', 'salesVisibility'));
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        try {
            $visibility = Visibility::findOrFail($id);

            // Delete file if exists
            if ($visibility->path) {
                removeFile($visibility->path);
            }

            $visibility->delete();

            return response()->json([
                'status' => 'success',
                'message' => 'Data visibility berhasil dihapus'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal menghapus data',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    public function downloadActivityData(Request $request)
    {
        try {
            $query = SalesActivity::select('id', 'checked_in', 'checked_out', 'status', 'user_id', 'outlet_id','created_at')->with([
                'outlet:id,name,code,tipe_outlet,account,channel_id,city_id',
                'user:id,name',
                'salesVisibilities:*',
                'salesVisibilities.posmType', 
            ]);
            $query->where('status', 'SUBMITTED');
            // Apply date filter
            if ($request->filled('date') && $request->date !== 'Date Range') {
                $dateParam = $request->date;
                if (str_contains($dateParam, ' to ')) {
                    [$startDate, $endDate] = explode(' to ', $dateParam);
                    $query->whereBetween('checked_in', [
                        Carbon::parse($startDate)->startOfDay(),
                        Carbon::parse($endDate)->endOfDay()
                    ]);
                } else {
                    $query->whereDate('checked_in', Carbon::parse($dateParam));
                }
            }
            $query->orderBy('checked_in', 'desc');
            return Excel::download(
                new VisibilityActivityExport($query),
                'sales_activity_' . now()->format('Y-m-d_His') . '.xlsx'
            );
        } catch (\Exception $e) {
            // Log::error('Activity Download Error', [
            //     'message' => $e->getMessage(),
            //     'file' => $e->getFile(),
            //     'line' => $e->getLine(),
            //     'filters' => $request->all()
            // ]);
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal membuat file Excel: ' . $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e,
            ], 500);
        }
    }
}
