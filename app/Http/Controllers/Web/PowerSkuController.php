<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Http\Requests\PowerSku\CreatePowerSkuRequest;
use App\Models\PowerSku;
use App\Models\Product;
use Yajra\DataTables\Facades\DataTables;
use Illuminate\Support\Facades\Log;


class PowerSkuController extends Controller
{

    public function index()
    {
        $products = Product::with('category')->get();
        return view('pages.products.index', compact('products'));
    }

    public function data()
    {
        $powerSkus = PowerSku::with('product.category')->get();

        return DataTables::of($powerSkus)
            ->addColumn('category', function ($powerSku) {
                return $powerSku->product->category->name;
            })
            ->addColumn('sku', function ($powerSku) {
                return $powerSku->product->sku;
            })
            ->addColumn('actions', function ($powerSku) {
                return view('components.action-button', [
                    'id' => $powerSku->id,
                    'sku' => $powerSku->product->sku
                ])->render();
            })
            ->rawColumns(['actions'])
            ->make(true);
    }

    public function store(CreatePowerSkuRequest $request)
    {
        try {
            Log::info('PowerSku store request:', $request->all());
            
            // Buat product baru dengan menambahkan price
            $product = Product::create([
                'category_id' => $request->input('power-sku-category_id'),
                'sku' => $request->input('power-sku'),
                'price' => 0 
            ]);
    
            // Buat Power SKU dengan product_id
            PowerSku::create([
                'product_id' => $product->id
            ]);
    
            return response()->json([
                'message' => 'Power SKU berhasil ditambahkan'
            ], 201);
        } catch (\Exception $e) {
            Log::error('PowerSku store error:', ['error' => $e->getMessage()]);
            return response()->json([
                'message' => 'Gagal menambahkan Power SKU: ' . $e->getMessage()
            ], 500);
        }
    }

    public function edit(PowerSku $powerSku)
    {
        return response()->json([
            'id' => $powerSku->id,
            'product_id' => $powerSku->product_id,
            'product' => $powerSku->product
        ]);
    }

    public function update(CreatePowerSkuRequest $request, PowerSku $powerSku)
    {
        try {
            $product = Product::findOrFail($request->product_id);
            
            $powerSku->update([
                'product_id' => $product->id
            ]);

            return response()->json([
                'message' => 'Power SKU berhasil diperbarui'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Gagal memperbarui Power SKU'
            ], 500);
        }
    }

    public function destroy(PowerSku $powerSku)
    {
        try {
            $powerSku->delete();

            return response()->json([
                'message' => 'Power SKU berhasil dihapus'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Gagal menghapus Power SKU'
            ], 500);
        }
    }
}