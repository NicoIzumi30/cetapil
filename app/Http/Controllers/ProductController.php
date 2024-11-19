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

        $items = Product::with('category')->latest()->get();
        $categories = Category::all();

        return view('pages.product.index', [
            'items' => $items,
            'categories' => $categories,
            // Pass null sebagai default product untuk modal edit
            'product' => null
        ]);
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
        $product->load('category'); // Eager load the category relationship

        return response()->json([
            'id' => $product->id,
            'category_id' => $product->category_id,
            'sku' => $product->sku,
            'md_price' => $product->md_price,
            'sales_price' => $product->sales_price
        ]);
    }

    public function update(CreateProductRequest $request, Product $product)
    {
        try {
            $product->update([
                'category_id' => $request->category_id,
                'sku' => $request->sku,
                'md_price' => $request->md_price,
                'sales_price' => $request->sales_price
            ]);

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

    public function getAv3m(Product $product)
    {
        return response()->json([
            'id' => $product->id,
            'channel_a' => $product->channel_a,
            'channel_b' => $product->channel_b,
            'channel_c' => $product->channel_c,
            'channel_d' => $product->channel_d
        ]);
    }

    public function updateAv3m(Request $request, Product $product)
    {
        $validated = $request->validate([
            'channel_a' => 'required|numeric',
            'channel_b' => 'required|numeric',
            'channel_c' => 'required|numeric',
            'channel_d' => 'required|numeric',
        ]);

        $product->update($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'AV3M berhasil diperbarui'
        ]);
    }


}
