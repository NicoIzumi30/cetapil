<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Http\Requests\Posm\CreatePosmRequest;
use App\Models\PosmType;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PosmController extends Controller
{
    public function store(CreatePosmRequest $request)
    {
        try {
            PosmType::create([
                'name' => $request->posm_name
            ]);

            return response()->json([
                'status' => 'success',
                'message' => 'Jenis POSM berhasil ditambahkan'
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    public function show()
    {
        try {
            $posmTypes = PosmType::select('id', 'name')->orderBy('name')->get();

            return response()->json([
                'status' => 'success',
                'data' => $posmTypes
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal memuat data POSM'
            ], 500);
        }
    }
}