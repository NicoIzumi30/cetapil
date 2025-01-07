<?php

namespace App\Providers;

use App\Models\SalesVisibility;
use App\Models\SalesAvailability;
use App\Services\FileUploadService;
use Illuminate\Pagination\Paginator;
use Illuminate\Support\ServiceProvider;
use App\Observers\SalesVisibilityObserver;
use App\Observers\SalesAvailabilityObserver;


class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register()
    {
        $this->app->singleton(FileUploadService::class, function ($app) {
            return new FileUploadService();
        });
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
		Paginator::useTailwind();
        SalesAvailability::observe(SalesAvailabilityObserver::class);
        SalesVisibility::observe(SalesVisibilityObserver::class);
    }
}
