<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Http\Requests\Posm\CreatePosmRequest;
use App\Http\Requests\Posm\CreateImagePOSM;
use App\Models\PosmType;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\PosmImage;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;


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
            $posmTypes = PosmType::all();
            $uploadedImages = [];
            $actions = []; // Track apakah insert atau update
    
            // Map file inputs ke POSM types
            $posmMapping = [
                'backwall' => 'Backwall',
                'standee' => 'Standee',
                'glolifier' => 'Glorifier',
                'coc' => 'COC'
            ];
    
            foreach ($posmMapping as $inputName => $posmTypeName) {
                if ($request->hasFile($inputName)) {
                    $file = $request->file($inputName);
                    
                    // Find corresponding POSM type
                    $posmType = $posmTypes->firstWhere('name', $posmTypeName);
                    
                    if ($posmType) {
                        // Generate filename
                        $fileName = uniqid() . '_' . $file->getClientOriginalName();
                        
                        // Store file
                        $path = $file->storeAs('public/posm-images', $fileName);
    
                        // Check if record exists
                        $existingImage = PosmImage::where('posm_type_id', $posmType->id)->first();
    
                        if ($existingImage) {
                            // Update existing record
                            if ($existingImage->path) {
                                // Delete old file
                                Storage::delete($existingImage->path);
                            }
                            
                            $existingImage->update([
                                'image' => $fileName,
                                'path' => $path
                            ]);
                            
                            $actions[$inputName] = 'updated';
                        } else {
                            // Create new record
                            PosmImage::create([
                                'posm_type_id' => $posmType->id,
                                'image' => $fileName,
                                'path' => $path
                            ]);
                            
                            $actions[$inputName] = 'inserted';
                        }
    
                        $uploadedImages[] = $inputName;
                    }
                }
            }
    
            // Prepare response message
            $message = '';
            if (!empty($actions)) {
                $inserted = array_filter($actions, fn($action) => $action === 'inserted');
                $updated = array_filter($actions, fn($action) => $action === 'updated');
                
                if (!empty($inserted)) {
                    $message .= count($inserted) . ' foto baru ditambahkan. ';
                }
                if (!empty($updated)) {
                    $message .= count($updated) . ' foto diperbarui.';
                }
            } else {
                $message = 'Tidak ada perubahan foto.';
            }
    
            return response()->json([
                'status' => 'success',
                'message' => trim($message),
                'uploaded_images' => $uploadedImages,
                'actions' => $actions
            ]);
    
        } catch (\Exception $e) {
            Log::error('Error updating POSM images: ' . $e->getMessage());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Terjadi kesalahan saat mengupload gambar'
            ], 500);
        }
    }

private function processImage($file, $posmType)
{
    if (!$posmType) {
        throw new \Exception('POSM type not found');
    }

    // Generate filename
    $fileName = uniqid() . '_' . $file->getClientOriginalName();
    
    // Store file
    $path = $file->storeAs('public/posm-images', $fileName);

    // Delete existing image if exists
    PosmImage::where('posm_type_id', $posmType->id)->delete();

    // Create new record
    PosmImage::create([
        'posm_type_id' => $posmType->id,
        'image' => $fileName,
        'path' => $path
    ]);
}



}