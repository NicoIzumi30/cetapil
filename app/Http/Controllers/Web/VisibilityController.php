<?php
namespace App\Http\Controllers\Web;
use App\Http\Controllers\Controller;
use App\Http\Requests\Visibility\CreateVisibilityRequest;
use App\Http\Requests\Visibility\UpdateVisibilityRequest;
use App\Models\City;
use App\Models\Category;
use App\Models\Product;
use App\Models\SalesActivity;
use App\Models\SalesVisibility;
use App\Models\VisualType;
use App\Models\PosmType;
use App\Models\PosmImage;
use App\Models\Visibility;
use App\Models\Outlet;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;
use Carbon\Carbon;




class VisibilityController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $posmTypes = PosmType::orderBy('name')->get();
        
        $posmImages = PosmImage::with('posmType')
            ->get()
            ->map(function($image) {
                return [
                    'posm_type' => $image->posmType->name,
                    'image_url' => asset('storage/' . str_replace('public/', '', $image->path))
                ];
            })
            ->collect();
        
        $visibilitiesQuery = Visibility::with([
            'outlet.user',
            'product',
            'visualType',
            'posmType'  // Add this relation
        ])
        ->whereHas('outlet.user', function($query) {
            $query->role('sales');
        });

        // Apply POSM type filter if selected
        if ($request->filled('posm_type_id')) {
            $visibilitiesQuery->where('posm_type_id', $request->posm_type_id);
        }

        $visibilities = $visibilitiesQuery->latest()->get();

        return view("pages.visibility.index", compact('posmTypes', 'visibilities', 'posmImages'));
    }

    public function getData(Request $request)
    {
        $query = Visibility::with([ 'user:id,name', 'product:id,sku', 'visualType:id,name', 'posmType:id,name', 'outlet:id,name' ])->orderBy('created_at', 'desc');

        if ($request->filled('search_term')) {
            $searchTerm = $request->search_term;
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
            $filter_visibility = $request->filter_visibility;
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
                    'id' => $item->id,
                    'outlet' => $item->outlet->name,
                    'sales' => $item->user->name,
                    'product' => $item->product->sku,
                    'visual' => $item->visualType->name,
                    'status' => $item->status,
                    'periode' =>  Carbon::parse($item->started_at)->format('d F Y')  .' - '. Carbon::parse($item->ended_at)->format('d F Y'),
                    'actions' => view('pages.visibility.action', [
                        'item' => $item,
                        'visibilityId' => $item
                    ])->render()
                ];
            })
        ]);
    }
    public function getDataActivity(Request $request)
    {
        $query = SalesVisibility::with([ 'visibility.outlet','visibility.product','visibility.user','visibility.visualType'])->orderBy('created_at', 'desc');

        if ($request->filled('search_term')) {
            $searchTerm = $request->search_term;
            $query->whereHas('visibility', function($q) use ($searchTerm) {
                $q->whereHas('outlet', function($q) use ($searchTerm) {
                    $q->where('name', 'like', "%{$searchTerm}%");
                })->orWhereHas('product', function($q) use ($searchTerm) {
                    $q->where('sku', 'like', "%{$searchTerm}%");
                })->orWhereHas('user', function($q) use ($searchTerm) {
                    $q->where('name', 'like', "%{$searchTerm}%");
                });
            });
        }
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
                    'outlet' => $item->visibility->outlet->name,
                    'sales' => $item->visibility->user->name,
                    'product' => $item->visibility->product->sku,
                    'visual' => $item->visibility->visualType->name,
                    'condition' => $item->condition,
                    'actions' => view('pages.visibility.action_activity', [
                        'activityId' => $item->id
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

            // Create visibility
            $visibility = Visibility::create($data);

            // Handle file upload if exists
            if ($request->hasFile('filename')) {
                $file = $request->file('filename');
                $media = saveFile($file,"visibility/$visibility->id");

                $data['filename'] = $media['filename'];
                $data['path'] = $media['path'];
            }
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
    public function detail_activity($id){
        $activity = SalesVisibility::with(['visibility', 'visibility.user:id,name', 'visibility.outlet:id,name','visibility.product:id,sku','visibility.visualType:id,name'])->where('id', $id)->first();
        $data = [
            'id' => $activity->id,
            'outlet' => $activity->visibility->outlet->name,
            'sku' => $activity->visibility->product->sku,
            'sales' => $activity->visibility->user->name,
            'visual' => $activity->visibility->visualType->name,
            'periode' => Carbon::parse($activity->visibility->started_at)->format('d-m-Y') .' Sampai '.Carbon::parse($activity->visibility->ended_at)->format('d-m-Y'),
            'condition' => $activity->condition,
            'path1' => $activity->path1,
            'path2' => $activity->path2
        ];
        return view('pages.visibility.visibility-activity', compact('data'));
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
}
