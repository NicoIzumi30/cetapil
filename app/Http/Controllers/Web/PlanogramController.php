<?php

namespace App\Http\Controllers\Web;

use App\Models\Planogram;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\Controller;
use App\Http\Requests\Planogram\UpdatePlanogramRequest;

class PlanogramController extends Controller
{
    public function uploadPlanogram(UpdatePlanogramRequest $request)
    {
        try {
            DB::beginTransaction();
            $channel = $request->channel;
            $checkChannel = Planogram::where('channel_id', $channel)->first();
            $file = $request->file('planogram_file');
            if ($checkChannel) {
                $oldPath = $checkChannel->path;
                if ($oldPath) {
                    removeFile($oldPath);
                }
                $media = saveFile($file, "planogram/{$request->channel}");
                $checkChannel->update([
                    "filename" => $media['filename'],
                    "path" => $media['path'],
                ]);
                DB::commit();
                return response()->json([
                    'status' => 'success',
                    'message' => 'Data planogram berhasil diperbarui'
                ]);
                
            }else{
                $media = saveFile($file, "planogram/{$request->channel}");
                Planogram::create([
                    "channel_id" => $channel,
                    "filename" => $media['filename'],
                    "path" => $media['path'],
                ]);
                DB::commit();
                return response()->json([
                    'status' => 'success',
                    'message' => 'Data planogram berhasil diperbarui'
                ]);
            }
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error updating planogram: ' . $e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengupdate planogram: ' . $e->getMessage()
            ], 500);
        }
    }
}
