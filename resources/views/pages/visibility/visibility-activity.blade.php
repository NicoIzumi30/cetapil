@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Visibility'" />
@endsection

@section('dashboard-content')
    <x-card>
        <x-slot:cardTitle>
            Detail Survey Activity
        </x-slot:cardTitle>
        <hr class="w-full border-dashed border">
        <table class="w-full mt-6">
            <tbody>
                <tr>
                    <td class="detail-title">Nama Outlet</td>
                    <td class="colon">:</td>
                    <td class="detail">{{ $salesActivity->outlet->name }}</td>
                    <td class="detail-title">Nama Sales</td>
                    <td class="colon">:</td>
                    <td class="detail">{{ $salesActivity->user->name }}</td>
                </tr>
                <tr>
                    <td class="detail-title">Kode Outlet</td>
                    <td class="colon">:</td>
                    <td class="detail">{{ $salesActivity->outlet->code }}</td>
                    <td class="detail-title">Tipe Outlet</td>
                    <td class="colon">:</td>
                    <td class="detail">{{ $salesActivity->outlet->tipe_outlet }}</td>
                </tr>
                <tr>
                    <td class="detail-title">Channel</td>
                    <td class="colon">:</td>
                    <td class="detail">{{ $salesActivity->outlet->channel }}</td>
                </tr>
            </tbody>
        </table>
        @php
            $primaryItems = $salesVisibility->where('type', 'PRIMARY');
            $secondaryItems = $salesVisibility->where('type', 'SECONDARY');
            $competitorItems = $salesVisibility->where('type', 'COMPETITOR');
        @endphp

        <x-section-card>
            <x-slot:title>Primary</x-slot:title>
            @foreach (['CORE', 'BABY'] as $category)
                <h2 class="font-bold text-2xl text-white mt-12">{{ $category }} </h2>
                <div class="grid grid-cols-2 gap-12 mt-6">
                    @foreach ($primaryItems->where('category', $category) as $item)
                        <div class="bg-glassmorphism p-4 rounded-lg">
                            <h2 class="font-bold text-2xl mb-8 text-white">{{ $item->category }} {{ $item->position }}
                            </h2>
                            <div class="grid gap-4 items-start">
                                <div class="grid grid-cols-2 gap-4 w-full text-white">
                                    <p class="font-bold text-sm">Jenis POSM : <span
                                            class="font-normal">{{ $item->posmType->name }}</span></p>
                                    <p class="font-bold text-sm">Lebar Rak : <span
                                            class="font-normal">{{ $item->shelf_width }}</span></p>
                                    <p class="font-bold text-sm">Jenis Visual : <span
                                            class="font-normal">{{ $item->visual_type }}</span></p>
                                    <p class="font-bold text-sm">Shelving: <span
                                            class="font-normal">{{ $item->shelving }}</span></p>
                                    <p class="font-bold text-sm">Condition: <span
                                            class="font-normal">{{ $item->condition }}</span></p>
                                </div>
                                <div>
                                    <h2 class="font-bold text-sm text-white mb-4">Foto Display:</h2>
                                    <img class="w-[500px] h-[500px] object-cover rounded-lg"
                                        src="{{ config('app.storage_url') . $item->display_photo }}" alt="Foto Display">
                                </div>
                            </div>
                        </div>
                    @endforeach
                </div>
            @endforeach
        </x-section-card>

        <x-section-card>
            <x-slot:title>Secondary</x-slot:title>
            <div class="grid grid-cols-2 gap-12 mt-12">
                @foreach (['CORE', 'BABY'] as $category)
                    @foreach ($secondaryItems->where('category', $category) as $item)
                        <div class="bg-glassmorphism p-4 rounded-lg">
                            <h2 class="font-semibold text-xl mb-8 text-white">{{ $item->category }} {{ $item->position }}
                            </h2>
                            <p class="font-bold text-sm mb-6 text-white">Jenis POSM : <span
                                    class="font-normal">{{ $item->posmType->name ?? '' }}</span></p>
                            <div>
                                <h2 class="font-bold text-sm text-white mb-4">Foto Display</h2>
                                <img class="w-[500px] h-[500px] object-cover rounded-lg"
                                    src="{{ config('app.storage_url') . $item->display_photo }}" alt="Foto Display">
                            </div>
                        </div>
                    @endforeach
                @endforeach
            </div>
        </x-section-card>

        <x-section-card>
            <x-slot:title>Competitor</x-slot:title>
            <div class="grid grid-cols-2 gap-12 mt-12">
                @foreach ($competitorItems as $item)
                    <div class="bg-glassmorphism p-4 rounded-lg">
                        <h2 class="font-semibold text-xl mb-6 text-white">{{ $item->category }} {{ $item->position }}
                        </h2>
                        <p class="font-bold text-sm mb-6 text-white">Nama Brand : <span
                                class="font-normal">{{ $item->competitor_brand_name ?? '' }}</span></p>
                        <p class="font-bold text-sm mb-6 text-white">Mekanisme Promo : <span
                                class="font-normal">{{ $item->competitor_promo_mechanism ?? '' }}</span></p>
                        <p class="font-bold text-sm mb-6 text-white">Mekanisme Promo : <span
                                class="font-normal">{{ $item->competitor_promo_mechanism ?? '' }}</span></p>
                        <p class="font-bold text-sm mb-6 text-white">Periode Promo : <span
                                class="font-normal">{{ $item->competitor_promo_start . ' - ' . $item->competitor_promo_end ?? '' }}</span>
                        </p>
                        <div class="grid grid-cols-2 gap-6">
                            <div>
                                <h2 class="font-bold text-sm text-white mb-4">Foto Program 1</h2>
                                <img class="max-w-[400px] w-full h-[350px] object-cover rounded-lg"
                                    src="{{ config('app.storage_url') . $item->display_photo }}" alt="Foto Display">
                            </div>
                            <div>
                                <h2 class="font-bold text-sm text-white mb-4">Foto Program 2</h2>
                                <img class="max-w-[400px] w-full h-[350px] object-cover rounded-lg"
                                    src="{{ config('app.storage_url') . $item->display_photo_2 }}" alt="Foto Display">
                            </div>
                        </div>
                    </div>
                @endforeach
            </div>
        </x-section-card>
    </x-card>
@endsection;
