<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Http\Requests\Visual\CreateVisualRequest;
use App\Models\VisualType;
use Illuminate\Http\Request;

class VisualController extends Controller
{
    public function store(CreateVisualRequest $request)
    {
        $product = VisualType::create($request->validated());

        return response()->json([
            'status' => 'success',
            'message' => 'Visual berhasil ditambahkan'
        ]);
    } 
}
