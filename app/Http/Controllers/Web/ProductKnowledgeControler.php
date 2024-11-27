<?php

namespace App\Http\Controllers\Web;

use App\Models\ProductKnowledge;
use Illuminate\Support\Arr;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use App\Http\Requests\ProductKnowledge\UpdateProductKnowledgeRequest;

class ProductKnowledgeControler extends Controller
{
    public function update(UpdateProductKnowledgeRequest $request)
    {
        try {
            DB::beginTransaction();
            $files = ['file_pdf', 'file_video'];
            
            // Cek data existing sekali saja di awal
            $productKnowledge = ProductKnowledge::where('channel_id', $request->channel_id)->first();
            
            foreach ($files as $fileKey) {
                if ($request->hasFile($fileKey)) {
                    // Tentukan tipe berdasarkan nama file
                    $type = $fileKey === 'file_pdf' ? 'pdf' : 'video';
                    
                    $file = $request->file($fileKey);
                    
                    // Pastikan file valid
                    if (!$file->isValid()) {
                        throw new \Exception("File {$type} tidak valid");
                    }
                    
                    $media = saveFile($file, "product-knowledge/{$request->channel_id}",$type);
                    if ($productKnowledge) {
                        // Hapus file lama jika ada
                        $oldPath = $type === 'pdf' ? $productKnowledge->path_pdf : $productKnowledge->path_video;
                        if ($oldPath) {
                            removeFile($oldPath);
                        }
                        // Update data
                        $productKnowledge->{"filename_" . $type} = $media['filename'];
                        $productKnowledge->{"path_" . $type} = $media['path'];
                        $productKnowledge->save();
                    } else {
                        // Jika belum ada data, buat baru
                        $productKnowledge = ProductKnowledge::create([
                            'channel_id' => $request->channel_id,
                            "filename_{$type}" => $media['filename'],
                            "path_{$type}" => $media['path']
                        ]);
                    }
                }
            }
            
            DB::commit();
            return response()->json([
                'status' => 'success',
                'message' => 'Product Knowledge berhasil diperbarui'
            ], 200);
            
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error('Error updating product knowledge: ' . $e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengupdate Product Knowledge: ' . $e->getMessage()
            ], 500);
        }
    }
}
