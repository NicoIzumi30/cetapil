@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Visibility'" />
@endsection

@section('dashboard-content')
    <x-card>
        <x-slot:cardTitle>
            Detail Visibility Activity
        </x-slot:cardTitle>

        <div class="grid grid-cols-2 gap-6">
            <div>
                <label for="outlet-name" class="form-label">Nama Outlet</label>
                <input id="outlet-name" value="agus buntung" class="form-control" type="text" name="outlet-name"
                    placeholder="Masukan nama outlet" aria-describedby="outlet-name" disabled />
            </div>
            <div>
                <label for="sales-name" class="form-label">Nama Sales</label>
                <input id="sales-name" value="agus donasi" class="form-control" type="text" name="sales-name"
                    placeholder="Masukan nama sales" aria-describedby="sales-name" disabled />
            </div>
            <div>
                <label for="product-sku" class="form-label">Produk SKU</label>
                <input id="product-sku" value="gusmiftahmenghinapedagangesteh" class="form-control" type="text"
                    name="product-sku" placeholder="Masukan produk SKU" aria-describedby="product-sku" disabled />
            </div>
            <div>
                <label for="visual" class="form-label">Visual</label>
                <input id="visual" value="we do skin we do yours" class="form-control" type="text" name="visual"
                    placeholder="Masukan visual" aria-describedby="visual" disabled />
            </div>
            <div>
                <label for="program-date" class="form-label">Jangka Waktu Program</label>
                <input id="program-date" value="12-07-2024 - 13-07-2024" class="form-control" type="text"
                    name="program-date" placeholder="Masukan jangka waktu program" aria-describedby="program-date"
                    disabled />
            </div>
            <div>
                <label for="condition" class="form-label">Condition</label>
                <input id="condition" value="GOOD" class="form-control" type="text" name="condition"
                    placeholder="Masukan condition" aria-describedby="condition" disabled />
            </div>
        </div>

        <x-section-card>
            <x-slot:title>Actual Visibility</x-slot:title>
            <div class="flex flex-col items-center w-full gap-6">
                <div class="w-full relative">
                    <img id="actual-visibility-1" src="{{ asset('assets/images/banner-placeholder.png') }}" alt="Actual Visibility 1"
                        class="w-full h-[260px] mx-auto rounded-lg object-cover" />
                </div>
                <div class="w-full relative">
                    <img id="actual-visibility-2" src="{{ asset('assets/images/banner-placeholder.png') }}" alt="Actual Visibility 2"
                        class="w-full h-[260px] mx-auto rounded-lg object-cover" />
                </div>
            </div>
        </x-section-card>
    </x-card>
@endsection
