<?php

namespace App\Observers;

use App\Http\Controllers\Web\DashboardController;
use App\Models\SalesVisibility;

class SalesVisibilityObserver
{
    public function saved(SalesVisibility $visibility)
    {
        try {
            $provinceId = $visibility->salesActivity->outlet->city->province_id;
            app(DashboardController::class)->updateShelvingCache($provinceId);
        } catch (\Exception $e) {
            \Log::error('Error updating shelving cache: ' . $e->getMessage());
        }
    }

    public function deleted(SalesVisibility $visibility)
    {
        try {
            $provinceId = $visibility->salesActivity->outlet->city->province_id;
            app(DashboardController::class)->updateShelvingCache($provinceId);
        } catch (\Exception $e) {
            \Log::error('Error updating shelving cache after delete: ' . $e->getMessage());
        }
    }
}