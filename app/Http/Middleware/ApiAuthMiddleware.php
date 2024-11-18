<?php

namespace App\Http\Middleware;

use App\Http\Resources\CustomResponseResource;
use Closure;
use Illuminate\Http\Request;
use Laravel\Sanctum\PersonalAccessToken;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Facades\Auth;

class ApiAuthMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    
    public function handle(Request $request, Closure $next): Response
    {
        $token = $request->bearerToken();

        if (!$token) {
            return (new CustomResponseResource(false, 'Silakan login terlebih dahulu untuk mengakses halaman ini', null))
                ->toResponse($request);
        }

        $tokenInstance = PersonalAccessToken::findToken($token);
        if ($tokenInstance === null) {
            return (new CustomResponseResource(false, 'Sesi anda telah berakhir. Silakan login kembali', null))
                ->response()
                ->setStatusCode(401);
        }

        // Get the user and verify it exists
        $user = $tokenInstance->tokenable;
        if (!$user) {
            return (new CustomResponseResource(false, 'User tidak ditemukan', null))
                ->response()
                ->setStatusCode(401);
        }

        // Set user in Auth facade
        Auth::login($user);

        return $next($request);
    }
}
