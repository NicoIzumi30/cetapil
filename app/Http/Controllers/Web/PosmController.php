<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Http\Requests\Posm\CreatePosmRequest;
use App\Http\Requests\Posm\CreateImagePOSM;
use App\Models\PosmType;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\PosmImage;
use Illuminate\Support\Str;

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

    public function updateImage(CreateImagePOSM $request)
{
    try {
        $imageTypes = [
            'backwall' => '9d88dc9e-7bdd-4cbc-b0b8-0c5e7c5d3953',
            'standee' => '9d88dc9e-7e53-4bed-bdc7-d8cd454a8229', 
            'glolifier' => '9d88dc9e-8059-4a60-8e51-6ba4ec2b7855',
            'coc' => '9d88dc9e-821f-462d-96c2-04b9c72184d9'
        ];
        
        foreach ($imageTypes as $type => $posmTypeId) {
            if ($request->hasFile($type)) {
                $existingImage = PosmImage::where('posm_type_id', $posmTypeId)->first();

                $file = $request->file($type);
                $media = saveFile($file, "posm/{$posmTypeId}");

                if ($existingImage) {
                    // Remove old file if exists
                    removeFile($existingImage->path);
                    
                    $existingImage->update([
                        'image' => $media['filename'],
                        'path' => $media['path'],
                        'type' => $type
                    ]);
                } else {
                    PosmImage::create([
                        'id' => Str::uuid(),
                        'posm_type_id' => $posmTypeId,
                        'type' => $type,
                        'image' => $media['filename'],
                        'path' => $media['path']
                    ]);
                }
            }
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Foto POSM berhasil diperbarui'
        ]);

    } catch (\Exception $e) {
        return response()->json([
            'status' => 'error',
            'message' => 'Terjadi kesalahan: ' . $e->getMessage()
        ], 500);
    }
}
}