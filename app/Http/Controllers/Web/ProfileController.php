<?php

namespace App\Http\Controllers\Web;

use App\Http\Controllers\Controller;
use App\Http\Requests\Profile\UpdatePasswordRequest;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class ProfileController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        return view('pages.profile', compact('user'));
    }

    public function updatePassword(UpdatePasswordRequest $request): JsonResponse
    {
        $user = Auth::user();
        $currentPassword = $request->current_password;
        $hashedPassword = $user->password;

        // Verify current password
        if (!Hash::check($currentPassword, $hashedPassword)) {
            return response()->json([
                'status' => 'error',
                'errors' => [
                    'current_password' => ['Kata sandi lama anda tidak sesuai']
                ]
            ], 422);
        }

        // Update password directly in database
        try {
            DB::table('users')
                ->where('id', $user->id)
                ->update(['password' => Hash::make($request->new_password)]);

            return response()->json([
                'status' => 'success',
                'message' => 'Password berhasil diubah'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Gagal mengubah password'
            ], 500);
        }
    }
}