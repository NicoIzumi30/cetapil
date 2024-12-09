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
                <input id="outlet-name" value="{{ $data['outlet'] }}" class="form-control" type="text" name="outlet-name" aria-describedby="outlet-name" disabled />
            </div>
            <div>
                <label for="sales-name" class="form-label">Nama Sales</label>
                <input id="sales-name" value="{{$data['sales']}}" class="form-control" type="text" name="sales-name" aria-describedby="sales-name" disabled />
            </div>
            <div>
                <label for="product-sku" class="form-label">Produk SKU</label>
                <input id="product-sku" value="{{ $data['sku'] }}" class="form-control" type="text"
                    name="product-sku" aria-describedby="product-sku" disabled />
            </div>
            <div>
                <label for="visual" class="form-label">Visual</label>
                <input id="visual" value="{{ $data['visual'] }}" class="form-control" type="text" name="visual" aria-describedby="visual" disabled />
            </div>
            <div>
                <label for="program-date" class="form-label">Jangka Waktu Program</label>
                <input id="program-date" value="{{ $data['periode'] }}" class="form-control" type="text"
                    name="program-date" aria-describedby="program-date"
                    disabled />
            </div>
            <div>
                <label for="condition" class="form-label">Condition</label>
                <input id="condition" value="{{ $data['condition'] }}" class="form-control" type="text" name="condition"" aria-describedby="condition" disabled />
            </div>
        </div>

        <x-section-card>
            <x-slot:title>Actual Visibility</x-slot:title>
            <div class="flex flex-col items-center w-full gap-6">
                <div class="w-full relative">
                    <img id="actual-visibility-1" src="{{ asset($data['path1']) }}" alt="Actual Visibility 1"
                        class="w-full h-[260px] mx-auto rounded-lg object-cover" />
                </div>
                <div class="w-full relative">
                    <img id="actual-visibility-2" src="{{ asset($data['path2']) }}" alt="Actual Visibility 2"
                        class="w-full h-[260px] mx-auto rounded-lg object-cover" />
                        <!-- <img id="actual-visibility-2" src="{{ 'http://dev-cetaphil.i-am.host/storage'.$data['path2']}}" alt="Actual Visibility 2"
                        class="w-full h-[260px] mx-auto rounded-lg object-cover" /> -->
                </div>
            </div>
        </x-section-card>
    </x-card>
@endsection
