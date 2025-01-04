@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Routing'" />
@endsection

@section('dashboard-content')
    <x-card>
        <x-slot:cardTitle>
            Detail Sales Activity
        </x-slot:cardTitle>
        <hr class="w-full border-dashed border mb-4">
        <table class="w-full">
            <tbody>
                <tr>
                    <td class="detail-title">Nama Sales</td>
                    <td class="colon">:</td>
                    <td class="detail">{{ $salesActivity->user->name }}</td>
                    <td class="detail-title">Nama Outlet</td>
                    <td class="colon">:</td>
                    <td class="detail">{{ $salesActivity->outlet->name }}</td>
                </tr>
                <tr>
                    <td class="detail-title">Hari Kunjungan</td>
                    <td class="colon">:</td>
                    <td class="detail">{{ getVisitDayByNumber($salesActivity->outlet->visit_day) }}</td>
                    <td class="detail-title">Views</td>
                    <td class="colon">:</td>
                    <td class="detail">{{ $salesActivity->views_knowledge }}</td>
                </tr>
                <tr>
                    <td class="detail-title">Check-In</td>
                    <td class="colon">:</td>
                    <td class="detail">{{ $salesActivity->checked_in }}</td>
                    <td class="detail-title">Check-Out</td>
                    <td class="colon">:</td>
                    <td class="detail">Senin</td>
                </tr>
            </tbody>
        </table>
        <x-section-card>
            <x-slot:title>
                Formulir Survey
            </x-slot:title>
            <div class="grid gap-6 items-start">

                <div class="bg-glassmorphism p-4 rounded-lg">
                    <h2 class="survey-category-title">Apakah Power SKU Tersedia Ditoko?</h2>
                    <div class="grid gap-4">
                        @foreach ($salesSurvey as $survey)
                            <x-pages.routing.outlet-detail>
                                <x-slot:title>{{ $survey->survey->question }}</x-slot:title>
                                @if ($survey->survey->type == 'bool')
                                    <x-slot:value>{{ $survey->answer == 'true' ? 'Ada' : 'Tidak' }}</x-slot:value>
                                @else
                                    <x-slot:value>{{ $survey->answer }}</x-slot:value>
                                @endif
                            </x-pages.routing.outlet-detail>
                        @endforeach
                    </div>
                </div>

                <div class="bg-glassmorphism p-4 rounded-lg">
                    <h2 class="survey-category-title">Berapa Harga Power SKU Ditoko?</h2>
					<div class="grid gap-4">
                        <x-pages.routing.outlet-detail>
                            <x-slot:title>Cethapil Cleanser500 ML ru </x-slot:title>
                            <x-slot:value>Rp.500.000</x-slot:value>
                        </x-pages.routing.outlet-detail>
                        <x-pages.routing.outlet-detail>
                            <x-slot:title>Cethapil Cleanser500 ML ru </x-slot:title>
                            <x-slot:value>Rp.500.000</x-slot:value>
                        </x-pages.routing.outlet-detail>
                        <x-pages.routing.outlet-detail>
                            <x-slot:title>Cethapil Cleanser500 ML ru </x-slot:title>
                            <x-slot:value>Rp.500.000</x-slot:value>
                        </x-pages.routing.outlet-detail>
                    </div>
                </div>
				
                <div class="bg-glassmorphism p-4 rounded-lg">
                    <h2 class="survey-category-title">Berapa Harga Kompetitor Ditoko?</h2>
					<div class="grid gap-4">
                        <x-pages.routing.outlet-detail>
                            <x-slot:title>Cethapil Cleanser500 ML ru </x-slot:title>
                            <x-slot:value>Rp.500.000</x-slot:value>
                        </x-pages.routing.outlet-detail>
                        <x-pages.routing.outlet-detail>
                            <x-slot:title>Cethapil Cleanser500 ML ru </x-slot:title>
                            <x-slot:value>Rp.500.000</x-slot:value>
                        </x-pages.routing.outlet-detail>
                        <x-pages.routing.outlet-detail>
                            <x-slot:title>Cethapil Cleanser500 ML ru </x-slot:title>
                            <x-slot:value>Rp.500.000</x-slot:value>
                        </x-pages.routing.outlet-detail>
                    </div>
                </div>

                <div class="bg-glassmorphism p-4 rounded-lg">
                    <h2 class="survey-category-title">Survey Visibility</h2>
					<div class="grid gap-4">
                        <x-pages.routing.outlet-detail>
                            <x-slot:title>Cethapil Cleanser500 ML ru </x-slot:title>
                            <x-slot:value>Rp.500.000</x-slot:value>
                        </x-pages.routing.outlet-detail>
                        <x-pages.routing.outlet-detail>
                            <x-slot:title>Cethapil Cleanser500 ML ru </x-slot:title>
                            <x-slot:value>Rp.500.000</x-slot:value>
                        </x-pages.routing.outlet-detail>
                        <x-pages.routing.outlet-detail>
                            <x-slot:title>Cethapil Cleanser500 ML ru </x-slot:title>
                            <x-slot:value>Rp.500.000</x-slot:value>
                        </x-pages.routing.outlet-detail>
                    </div>
                </div>

                <div class="bg-glassmorphism p-4 rounded-lg">
                    <h2 class="survey-category-title">Survey Recommendation</h2>
					<div class="grid gap-4">
                        <x-pages.routing.outlet-detail>
                            <x-slot:title>Cethapil Cleanser500 ML ru </x-slot:title>
                            <x-slot:value>Rp.500.000</x-slot:value>
                        </x-pages.routing.outlet-detail>
                        <x-pages.routing.outlet-detail>
                            <x-slot:title>Cethapil Cleanser500 ML ru </x-slot:title>
                            <x-slot:value>Rp.500.000</x-slot:value>
                        </x-pages.routing.outlet-detail>
                        <x-pages.routing.outlet-detail>
                            <x-slot:title>Cethapil Cleanser500 ML ru </x-slot:title>
                            <x-slot:value>Rp.500.000</x-slot:value>
                        </x-pages.routing.outlet-detail>
                    </div>
                </div>
            </div>


        </x-section-card>
    </x-card>
@endsection

@push('styles')
    <style>
        .survey-category-title {
            font-weight: 700;
            font-size: 1.25rem;
            color: #efefef;
            margin-bottom: 1.5rem;
        }
    </style>
@endpush
