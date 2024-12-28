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
                    <td class="detail">{{$salesActivity->outlet->name}}</td>
                    <td class="detail-title">Nama Sales</td>
                    <td class="colon">:</td>
                    <td class="detail">{{$salesActivity->user->name}}</td>
                </tr>
                <tr>
                    <td class="detail-title">Kode Outlet</td>
                    <td class="colon">:</td>
                    <td class="detail">{{$salesActivity->outlet->code}}</td>
                    <td class="detail-title">Tipe Outlet</td>
                    <td class="colon">:</td>
                    <td class="detail">{{$salesActivity->outlet->tipe_outlet}}</td>
                </tr>
                <tr>
                    <td class="detail-title">Channel</td>
                    <td class="colon">:</td>
                    <td class="detail">{{$salesActivity->outlet->channel}}</td>
                </tr>
            </tbody>
        </table>
        @php
    $primaryItems = $salesVisibility->where('type', 'PRIMARY');
    $secondaryItems = $salesVisibility->where('type', 'SECONDARY');
@endphp

<x-section-card>
    <x-slot:title>Primary</x-slot:title>
    @foreach(['CORE', 'BABY'] as $category)
        @foreach($primaryItems->where('category', $category) as $item)
            <div>
                <h2 class="font-semibold text-xl mb-8 text-white">{{ $item->category }} {{$item->position}}</h2>
                <div class="grid grid-cols-2 gap-2 items-start">
                    <div class="grid grid-cols-2 gap-4 w-full text-white">
                        <p class="font-bold text-sm">Jenis POSM : <span class="font-normal">{{$item->posmType->name}}</span></p>
                        <p class="font-bold text-sm">Lebar Rak : <span class="font-normal">{{$item->shelf_width}}</span></p>
                        <p class="font-bold text-sm">Jenis Visual : <span class="font-normal">{{$item->visual_type}}</span></p>
                        <p class="font-bold text-sm">Shelving: <span class="font-normal">{{$item->shelving}}</span></p>
                        <p class="font-bold text-sm">Condition: <span class="font-normal">{{$item->condition}}</span></p>
                    </div>
                    <div>
                        <h2 class="font-bold text-sm text-white mb-4">Foto Display</h2>
                        <img class="w-full" src="{{ config('app.storage_url').$item->display_photo}}" alt="Foto Display">
                    </div>
                </div>
            </div>
        @endforeach
    @endforeach
</x-section-card>

<x-section-card>
    <x-slot:title>Secondary</x-slot:title>
    <div class="grid gap-12">
        @foreach(['CORE', 'BABY'] as $category)
            @foreach($secondaryItems->where('category', $category) as $item)
                <div>
                    <h2 class="font-semibold text-xl mb-8 text-white">{{ $item->category }} {{$item->position}}</h2>
                    <p class="font-bold text-sm mb-6 text-white">Jenis POSM : <span class="font-normal">{{$item->posmType->name ?? ''}}</span></p>
                    <div>
                        <h2 class="font-bold text-sm text-white mb-4">Foto Display</h2>
                        <img class="w-[500px] h-[500px]" src="{{ config('app.storage_url').$item->display_photo }}" alt="Foto Display">
                    </div>
                </div>
            @endforeach
        @endforeach
    </div>
</x-section-card>
    </x-card>
@endsection;
