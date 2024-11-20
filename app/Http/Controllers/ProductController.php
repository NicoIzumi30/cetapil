<?php

namespace App\Http\Controllers;

use Exception;
use App\Models\Product;
use App\Models\Category;
use Illuminate\Http\Request;
use App\Imports\ProductImport;
use Illuminate\Support\Facades\DB;
use Illuminate\Pagination\LengthAwarePaginator;
use App\Http\Requests\Product\CreateProductRequest;
use Maatwebsite\Excel\Facades\Excel;

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
    public function downloadTemplate()
    {
        $filePath = public_path('assets/template/template_buk_product.xlsx');
        $fileName = 'template_buk_product_' . now()->timestamp . '.xlsx';
        if (file_exists($filePath)) {
            return response()->download($filePath, $fileName);
        }
        return abort(404, 'File tidak ditemukan');
    }
    public function bulk(Request $request)
    {
        $request->validate([
            'excel_file' => 'required|mimes:xlsx|max:10240'
        ]);

        DB::beginTransaction();
        try {
            $file = $request->file('excel_file');
            // Sanitasi nama file
            $fileName = str_replace(' ', '_', $file->getClientOriginalName());
            $fileName = preg_replace('/[^A-Za-z0-9\-\_\.]/', '', $fileName);

            $import = new ProductImport($fileName);
            Excel::import($import, $file);

            if ($import->response['status'] == 'error') {
                throw new Exception($import->response['message']);
            }

            DB::commit();
            return response()->json(['message' => 'Import success'], 200);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => $e->getMessage()], 500);
        }
    }
}
