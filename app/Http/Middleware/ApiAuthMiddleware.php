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
        $tokenInstance = PersonalAccessToken::findToken($token);
        if ($tokenInstance === null) {
            return (new CustomResponseResource(false, 'Unauthorized', null))->toResponse($request);
        }
        return $next($request);
    }
    
}
