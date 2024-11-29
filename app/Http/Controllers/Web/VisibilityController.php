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
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;



class VisibilityController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $salesUsers = User::role('sales')
            ->orderBy('name')
            ->get();

        $query = Visibility::with(['outlet.user', 'product', 'visualType'])
            ->whereHas('outlet.user', function($query) {
                $query->role('sales');
            });

        // Apply sales filter if selected
        if ($request->filled('sales_id')) {
            $query->whereHas('outlet.user', function($q) use ($request) {
                $q->where('id', $request->sales_id);
            });
        }

        $visibilities = $query->latest()->get();
        return view("pages.visibility.index", compact('visibilities', 'salesUsers'));
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

            // Handle file upload if exists
            if ($request->hasFile('filename')) {
                $file = $request->file('filename');
                $filename = time() . '_' . $file->getClientOriginalName();
                $file->move(public_path('banners'), $filename);

                $data['filename'] = $filename;
                $data['path'] = '/banners/' . $filename;
            }

            // Create visibility
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
        if ($request->hasFile('banner')) {
            // Delete old banner
            if ($visibility->filename) {
                $oldFilePath = public_path('banners/' . $visibility->filename);
                if (file_exists($oldFilePath)) {
                    unlink($oldFilePath);
                }
            }

            $file = $request->file('banner');
            $filename = time() . '_' . $file->getClientOriginalName();
            $file->move(public_path('banners'), $filename);
            
            $data['filename'] = $filename;
            $data['path'] = '/banners/' . $filename;
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
