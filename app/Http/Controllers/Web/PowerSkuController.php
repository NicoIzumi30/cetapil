<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Http\Requests\PowerSku\CreatePowerSkuRequest;
use App\Http\Requests\PowerSku\UpdatePowerSkuRequest;
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
        $query = SurveyAvailability::with(['product']);

        if ($request->filled('search_term')) {
            $searchTerm = $request->search_term;
            $query->whereHas('product', function ($q) use ($searchTerm) {
                $q->where('sku', 'like', "%{$searchTerm}%");
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
                    // 'category' => optional($powerSku->product->category)->name ?? '-',
                    'sku' => $powerSku->product_name,
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
                $product = Product::where("id", $data['power-sku'])->first();
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
                'message' => 'Gagal menambahkan Power SKU'
            ], 500);
        }
    }

    public function edit($id)
    {
        try {
            $surveyAvailability = SurveyAvailability::with(['product.category'])
                ->findOrFail($id);

            $data = [
                'id' => $surveyAvailability->id,
                'category' => $surveyAvailability->category,
                'product_name' => $surveyAvailability->product_name,
            ];

            if ($surveyAvailability->category === 'Power SKU') {
                $product = Product::with('category')->find($surveyAvailability->product_id);
                $data['product'] = [
                    'id' => $product->id,
                    'sku' => $product->sku,
                    'category_id' => $product->category_id,
                    'category_name' => $product->category->name
                ];
            }

            return response()->json($data);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Gagal mengambil data: ' . $e->getMessage()
            ], 500);
        }
    }

    public function update(UpdatePowerSkuRequest $request, $id)
    {
        try {
            $data = $request->validated();
            $surveyAvailability = SurveyAvailability::findOrFail($id);

            if ($data['edit-select-survey-data'] === 'power-sku') {
                $surveyQuestionCategory1 = SurveyCategory::where('title', 'Apakah POWER SKU tersedia di toko?')->first()->id;
                $surveyQuestionCategory2 = SurveyCategory::where('title', 'Berapa harga POWER SKU di toko?')->first()->id;
                $product = Product::find($data['edit-power-sku']);

                // Update or create survey questions
                $survey1 = SurveyQuestion::updateOrCreate(
                    ['id' => $surveyAvailability->survey_question_id],
                    [
                        'survey_category_id' => $surveyQuestionCategory1,
                        'type' => "bool",
                        'product_id' => $data['edit-power-sku'],
                        'question' => $product->sku,
                    ]
                );

                $survey2 = SurveyQuestion::updateOrCreate(
                    ['id' => $surveyAvailability->survey_question_id_2],
                    [
                        'survey_category_id' => $surveyQuestionCategory2,
                        'type' => "text",
                        'product_id' => $data['edit-power-sku'],
                        'question' => $product->sku,
                    ]
                );

                // Update survey availability
                $surveyAvailability->update([
                    'category' => "Power SKU",
                    'survey_question_id' => $survey1->id,
                    'survey_question_id_2' => $survey2->id,
                    'product_id' => $data['edit-power-sku'],
                    'product_name' => $product->sku,
                ]);

                // Update power sku
                PowerSku::updateOrCreate(
                    ['product_id' => $surveyAvailability->product_id],
                    ['product_id' => $data['edit-power-sku']]
                );
            } else if ($data['edit-select-survey-data'] === 'harga-kompetitor') {
                $surveyQuestionCategory1 = SurveyCategory::where('title', 'Berapa harga kompetitor di toko?')->first()->id;

                // Update survey question
                $survey1 = SurveyQuestion::updateOrCreate(
                    ['id' => $surveyAvailability->survey_question_id],
                    [
                        'survey_category_id' => $surveyQuestionCategory1,
                        'type' => "text",
                        'question' => $data['edit-product-competitor'],
                    ]
                );

                // Update survey availability
                $surveyAvailability->update([
                    'category' => "Harga Kompetitif",
                    'survey_question_id' => $survey1->id,
                    'survey_question_id_2' => null,
                    'product_id' => null,
                    'product_name' => $data['edit-product-competitor'],
                ]);
            }

            return response()->json([
                'message' => 'Power SKU & Harga Kompetitif berhasil diperbarui'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Gagal memperbarui data: ' . $e->getMessage()
            ], 500);
        }
    }

    public function destroy($id)
    {
        try {
            $surveyAvail = SurveyAvailability::where('id', $id)->first();
            PowerSku::where('product_id', $surveyAvail->product_id)->delete();
            SurveyQuestion::where('id', $surveyAvail->survey_question_id)->delete();
            SurveyQuestion::where('id', $surveyAvail->survey_question_id_2)->delete();
            $surveyAvail->delete();

            return response()->json([
                'message' => 'Power SKU & Harga Kompetitif berhasil dihapus'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Gagal menghapus Power SKU & Harga Kompetitif'
            ], 500);
        }
    }
}
