@extends('layouts.main')

@section('banner-content')
<x-banner-content :title="'Routing'" />
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
                <td class="detail-title">Nama Sales</td>
                <td class="colon">:</td>
                <td class="detail">Wisma 2</td>
                <td class="detail-title">Nama Outlet</td>
                <td class="colon">:</td>
                <td class="detail">runaskdnas</td>
            </tr>
            <tr>
                <td class="detail-title">Hari Kunjungan</td>
                <td class="colon">:</td>
                <td class="detail">d</td>
                <td class="detail-title">Views</td>
                <td class="colon">:</td>
                <td class="detail">d</td>
            </tr>
            <tr>
                <td class="detail-title">Check In</td>
                <td class="colon">:</td>
                <td class="detail">d</td>
                <td class="detail-title">Check Out</td>
                <td class="colon">:</td>
                <td class="detail">d</td>
            </tr>
        </tbody>
    </table>
    <x-section-card>
        <x-slot:title>Formulir Outlet</x-slot:title>
        <div class="grid gap-6 items-start">
            {{-- @foreach ($outletForms as $form) --}}
                <x-pages.routing.outlet-detail>
                    <x-slot:title>sdasdas</x-slot:title>
                    <x-slot:value>Data Tidak Tersedia</x-slot:value>
                </x-pages.routing.outlet-detail>
            {{-- @endforeach --}}

        </div>
    </x-section-card>
</x-card>
@endsection