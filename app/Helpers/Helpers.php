<?php

use App\Models\Av3m;
use App\Models\City;
use App\Models\User;
use App\Models\Outlet;
use App\Models\Channel;
use App\Models\Product;
use App\Models\Category;
use App\Models\PosmType;
use App\Models\OutletForm;
use App\Models\VisualType;
use Illuminate\Support\Arr;
use App\Models\OutletRouting;

if (!function_exists('getOutletByName')) {
    function getOutletByName($name)
    {
        return Outlet::where('name', $name)->first();
    }
}
if (!function_exists('getOutletByCode')) {
    function getOutletByCode($code)
    {
        return Outlet::withTrashed()->where('code', $code)->first();
    }
}

if (!function_exists('getProductBySku')) {
    function getProductBySku($sku)
    {
        return Product::where('sku', $sku)->first();
    }
}
if (!function_exists('getProvinceCodeByCityName')) {
    function getProvinceCodeByCityName($name)
    {
        $city = City::where('name', $name)->first();
        if (empty($city)) {
            return null;
        }
        return $city->province_code;
    }
}
if (!function_exists('getAv3m')) {
    function getAv3m($outletId,$productId)
    {
        $av3m = Av3m::select('av3m')->where('outlet_id', $outletId)->where('product_id', $productId)->first();
        if (empty($av3m)) {
            return '0';
        }
        $av3mValue = $av3m->av3m;
        if($av3mValue == 0){
            $av3mValue = '0';
        }
        return $av3mValue;
    }
}
if (!function_exists('getChannelByName')) {
    function getChannelByName($name)
    {
        return Channel::where('name', $name)->first();
    }
}
if (!function_exists('getCityByName')) {
    function getCityByName($name)
    {
        return City::where('name', $name)->first();
    }
}

if (!function_exists('getPosmByName')) {
    function getPosmByName($name)
    {
        return PosmType::where('name', $name)->first();
    }
}

if (!function_exists('getCapaigenByName')) {
    function getCapaigenByName($name)
    {
        return VisualType::where('name', $name)->first();
    }
}

if (!function_exists('getUserByName')) {
    function getUserByName($name)
    {
        return User::where('name', $name)->first();
    }
}

if (!function_exists('getOutletFormByQuestion')) {
    function getOutletFormByQuestion($question)
    {
        return OutletForm::where('question', $question)->first();
    }
}

if (!function_exists('getCategoryByName')) {
    function getCategoryByName($name)
    {
        return Category::where('name', $name)->first();
    }
}

if (!function_exists('getVisitDayByDay')) {
    function getVisitDayByDay($nameDay)
    {
        $day = [
            'SENIN' => '1',
            'SELASA' => '2',
            'RABU' => '3',
            'KAMIS' => '4',
            'JUMAT' => '5',
            'SABTU' => '6',
            'MINGGU' => '7',
        ];

        return Arr::get($day, $nameDay) ?? null
        ;
    }
}
if (!function_exists('getAllDay')) {
    function getAllDay()
    {
        $day = [
            'SENIN' => '1',
            'SELASA' => '2',
            'RABU' => '3',
            'KAMIS' => '4',
            'JUMAT' => '5',
            'SABTU' => '6',
            'MINGGU' => '7',
        ];

        return $day;
    }
}
if (!function_exists('getVisitDayByNumber')) {
    function getVisitDayByNumber($numberDay)
    {
        $day = [
            '1' => 'Senin',
            '2' => 'Selasa',
            '3' => 'Rabu',
            '4' => 'Kamis',
            '5' => 'Jumat',
            '6' => 'Sabtu',
            '7' => 'Minggu',
        ];

        return Arr::get($day, $numberDay) ?? 'Minggu';
    }
}
if (!function_exists('getVisitDays')) {
    function getVisitDays($outletId)
    {
        $query = OutletRouting::where('outlet_id', $outletId)
            ->orderBy('visit_day')
            ->groupBy('visit_day')
            ->pluck('visit_day')
            ->map(fn($value) => getVisitDayByNumber($value))
            ->implode(', ');

        return $query;

    }
}
if (!function_exists('getWeeks')) {
    function getWeeks($outletId)
    {
        $query = OutletRouting::where('outlet_id', $outletId)
            ->orderBy('week')
            ->groupBy('week')
            ->pluck('week')
            ->implode(', ');
        return $query;

    }
}
if (!function_exists('updatePhotoVisibility')) {
    function updatePhotoVisibility($request, $img, $data)
    {
        $file = $request->file($img);
        $fileName = "{$img}.jpeg";
        $path = "/images/visibilities/{$fileName}";
        $file->storeAs('public', $path);

        foreach ($data as $value) {
            $value->update(['filename' => $fileName, 'path' => $path]);
        }
    }
}
if (!function_exists('getStatusBadge')) {
    function getStatusBadge($status)
    {
        $colors = [
            'PENDING' => 'bg-blue-400',
            'REJECTED' => 'bg-red-500',
            // tambahkan status lain jika ada
        ];

        $bgColor = $colors[$status] ?? 'bg-gray-400';

        return '<div class="rounded-full py-2 px-4 font-bold w-fit ' . $bgColor . '">' .
            e($status) .
            '</div>';
    }
}
if (!function_exists('spanColor')) {
    function spanColor($value, $color)
    {
        return '<span class="text-' . $color . '-400">' .
            e($value) .
            '</span>';
    }
}
if (!function_exists('csv_to_array')) {
    function csv_to_array($filename, $header)
    {
        $delimiter = ',';
        if (!file_exists($filename) || !is_readable($filename)) {
            return false;
        }

        $data = [];
        if (($handle = fopen($filename, 'r')) !== false) {
            while (($row = fgetcsv($handle, 1000, $delimiter)) !== false) {
                $data[] = array_combine($header, $row);
            }
            fclose($handle);
        }

        return $data;
    }
}

