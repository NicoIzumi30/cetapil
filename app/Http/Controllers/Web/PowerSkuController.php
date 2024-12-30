<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Http\Requests\PowerSku\CreatePowerSkuRequest;
use App\Models\PowerSku;
use App\Models\Product;
use App\Models\Category;
use App\Models\SurveyAvailability;
use App\Models\SurveyCategory;
use App\Models\SurveyQuestion;
use App\Traits\HasAuthUser;
use Illuminate\Http\Request;
use Yajra\DataTables\Facades\DataTables;
use Illuminate\Support\Facades\Log;


class PowerSkuController extends Controller
{
    use HasAuthUser;
    public function index()
    {
        $products = Product::with('category')->get();
        $categories = Category::all();
        return view('pages.products.index', compact('products', 'categories'));
    }

    public function getProductsByCategory($category_id)
    {
        try {
            $products = Product::where('category_id', $category_id)
                ->whereNotIn('id', function ($query) {
                    $query->select('product_id')
                        ->from('power_skus')
                        ->whereNull('deleted_at');
                })
                ->select('id', 'sku')
                ->get();

            return response()->json($products);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Gagal mengambil data produk: ' . $e->getMessage()
            ], 500);
        }
    }

    public function data(Request $request)
    {
        $query = PowerSku::with(['product.category']);

        if ($request->filled('search_term')) {
            $searchTerm = $request->search_term;
            $query->whereHas('product', function ($q) use ($searchTerm) {
                $q->where('sku', 'like', "%{$searchTerm}%");
            })->orWhereHas('product.category', function ($q) use ($searchTerm) {
                $q->where('name', 'like', "%{$searchTerm}%");
            });
        }

        $filteredRecords = (clone $query)->count();
        $result = $query->skip($request->start)
            ->take($request->length)
            ->get();

        return response()->json([
            'draw' => intval($request->draw),
            'recordsTotal' => PowerSku::count(),
            'recordsFiltered' => $filteredRecords,
            'data' => $result->map(function ($powerSku) {
                return [
                    'category' => optional($powerSku->product->category)->name ?? '-',
                    'sku' => $powerSku->product->sku,
                    'actions' => view('pages.product.action-power-sku', [
                        'powerSku' => $powerSku // Pass entire model
                    ])->render(),
                ];
            }),
        ]);
    }

    public function store(CreatePowerSkuRequest $request)
    {
        try {
            $data = $request->validated();

            if ($data['select-input-survey-data'] === 'power-sku') {
                $surveyQuestionCategory1 = SurveyCategory::where('title', 'Apakah POWER SKU tersedia di toko?')->first()->id;
                $surveyQuestionCategory2 = SurveyCategory::where('title', 'Berapa harga POWER SKU di toko?')->first()->id;
                $product = Product::find($data['power-sku'])->first();
                // Apakah ada Power SKU di toko?
                $survey1 = SurveyQuestion::create([
                    'survey_category_id' => $surveyQuestionCategory1,
                    'type' => "bool",
                    'product_id' => $data['power-sku'],
                    'question' => $product->sku,
                ])->id;
                // Berapa harga POWER SKU di toko?
                $survey2 =  SurveyQuestion::create([
                    'survey_category_id' => $surveyQuestionCategory2,
                    'type' => "text",
                    'product_id' => $data['power-sku'],
                    'question' => $product->sku,
                ])->id;
                SurveyAvailability::create([
                    'category' => "Power SKU",
                    'survey_question_id' => $survey1,
                    'survey_question_id_2' => $survey2,
                    'product_id' => $data['select-input-survey-data'] === 'power-sku' ? $data['power-sku'] : null,
                    'product_name' => $product->sku,
                ]);
                PowerSku::create([
                    'product_id' => $data['power-sku'],
                ]);
            }
            if ($data['select-input-survey-data'] === 'harga-kompetitor') {
                $surveyQuestionCategory1 = SurveyCategory::where('title', 'Berapa harga kompetitor di toko?')->first()->id;
                $survey1 = SurveyQuestion::create([
                    'survey_category_id' => $surveyQuestionCategory1,
                    'type' => "text",
                    'question' => $data['product-competitor'],
                ])->id;
                SurveyAvailability::create([
                    'category' => "Harga Kompetitif",
                    'survey_question_id' => $survey1,
                    'product_name' => $data['product-competitor'],
                ]);
            }

            return response()->json([
                'message' => 'Power SKU berhasil ditambahkan'
            ]);
        } catch (\Exception $e) {
            Log::error('Failed to store Power SKU: ' . $e->getMessage());
            return response()->json([
                'message' => 'Gagal menambahkan Power SKU' . $e->getMessage()
            ], 500);
        }
    }

    public function edit(PowerSku $powerSku) {}

    public function update(CreatePowerSkuRequest $request, PowerSku $powerSku) {}

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
