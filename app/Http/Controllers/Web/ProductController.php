<?php

namespace App\Http\Controllers\Web;

use App\Http\Requests\Product\UpdateAv3mRequest;
use App\Http\Requests\Product\UpdateProductRequest;
use Exception;
use App\Models\Av3m;
use App\Models\Channel;
use App\Models\Product;
use App\Models\Category;
use Illuminate\Http\Request;
use App\Imports\ProductImport;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Validation\ValidationException;
use App\Http\Requests\Product\CreateProductRequest;
use App\Http\Controllers\Controller;

class ProductController extends Controller
{
    public function index(Request $request)
    {
        // Validate and get per_page parameter
        $perPage = $request->input('per_page', 10);
        $validPerPage = in_array($perPage, [10, 20, 30, 40, 50]) ? $perPage : 10;

        $items = Product::with('category')->latest()->get();
        $categories = Category::all();
        $channels = Channel::all();
        return view('pages.product.index', [
            'items' => $items,
            'categories' => $categories,
            'product' => null,
            'channels' => $channels
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
        $product->load('category'); 
        return response()->json([
            'id' => $product->id,
            'category_id' => $product->category_id,
            'sku' => $product->sku,
            'md_price' => $product->md_price,
            'sales_price' => $product->sales_price
        ]);
    }

    public function update(UpdateProductRequest $request, Product $product)
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
        $id = $product->id;
        $av3mData = Av3m::where('product_id', $id)->get();
        $channels = Channel::all();
        $data['id'] = $id;
        $no = 0;
        foreach ($channels as $channel) {
            $no = $no + 1;
            $av3m = Av3m::where('product_id', $id)->where('channel_id', $channel->id)->first();
            $data['channel_' . $no] = $av3m->av3m ?? 0;
        }
        return response()->json($data);
    }

    public function updateAv3m(UpdateAv3mRequest $request, Product $product)
    {
        try {
            $channelIds = Channel::pluck('id');
            $savedAv3m = [];

            foreach ($channelIds as $index => $channelId) {
                $channelNumber = $index + 1;
                $av3m = Av3m::updateOrCreate(
                    [
                        'product_id' => $product->id,
                        'channel_id' => $channelId
                    ],
                    [
                        'av3m' => $request->input("channel_$channelNumber")
                    ]
                );
                $savedAv3m[] = $av3m;
            }

            return response()->json([
                'status' => 'success',
                'message' => 'AV3M berhasil diperbarui',
                'data' => $savedAv3m
            ], 200);

        } catch (ValidationException $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validasi gagal',
                'errors' => $e->errors()
            ], 422);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
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

    try {
        $file = $request->file('excel_file');
        $fileName = $file->getClientOriginalName();
        $import = new ProductImport($fileName);
        Excel::import($import, $file);
        
        if ($import->response['status'] == 'error') {
            throw new Exception($import->response['message']);
        }

        return response()->json(['message' => 'Import success'], 200);
    } catch (\Exception $e) {
        return response()->json(['message' => $e->getMessage()], 500);
    }
}
}
