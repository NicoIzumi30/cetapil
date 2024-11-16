<?php

namespace App\Http\Middleware;

use App\Http\Resources\CustomResponseResource;
use Closure;
use Illuminate\Http\Request;
use Laravel\Sanctum\PersonalAccessToken;
use Symfony\Component\HttpFoundation\Response;

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

        // Jika token kosong, berarti user belum login sama sekali
        if (!$token) {
            return (new CustomResponseResource(false, 'Silakan login terlebih dahulu untuk mengakses halaman ini', null))->toResponse($request);
        }

        // Jika token ada tapi tidak valid
        $tokenInstance = PersonalAccessToken::findToken($token);
        if ($tokenInstance === null) {
            return (new CustomResponseResource(false, 'Sesi anda telah berakhir. Silakan login kembali', null))
                ->response()
                ->setStatusCode(401); // Unauthorized status code
        }

        return $next($request);
    }
}
