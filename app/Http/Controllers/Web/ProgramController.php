<?php

namespace App\Http\Controllers\Web;

use App\Models\Program;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;
use App\Http\Requests\Program\UploadBannerProgram;

class ProgramController extends Controller
{
    public function upload(UploadBannerProgram $request)
    {
        try {
            DB::beginTransaction();
            $province_code = $request->province_code;
            
            // Get all programs for this province, ordered by creation date
            $programs = Program::where('province_code', $province_code)
                             ->orderBy('created_at', 'asc')
                             ->get();
            
            $file = $request->file('program_file');
            
            // If we already have 4 or more programs for this province
            if ($programs->count() >= 4) {
                // Get the oldest program
                $oldestProgram = $programs->first();
                
                // Remove the old file
                if ($oldestProgram->path) {
                    removeFile($oldestProgram->path);
                }
                
                // Save the new file
                $media = saveFile($file, "program/{$request->province_code}");
                
                // Update the oldest record with new data
                $oldestProgram->update([
                    "filename" => $media['filename'],
                    "path" => $media['path'],
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
                
                DB::commit();
                return response()->json([
                    'status' => 'success',
                    'message' => 'Data program berhasil diperbarui'
                ]);
            } else {
                // If we have less than 4 programs, create a new one
                $media = saveFile($file, "program/{$request->province_code}");
                Program::create([
                    "province_code" => $request->province_code,
                    "filename" => $media['filename'],
                    "path" => $media['path'],
                ]);
                
                DB::commit();
                return response()->json([
                    'status' => 'success',
                    'message' => 'Data program berhasil ditambahkan'
                ]);
            }
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error updating program: ' . $e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengupdate program: ' . $e->getMessage()
            ], 500);
        }
    }
}
