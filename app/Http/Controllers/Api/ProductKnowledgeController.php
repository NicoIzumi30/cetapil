<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Models\ProductKnowledge;
use App\Http\Controllers\Controller;
use App\Http\Resources\Routing\RoutingCollection;
use App\Http\Resources\ProductKnowladge\ProductKnowladgeCollection;

class ProductKnowledgeController extends Controller
{
    public function index()
    {
        $productKnowledge = ProductKnowledge::latest('created_at')->first();
        return new ProductKnowladgeCollection(collect([$productKnowledge]));
    }
}
