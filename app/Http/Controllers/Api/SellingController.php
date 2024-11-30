<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\Selling\SellingCollection;
use App\Models\Selling;
use Carbon\Carbon;
use Illuminate\Http\Request;

class SellingController extends Controller
{
    public function index(Request $request): SellingCollection
    {
        $selling = Selling::query()
            ->with('products')  // Eager load selling_products relationship
            ->where('created_at', '>=', Carbon::today()->subDays(10))
            ->latest()
            ->get();

        return new SellingCollection($selling);
    }
}
