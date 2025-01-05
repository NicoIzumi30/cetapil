	@extends('layouts.main')

	@section('banner-content')
	<x-banner-content :title="'Survey'" />
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
				<div class="bg-glassmorphism p-4 rounded-lg">
					<h2 class="survey-category-title">Apakah Power SKU Tersedia Ditoko?</h2>
					<div class="grid gap-4">
						@foreach($groupedSurveys['Availability'] ?? [] as $survey)
                        @if($survey->survey->category->title == 'Apakah POWER SKU tersedia di toko?')
                            <x-pages.routing.outlet-detail>
                                <x-slot:title>{{ $survey->survey->question }}</x-slot:title>
                                <x-slot:value>{{ $survey->answer === 'true' ? 'Ada' : 'Tidak' }}</x-slot:value>
                            </x-pages.routing.outlet-detail>
                        @endif
                    @endforeach
					</div>
				</div>

				<div class="bg-glassmorphism p-4 rounded-lg">
					<h2 class="survey-category-title">Berapa Harga Power SKU Ditoko?</h2>
					<div class="grid gap-4">
						@foreach($groupedSurveys['Availability'] ?? [] as $survey)
                        @if($survey->survey->category->title == 'Berapa harga POWER SKU di toko?')
                            <x-pages.routing.outlet-detail>
                                <x-slot:title>{{ $survey->survey->question }}</x-slot:title>
                                <x-slot:value>{{ $survey->answer }}</x-slot:value>
                            </x-pages.routing.outlet-detail>
                        @endif
                    @endforeach
					</div>
				</div>
				
				<div class="bg-glassmorphism p-4 rounded-lg">
					<h2 class="survey-category-title">Berapa Harga Kompetitor Ditoko?</h2>
					<div class="grid gap-4">
						@foreach($groupedSurveys['Availability'] ?? [] as $survey)
                        @if($survey->survey->category->title == 'Berapa harga kompetitor di toko?')
                            <x-pages.routing.outlet-detail>
                                <x-slot:title>{{ $survey->survey->question }}</x-slot:title>
                                <x-slot:value>{{ $survey->answer }}</x-slot:value>
                            </x-pages.routing.outlet-detail>
                        @endif
                    @endforeach
					</div>
				</div>

				<div class="bg-glassmorphism p-4 rounded-lg">
					<h2 class="survey-category-title">Survey Visibility</h2>
					<div class="grid gap-4">
						@foreach($groupedSurveys['Visibility'] ?? [] as $survey)
                        <x-pages.routing.outlet-detail>
                            <x-slot:title>{{ $survey->survey->question }}</x-slot:title>
                            <x-slot:value>{{ $survey->answer === 'true' ? 'Ada' : 'Tidak' }}</x-slot:value>
                        </x-pages.routing.outlet-detail>
                    @endforeach
					</div>
				</div>

				<div class="bg-glassmorphism p-4 rounded-lg">
					<h2 class="survey-category-title">Survey Recommendation</h2>
					<div class="grid gap-4">
						@foreach($groupedSurveys['Recommndation'] ?? [] as $survey)
                        <x-pages.routing.outlet-detail>
                            <x-slot:title>{{ $survey->survey->question }}</x-slot:title>
                            <x-slot:value>
                                @if($survey->survey->type === 'bool')
                                    {{ $survey->answer === 'true' ? 'Ada' : 'Tidak' }}
                                @else
                                    {{ $survey->answer }}
                                @endif
                            </x-slot:value>
                        </x-pages.routing.outlet-detail>
                    @endforeach
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
