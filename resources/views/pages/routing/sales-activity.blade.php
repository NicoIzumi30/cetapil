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
                    <td class="detail">CV Makmur Jaya Sentosa</td>
                    <td class="detail-title">Nama Outlet</td>
                    <td class="colon">:</td>
                    <td class="detail">selphi@example.mail</td>
                </tr>
                <tr>
                    <td class="detail-title">Hari Kunjungan</td>
                    <td class="colon">:</td>
                    <td class="detail">Selphi Nusawati Indira</td>
                    <td class="detail-title">Views</td>
                    <td class="colon">:</td>
                    <td class="detail">081234567890</td>
                </tr>
                <tr>
                    <td class="detail-title">Check-In</td>
                    <td class="colon">:</td>
                    <td class="detail">Jln. Kebon Kelapa</td>
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
				<x-pages.routing.outlet-detail>
                    <x-slot:title>CETHAPIL Gentle Skin Cleanser 125ml</x-slot:title>
					<x-slot:value>Ada</x-slot:value>
                </x-pages.routing.outlet-detail>
                <x-pages.routing.outlet-detail>
                    <x-slot:title>Berapa banyak produk GIH yang sudah terjual?</x-slot:title>
					<x-slot:value>3</x-slot:value>
                </x-pages.routing.outlet-detail>
                <x-pages.routing.outlet-detail>
                    <x-slot:title>Selling out GSC500/week<span class="font-normal">(in pcs)</span></x-slot:title>
					<x-slot:value>25</x-slot:value>
                </x-pages.routing.outlet-detail>
                <x-pages.routing.outlet-detail>
                    <x-slot:title>Selling out GSC125/week<span class="font-normal">(in pcs)</span></x-slot:title>
					<x-slot:value>25</x-slot:value>
                </x-pages.routing.outlet-detail>
                <x-pages.routing.outlet-detail>
                    <x-slot:title>Selling out Oily 125/week<span class="font-normal">(in pcs)</span></x-slot:title>
					<x-slot:value>8</x-slot:value>
                </x-pages.routing.outlet-detail>
                <x-pages.routing.outlet-detail>
                    <x-slot:title>Selling out wash & shampo 400ml/week<span class="font-normal">(in
                            pcs)</span></x-slot:title>
							<x-slot:value>7</x-slot:value>
                </x-pages.routing.outlet-detail>
                <x-pages.routing.outlet-detail>
                    <x-slot:title>Selling out wash & shampo cal 400ml/week <span class="font-normal">(in
                            pcs)</span></x-slot:title>
							<x-slot:value>2</x-slot:value>
                </x-pages.routing.outlet-detail>
                <x-pages.routing.outlet-detail>
                    <x-slot:title>Selling out baby lotion cal 400ml/week <span class="font-normal">(in
                            pcs)</span></x-slot:title>
							<x-slot:value>5</x-slot:value>
                </x-pages.routing.outlet-detail>
                <x-pages.routing.outlet-detail>
                    <x-slot:title>Selling out baby lotion 400ml/week<span class="font-normal">(in
                            pcs)</span></x-slot:title>
							<x-slot:value>25</x-slot:value>
                </x-pages.routing.outlet-detail>
                <x-pages.routing.outlet-detail>
                    <x-slot:title>Selling out baby advance protection cream cal/week<span class="font-normal">(in
                            pcs)</span></x-slot:title>
							<x-slot:value>9</x-slot:value>
                </x-pages.routing.outlet-detail>
                <x-pages.routing.outlet-detail>
                    <x-slot:title>Selling out BHR night/week<span class="font-normal">(in pcs)</span></x-slot:title>
					<x-slot:value>25</x-slot:value>
                </x-pages.routing.outlet-detail>
                <x-pages.routing.outlet-detail>
                    <x-slot:title>Selling out BHR day protection/week<span class="font-normal">(in
                            pcs)</span></x-slot:title>
							<x-slot:value>50</x-slot:value>
                </x-pages.routing.outlet-detail>
                <x-pages.routing.outlet-detail>
                    <x-slot:title>Selling out BHR serum <span class="font-normal">(in pcs)</span></x-slot:title>
					<x-slot:value>25</x-slot:value>
                </x-pages.routing.outlet-detail>
			</div>
		</x-section-card>
    </x-card>
@endsection
