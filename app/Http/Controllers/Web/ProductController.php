<?php

namespace App\Http\Controllers\Web;

use Exception;
use Carbon\Carbon;
use App\Models\Av3m;
use App\Models\City;
use App\Models\Channel;
use App\Models\Product;
use App\Models\Category;
use App\Exports\Av3mExport;
use App\Models\PowerSku;
use Illuminate\Http\Request;
use App\Exports\ProductExport;
use App\Imports\ProductImport;
use App\Models\SalesAvailability;
use App\Exports\StockOnHandExport;
use Illuminate\Support\Facades\DB;
use App\Exports\Av3mTemplateExport;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\ValidationException;
use App\Http\Requests\Product\UpdateAv3mRequest;
use App\Http\Requests\Product\CreateProductRequest;
use App\Http\Requests\Product\UpdateProductRequest;
use App\Imports\ProductAV3MImport;

class ProductController extends Controller
{
    public function index(Request $request)
    {

        $categories = Category::all();
        $channels = Channel::all();
        $cities = City::select('id', 'name')->get();
        $products = Product::select('id', 'sku')->get();
        return view('pages.product.index', [
            'categories' => $categories,
            'cities' => $cities,
            'products' => $products,
            'channels' => $channels
        ]);
    }
    public function getData(Request $request)
    {
        $query = Product::with('category');

        if ($request->filled('search_term')) {
            $searchTerm = htmlspecialchars($request->search_term, ENT_QUOTES, 'UTF-8');
            $query->where(function ($q) use ($searchTerm) {
                $q->where('sku', 'like', "%{$searchTerm}%")
                    ->orWhereHas('category', function ($q) use ($searchTerm) {
                        $q->where('name', 'like', "%{$searchTerm}%");
                    });
            });
        }

        $filteredRecords = (clone $query)->count();

        $result = $query->skip($request->start)
            ->take($request->length)
            ->get();

        return response()->json([
            'draw' => intval($request->draw),
            'recordsTotal' => $filteredRecords,
            'recordsFiltered' => $filteredRecords,
            'data' => $result->map(function ($item) {
                return [
                    'id' => $item->id,
                    'category' => htmlspecialchars($item->category->name, ENT_QUOTES, 'UTF-8'),
                    'sku' => htmlspecialchars($item->sku, ENT_QUOTES, 'UTF-8'),
                    'price' => number_format($item->price, 0, ',', '.'),
                    'actions' => view('pages.product.action', [
                        'productId' => $item->id,
                        'sku' => htmlspecialchars($item->sku, ENT_QUOTES, 'UTF-8'),
                        'categories' => Category::all()->map(function($category) {
                            return [
                                'id' => $category->id,
                                'name' => htmlspecialchars($category->name, ENT_QUOTES, 'UTF-8')
                            ];
                        })
                    ])->render()
                ];
            })
        ]);
    }
    public function getDataAvailability(Request $request)
    {
        $query = SalesAvailability::with(['product:id,sku', 'outlet:id,name']);
        if ($request->filled('date')) {
            $dateParam = $request->date;

            if (str_contains($dateParam, ' to ')) {
                [$startDate, $endDate] = explode(' to ', $dateParam);
                $query->whereBetween('created_at', [
                    Carbon::parse($startDate)->startOfDay(),
                    Carbon::parse($endDate)->endOfDay()
                ]);
            } else {
                $query->whereDate('created_at', Carbon::parse($dateParam));
            }
        }

        if ($request->filled('filter_product')) {
            $filter_product = $request->filter_product;
            if ($filter_product != 'all') {
                $query->where('product_id', $filter_product);
            }
        }

        if ($request->filled('filter_area')) {
            $filter_area = $request->filter_area;
            if ($filter_area != 'all') {
                $query->where(function ($q) use ($filter_area): void {
                    $q->WhereHas('outlet', function ($q) use ($filter_area) {
                        $q->where('city_id', $filter_area);
                    });
                });
            }
        }
        $filteredRecords = (clone $query)->count();

        $result = $query->skip($request->start)
            ->take($request->length)
            ->get();
        return response()->json([
            'draw' => intval($request->draw),
            'recordsTotal' => $filteredRecords,
            'recordsFiltered' => $filteredRecords,
            'data' => $result->map(function ($item) {
                return [
                    'id' => $item->id, // Tambahkan id product
                    'outlet' => $item->outlet->name,
                    'sku' => $item->product->sku,
                    'sod' => $item->stock_on_hand,
                    'si' => $item->stock_inventory,
                    'rekomendasi' => spanColor($item->rekomendasi, $item->rekomendasi > 0 ? 'green' : 'red'),
                    'av3m' => $item->av3m,
                    'status' => spanColor($item->status_ideal, $item->status_ideal == 'IDEAL' ? 'green' : 'red'),
                    'availability' => spanColor($item->availability, $item->availability == 'Y' ? 'green' : 'red'),
                ];
            })
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
            'price' => $product->price
        ]);
    }

