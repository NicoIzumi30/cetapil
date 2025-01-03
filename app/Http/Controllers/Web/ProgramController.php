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
            $program = Program::where('province_code', $province_code)->first();
            $file = $request->file('program_file');
            if ($program) {
                $oldPath = $program->path;
                if ($oldPath) {
                    removeFile($oldPath);
                }
                $media = saveFile($file, "program/{$request->province_code}");
                $program->update([
                    "filename" => $media['filename'],
                    "path" => $media['path'],
                ]);
                DB::commit();
                return response()->json([
                    'status' => 'success',
                    'message' => 'Data program berhasil diperbarui'
                ]);
                
            }else{
                $media = saveFile($file, "program/{$request->province_code}");
                Program::create([
                    "province_code" => $request->province_code,
                    "filename" => $media['filename'],
                    "path" => $media['path'],
                ]);
                DB::commit();
                return response()->json([
                    'status' => 'success',
                    'message' => 'Data program berhasil diperbarui'
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
