<?php

namespace App\Traits;

use Carbon\Carbon;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Facades\Excel;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use Illuminate\Http\JsonResponse;

trait Downloadable
{
    /**
     * Handle download with error handling and logging
     *
     * @param string $exportClass Export class name
     * @param string $filename Base filename
     * @param array $params Additional parameters for export
     * @param string $errorMessage Custom error message
     * @return BinaryFileResponse|JsonResponse
     */
    protected function handleDownload(string $exportClass, string $filename, array $params = [], string $errorMessage = null): BinaryFileResponse|JsonResponse
    {
        try {
            $timestamp = date('Y-m-d_His');
            $fullFilename = "{$filename}_{$timestamp}.xlsx";
            
            // Create export instance with parameters if needed
            $export = empty($params) ? new $exportClass() : new $exportClass(...$params);
            
            return Excel::download($export, $fullFilename);
        } catch (\Exception $e) {
            Log::error("{$filename} Download Error:", [
                'message' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
                'params' => $params
            ]);

            return response()->json([
                'status' => 'error',
                'message' => $errorMessage ?? "Gagal mengunduh data {$filename}"
            ], 500);
        }
    }

    /**
     * Process date range from request
     *
     * @param string|null $dateRange
     * @return array
     */
    protected function processDateRange(?string $dateRange): array
    {
        if (empty($dateRange)) {
            return [null, null];
        }

        $dates = explode(' to ', $dateRange);
        $startDate = isset($dates[0]) ? Carbon::parse(trim($dates[0])) : null;
        $endDate = isset($dates[1]) ? Carbon::parse(trim($dates[1])) : null;

        return [$startDate, $endDate];
    }

    /**
     * Build query with date range and region filters
     *
     * @param \Illuminate\Database\Eloquent\Builder $query
     * @param string $dateField
     * @param Carbon|null $startDate
     * @param Carbon|null $endDate
     * @param string|null $region
     * @param string $regionField
     * @return \Illuminate\Database\Eloquent\Builder
     */
    protected function applyFilters($query, string $dateField, ?Carbon $startDate, ?Carbon $endDate, ?string $region = null, string $regionField = 'province_code')
    {
        if ($startDate && $endDate) {
            $query->whereBetween($dateField, [
                $startDate->startOfDay(),
                $endDate->endOfDay()
            ]);
        }

        if ($region && $region !== 'all') {
            $query->whereHas('outlet', function ($q) use ($region, $regionField) {
                $q->whereHas('city', function ($q) use ($region, $regionField) {
                    $q->where($regionField, $region);
                });
            });
        }

        return $query;
    }
}