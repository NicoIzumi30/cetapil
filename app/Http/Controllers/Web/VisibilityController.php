<?php

namespace App\Http\Controllers\Web;

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Http\Requests\Visibility\CreateVisibilityRequest;
use App\Http\Requests\Visibility\UpdateVisibilityRequest;
use App\Models\City;
use App\Models\Category;
use App\Models\Product;
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
