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
                <td class="detail">{{$salesActivity->user->name}}</td>
                <td class="detail-title">Nama Outlet</td>
                <td class="colon">:</td>
                <td class="detail">{{$salesActivity->outlet->name}}</td>
            </tr>
            <tr>
                <td class="detail-title">Hari Kunjungan</td>
                <td class="colon">:</td>
                <td class="detail">{{getVisitDayByNumber($salesActivity->outlet->visit_day)}}</td>
                <td class="detail-title">Views</td>
                <td class="colon">:</td>
                <td class="detail">{{$salesActivity->views_knowledge}}</td>
            </tr>
            <tr>
                <td class="detail-title">Check In</td>
                <td class="colon">:</td>
                <td class="detail">{{$salesActivity->checked_in}}</td>
                <td class="detail-title">Check Out</td>
                <td class="colon">:</td>
                <td class="detail">{{$salesActivity->checked_out}}</td>
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