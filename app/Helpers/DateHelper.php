<?php

declare(strict_types=1);

use Carbon\Carbon;
use Carbon\CarbonInterface;

if (!function_exists('formatTanggalIndonesia')) {
    /**
     * 
     * @param CarbonInterface|string|null $date Tanggal yang akan diformat (null untuk tanggal sekarang)
     * @return string
     */
    function formatTanggalIndonesia(CarbonInterface|string|null $date = null): string 
    {
        Carbon::setLocale('id');
        
        if ($date === null) {
            return Carbon::now()->translatedFormat('l, d F Y');
        }
        
        if ($date instanceof CarbonInterface) {
            return $date->translatedFormat('l, d F Y');
        }
        
        return Carbon::parse($date)->translatedFormat('l, d F Y');
    }
}