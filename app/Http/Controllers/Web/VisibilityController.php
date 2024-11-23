<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\City;
use App\Models\Category;
use App\Models\Product;
use App\Models\VisualType;
use App\Models\PosmType;
use App\Models\Visibility;
use Illuminate\Support\Facades\Validator;

class VisibilityController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return view("pages.visibility.index");
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $cities = City::all();
        $categories = Category::all();
        $products = Product::all();
        $visualTypes = VisualType::all();
        $posmTypes = PosmType::all();

        return view("pages.visibility.create", compact('cities', 'categories', 'products', 'visualTypes', 'posmTypes'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'city_id' => 'required|exists:cities,id',
                'outlet_name' => 'required|string|max:255',
                'category_id' => 'required|exists:categories,id',
                'product_id' => 'required|exists:products,id',
                'program_date' => 'required|date_format:Y-m-d',
                'visual_type_id' => 'required|exists:visual_types,id',
                'posm_type_id' => 'required|exists:posm_types,id',
                'banner_image' => 'required|image|mimes:jpeg,png,jpg|max:5120'
            ], [
                'city_id.required' => 'Kabupaten/Kota harus dipilih',
                'outlet_name.required' => 'Nama Outlet harus diisi',
                'category_id.required' => 'Kategori Produk harus dipilih',
                'product_id.required' => 'Produk SKU harus dipilih',
                'program_date.required' => 'Jangka Waktu Program harus diisi',
                'visual_type_id.required' => 'Visual/Campaign harus dipilih',
                'posm_type_id.required' => 'Jenis POSM harus dipilih',
                'banner_image.required' => 'Banner Program harus diunggah',
                'banner_image.image' => 'File harus berupa gambar',
                'banner_image.max' => 'Ukuran file maksimal 5MB'
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status' => 'error',
                    'errors' => $validator->errors()
                ], 422);
            }

            // Handle banner image upload
            if ($request->hasFile('banner_image')) {
                $file = $request->file('banner_image');
                $fileName = time() . '_' . $file->getClientOriginalName();
                $file->storeAs('public/banners', $fileName);
            }

            // Create visibility record
            $visibility = Visibility::create([
                'city_id' => $request->city_id,
                'outlet_name' => $request->outlet_name,
                'category_id' => $request->category_id,
                'product_id' => $request->product_id,
                'program_date' => $request->program_date,
                'visual_type_id' => $request->visual_type_id,
                'posm_type_id' => $request->posm_type_id,
                'banner_image' => $fileName ?? null
            ]);

            return response()->json([
                'status' => 'success',
                'message' => 'Data visibility berhasil ditambahkan'
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
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
        return view("pages.visibility.edit", compact("id"));
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
        //
    }
}
