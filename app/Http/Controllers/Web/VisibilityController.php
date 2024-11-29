<?php

namespace App\Http\Controllers\Web;

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Http\Requests\Visibility\CreateVisibilityRequest;
use App\Http\Requests\Visibility\UpdateVisibilityRequest;
use App\Models\City;
use App\Models\User;
use App\Models\Category;
use App\Models\Product;
use App\Models\VisualType;
use App\Models\PosmType;
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
    public function index()
    {
        $posmTypes = PosmType::orderBy('name')->get();
        
        // Add this query to get visibilities data
        $visibilities = Visibility::with([
            'outlet.user',
            'product',
            'visualType'
        ])
        ->whereHas('outlet.user', function($query) {
            $query->role('sales');
        })
        ->latest()
        ->get();

        return view("pages.visibility.index", compact('posmTypes', 'visibilities'));

    }

    public function getData(Request $request)
    {
        $query = Visibility::with([
            'outlet.user', 
            'product', 
            'visualType',
            'city',
            'posmType'
        ])->whereHas('outlet.user', function($query) {
            $query->role('sales');
        });
    
        // Apply POSM type filter if selected
        if ($request->filled('posm_type_id')) {
            $query->where('posm_type_id', $request->posm_type_id);
        }
    
        // Apply search if exists
        if ($request->filled('search_term')) {
            $searchTerm = $request->search_term;
            $query->where(function($q) use ($searchTerm) {
                $q->whereHas('outlet', function($q) use ($searchTerm) {
                    $q->where('name', 'like', "%{$searchTerm}%");
                })
                ->orWhereHas('outlet.user', function($q) use ($searchTerm) {
                    $q->where('name', 'like', "%{$searchTerm}%");
                })
                ->orWhereHas('product', function($q) use ($searchTerm) {
                    $q->where('sku', 'like', "%{$searchTerm}%");
                })
                ->orWhereHas('visualType', function($q) use ($searchTerm) {
                    $q->where('name', 'like', "%{$searchTerm}%");
                });
            });
        }
    
        $filteredRecords = (clone $query)->count();
    
        $result = $query->skip($request->start)
                        ->take($request->length)
                        ->latest()
                        ->get();
    
        return response()->json([
            'draw' => intval($request->draw),
            'recordsTotal' => $filteredRecords,
            'recordsFiltered' => $filteredRecords,
            'data' => $result->map(function($item) {
                return [
                    'id' => $item->id,
                    'name' => $item->outlet->name ?? '-',
                    'name' => $item->outlet->user->name ?? '-',
                    'sku' => $item->product->sku ?? '-',
                    'name' => $item->visualType->name ?? '-',
                    'status' => $item->status,
                    'started_at' => $item->started_at,
                    'ended_at' => $item->ended_at
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


    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        try {
            $visibility = Visibility::findOrFail($id);

            // Delete banner file if exists
            if ($visibility->filename) {
                $filepath = public_path('banners/' . $visibility->filename);
                if (file_exists($filepath)) {
                    unlink($filepath);
                }
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
