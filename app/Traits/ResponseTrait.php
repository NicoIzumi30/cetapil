<?php

namespace App\Traits;

use Illuminate\Http\JsonResponse;
use Symfony\Component\HttpFoundation\Response as HTTPCode;

trait ResponseTrait
{
    public function loginSuccess(string $token, string $message = "", $data = false, array $headers = []): JsonResponse
    {
        $jsonData = [];
        $jsonData['status'] = "OK";
        $jsonData['message'] = $message;
        $jsonData['token'] = $token;
        if ($data || is_array($data)) {
            $jsonData['data'] = $data;
        }
        return response()->json($jsonData, HTTPCode::HTTP_OK, $headers);
    }

    public function successResponse(string $message = "", int $code = HTTPCode::HTTP_OK, $data = false, array $headers = []): JsonResponse
    {
        $jsonData = [];
        $jsonData['status'] = "OK";
        $jsonData['message'] = $message;
        if ($data || is_array($data)) {
            $jsonData['data'] = $data;
        }
        return response()->json($jsonData, $code, $headers);
    }

    public function failedResponse(string $message = "", int $code = HTTPCode::HTTP_BAD_REQUEST, $data = false, array $headers = []): JsonResponse
    {
        $jsonData = [];
        if ($data || is_array($data)) {
            $jsonData['data'] = $data;
        }
        $jsonData['status'] = "ERROR";
        $jsonData['message'] = $message;
        return response()->json($jsonData, $code, $headers);
    }

    public function errorValidation(object $message, array $headers = []): JsonResponse
    {
        $jsonData = [];
        $jsonData['status'] = "ERROR";
        $jsonData['message'] = $message;
        return response()->json($jsonData, HTTPCode::HTTP_UNPROCESSABLE_ENTITY, $headers);
    }

}
