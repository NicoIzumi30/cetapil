<?php

namespace App\Http\Controllers;

use App\Http\Requests\Product\CreateProductRequest;
use App\Models\Product;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator;

class ProductController extends Controller
{
    public function index(Request $request)
    {
        // Validate and get per_page parameter
        $perPage = $request->input('per_page', 10);

        $validPerPage = in_array($perPage, [10, 20, 30, 40, 50]) ? $perPage : 10;
        
        // Get all products with pagination
        $items = Product::with('category')
            ->latest()
            ->paginate($validPerPage);
            
        // Get all categories for the form
        $categories = Category::all();
            
        if ($validPerPage != 10) {
            $items->appends(['per_page' => $validPerPage]);
        }

        // Pass both items and categories to the view
        return view('pages.product.index', compact('items', 'categories'));
    }

    public function create()
    {
        $categories = Category::all();
        return view('pages.product.create', compact('categories'));
    }

    public function store(CreateProductRequest $request)
    {
        $product = Product::create($request->validated());

        return response()->json([
            'status' => 'success',
            'message' => 'Product berhasil ditambahkan'
        ]);
    }

    public function destroy(Product $product)
    {
        try {
            $product->delete(); 

            return response()->json([
                'status' => 'success',
                'message' => 'Produk berhasil dihapus'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal menghapus produk'
            ], 500);
        }
    }

    public function edit(Product $product)
    {
        $categories = Category::all();
        return view('pages.product.edit', compact('product', 'categories'));
    }

    public function update(CreateProductRequest $request, Product $product)
    {
        try {
            $product->update($request->validated());

            return response()->json([
                'status' => 'success',
                'message' => 'Product berhasil diperbarui'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal memperbarui produk'
            ], 500);
        }
    }

}