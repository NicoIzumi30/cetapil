<?php

namespace App\Traits;

trait OutletTrait
{
    public function getCityName(string $city): string {
        $cityName = strtolower($city);
        $cityName = removeSubstring($cityName, 'kota');
        $substringToFind = "kab";

        if (containsSubstring($cityName, $substringToFind)) {
            $cityName = removeSubstring($cityName, 'kab');
            $cityName = "kabupaten " . $cityName;
        }

        return ucwords($cityName);
    }
}