    public function getProductsByCategory($categoryId)
    {
        $products = Product::where('category_id', $categoryId)
            ->select('id', 'sku')
            ->get();

        return response()->json($products);
    }
    public function update(UpdateProductRequest $request, Product $product)
    {
        try {
            $product->update([
                'category_id' => $request->category_id,
                'sku' => $request->sku,
                'price' => $request->price,
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

    public function getProductBySurveyType(Request $request)
    {
        try {
            if ($request->type === 'power_sku') {
                // Get products that are not yet power SKUs
                $products = Product::select('id', 'sku')
                    ->whereNotIn('id', PowerSku::pluck('product_id'))
                    ->get();

                return response()->json($products);
            } else if ($request->type === 'competitor') {
                // Get all products
                $products = Product::select('id', 'sku')->get();
                return response()->json($products);
            }

            return response()->json(['message' => 'Invalid survey type'], 400);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Error fetching products: ' . $e->getMessage()
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
    public function downloadExcel()
    {
        try {
            return Excel::download(new ProductExport(), 'products_data_' . now()->format('Y-m-d_His') . '.xlsx', \Maatwebsite\Excel\Excel::XLSX);
        } catch (\Exception $e) {
            Log::error('Excel Download Error', [
                'message' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine()
            ]);

            return response()->json([
                'status' => 'error',
                'message' => 'Gagal membuat file Excel: ' . $e->getMessage()
            ], 500);
        }
    }

    public function getExcelFile($filename)
    {
        try {
            $path = storage_path('app/temp/' . $filename);

            if (!file_exists($path)) {
                throw new \Exception('File tidak ditemukan di path: ' . $path);
            }

            return response()->download($path, $filename, [
                'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            ])->deleteFileAfterSend(true);
        } catch (\Exception $e) {
            Log::error('Excel Download Error: ' . $e->getMessage(), [
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'filename' => $filename,
                'path' => $path ?? null
            ]);

            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengunduh file: ' . $e->getMessage()
            ], 500);
        }
    }


    public function downloadAvailability(Request $request)
{
    try {
        DB::enableQueryLog();

        // Base query with eager loading
        $query = SalesAvailability::query()
            ->with([
                'salesActivity:id,time_availability',
                'product:id,sku',
                'outlet.user:id,name',
                'outlet.city:id,name',
                'outlet.channel:id,name',
                'outlet' => function ($query) {
                    $query->select('id', 'name', 'code', 'tipe_outlet', 'TSO', 'city_id', 'channel_id', 'user_id', 'account');
                }
            ]);

        // Remove status filter temporarily for testing
        // $query->where('status', 'SUBMITTED');

        // Apply date filter
        if ($request->filled('filter_date') && $request->filter_date !== 'Date Range') {
            $dateParam = $request->filter_date;
            if (str_contains($dateParam, ' to ')) {
                [$startDate, $endDate] = explode(' to ', $dateParam);
                $query->whereBetween('created_at', [
                    Carbon::parse($startDate)->startOfDay(),
                    Carbon::parse($endDate)->endOfDay()
                ]);
            } else {
                $query->whereDate('created_at', Carbon::parse($dateParam));
            }
        }

        // Apply product filter
        if ($request->filled('filter_product') && $request->filter_product !== 'all') {
            $query->where('product_id', $request->filter_product);
        }

        // Apply area filter
        if ($request->filled('filter_area') && $request->filter_area !== 'all') {
            $query->whereHas('outlet', function ($q) use ($request) {
                $q->where('city_id', $request->filter_area);
            });
        }

        // Execute query and get data
        $data = $query->get();

        // Log query and data for debugging
        Log::info('Availability Export Debug Info', [
            'filters' => $request->all(),
            'query' => DB::getQueryLog(),
            'record_count' => $data->count(),
            'first_record' => $data->first(),
            'sql' => $query->toSql(),
            'bindings' => $query->getBindings()
        ]);

        // Check if data exists
        if ($data->isEmpty()) {
            Log::warning('No data found for export', [
                'filters' => $request->all()
            ]);
            return response()->json([
                'error' => true,
                'message' => 'Tidak ada data yang tersedia untuk diexport'
            ], 404);
        }

        // Generate Excel file
        return Excel::download(
            new StockOnHandExport($data),
            'availability_data_' . now()->format('Y-m-d_His') . '.xlsx',
            \Maatwebsite\Excel\Excel::XLSX
        );

    } catch (\Exception $e) {
        Log::error('Availability Export Error', [
            'message' => $e->getMessage(),
            'trace' => $e->getTraceAsString(),
            'filters' => $request->all()
        ]);

        return response()->json([
            'error' => true,
            'message' => 'Gagal mengunduh file: ' . $e->getMessage()
        ], 500);
    }
}

    public function downloadAv3m()
    {
        try {
            DB::enableQueryLog();

            $data = Av3m::with('product:id,sku', 'outlet:id,name,code as outlet_code')->get();

            // Log untuk debugging
            Log::info('Av3m Export Data', [
                'query' => DB::getQueryLog(),
                'record_count' => $data->count()
            ]);
            return Excel::download(
                new Av3mExport($data),
                'av3m_' . now()->format('Y-m-d_His') . '.xlsx',
                \Maatwebsite\Excel\Excel::XLSX
            );
        } catch (\Exception $e) {
            Log::error('Av3m Export Error', [
                'message' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'error' => true,
                'message' => 'Gagal mengunduh file: ' . $e->getMessage()
            ], 500);
        }
    }
    public function templateAv3m()
    {
        try {
            DB::enableQueryLog();

            $data = Product::with('category')->get();

            // Log untuk debugging
            Log::info('Av3m Template Data', [
                'query' => DB::getQueryLog(),
                'record_count' => $data->count()
            ]);
            return Excel::download(
                new Av3mTemplateExport($data),
                'av3m_template_' . now()->format('Y-m-d_His') . '.xlsx',
                \Maatwebsite\Excel\Excel::XLSX
            );
        } catch (\Exception $e) {
            Log::error('Av3m Template Error', [
                'message' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'error' => true,
                'message' => 'Gagal mengunduh file: ' . $e->getMessage()
            ], 500);
        }
    }
    // public function bulk(Request $request)
    // {
    //     $request->validate([
    //         'excel_file' => 'required|mimes:xlsx|max:10240'
    //     ]);

    //     try {
    //         $file = $request->file('excel_file');
    //         $fileName = $file->getClientOriginalName();
    //         $import = new ProductImport($fileName);
    //         Excel::import($import, $file);

    //         if ($import->response['status'] == 'error') {
    //             throw new Exception($import->response['message']);
    //         }

    //         return response()->json(['message' => 'Import success'], 200);
    //     } catch (\Exception $e) {
    //         return response()->json(['message' => $e->getMessage()], 500);
    //     }
    // }
    public function av3mBulk(Request $request)
    {
        $request->validate([
            'excel_file' => 'required|mimes:xlsx|max:5120'
        ]);

        try {
            $file = $request->file('excel_file');
            $fileName = $file->getClientOriginalName();
            $import = new ProductAV3MImport($fileName);
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
