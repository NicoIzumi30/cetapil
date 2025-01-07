<?php

namespace App\Observers;

use App\Http\Controllers\Web\DashboardController;
use App\Models\SalesAvailability;

class SalesAvailabilityObserver
{
    public function saved(SalesAvailability $availability)
    {
        try {
            $provinceId = $availability->outlet->city->province_id;
            app(DashboardController::class)->updateStockCache($provinceId);
        } catch (\Exception $e) {
            \Log::error('Error updating stock cache: ' . $e->getMessage());
        }
    }

    public function deleted(SalesAvailability $availability)
    {
        try {
            $provinceId = $availability->outlet->city->province_id;
            app(DashboardController::class)->updateStockCache($provinceId);
        } catch (\Exception $e) {
            \Log::error('Error updating stock cache after delete: ' . $e->getMessage());
        }
    }
}