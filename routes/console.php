<?php

use App\Models\SalesActivity;
use Carbon\Carbon;
use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote')->everyMinute();


Artisan::command(
    "reset-sales-activity-day",
    function () {
        try {
            $today = Carbon::now()->startOfDay();

            // Find and delete activities from previous day where check_out is null
            $activities = SalesActivity::query()
                ->whereNull('checked_out')
                ->whereDate('checked_in', '<', $today)
                ->where('status', 'IN_PROGRESS')
                ->get();

            $count = $activities->count();

            if ($count > 0) {
                // Using transaction to ensure data consistency
                DB::transaction(function () use ($activities) {
                    foreach ($activities as $activity) {
                        $activity->update(['status' => 'CANCELLED']);
                        $activity->delete();
                    }
                });

                $message = "Successfully cleaned up {$count} incomplete sales activities.";
                $this->info($message);
                Log::info($message);
            } else {
                $this->info('No incomplete sales activities found to clean up.');
            }

            return 0;
        } catch (\Exception $e) {
            $errorMessage = "Error cleaning up sales activities: " . $e->getMessage();
            $this->error($errorMessage);
            Log::error($errorMessage);
            return 1;
        }
    }
)->purpose('Clean up incomplete sales activities from previous days')
    ->hourly(); // Or you can use ->dailyAt('00:01')
