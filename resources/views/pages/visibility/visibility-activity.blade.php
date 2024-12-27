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
                    <td class="detail">Wisma 2</td>
                    <td class="detail-title">Nama Sales</td>
                    <td class="colon">:</td>
                    <td class="detail">runaskdnas</td>
                </tr>
                <tr>
                    <td class="detail-title">Kode Outlet</td>
                    <td class="colon">:</td>
                    <td class="detail">d</td>
                    <td class="detail-title">Tipe Outlet</td>
                    <td class="colon">:</td>
                    <td class="detail">d</td>
                </tr>
                <tr>
                    <td class="detail-title">Channel</td>
                    <td class="colon">:</td>
                    <td class="detail">d</td>
                </tr>
            </tbody>
        </table>
        <x-section-card>
            <x-slot:title>Primary</x-slot:title>
            <div>
                <h2 class="font-semibold text-xl mb-8 text-white">Core 1</h2>
                <div class="grid grid-cols-2 gap-2 items-start">
                    <div class="grid grid-cols-2 gap-4 w-full text-white">
                        <p class="font-bold text-sm">Jenis POSM : <span class="font-normal">Glofier</span></p>
                        <p class="font-bold text-sm">Lebar Rak : <span class="font-normal">Glofier</span></p>
                        <p class="font-bold text-sm">Jenis Visual : <span class="font-normal">Glofier</span></p>
                        <p class="font-bold text-sm">Shelving: <span class="font-normal">Glofier</span></p>
                        <p class="font-bold text-sm">Condition: <span class="font-normal">Glofier</span></p>
                    </div>
                    <div>
                        <h2 class="font-bold text-sm text-white mb-4">Foto Display</h2>
                        <img class="w-full " src="{{ asset('/assets/images/banner-placeholder.png') }}" alt="Foto Display">
                    </div>
                </div>
            </div>
            <div>
                <h2 class="font-semibold text-xl mb-8 text-white">Baby 1</h2>
                <div class="grid grid-cols-2 gap-2 items-start">
                    <div class="grid grid-cols-2 gap-4 w-full text-white">
                        <p class="font-bold text-sm">Jenis POSM : <span class="font-normal">Glofier</span></p>
                        <p class="font-bold text-sm">Lebar Rak : <span class="font-normal">Glofier</span></p>
                        <p class="font-bold text-sm">Jenis Visual : <span class="font-normal">Glofier</span></p>
                        <p class="font-bold text-sm">Shelving: <span class="font-normal">Glofier</span></p>
                        <p class="font-bold text-sm">Condition: <span class="font-normal">Glofier</span></p>
                    </div>
                    <div>
                        <h2 class="font-bold text-sm text-white mb-4">Foto Display</h2>
                        <img class="w-full " src="{{ asset('/assets/images/banner-placeholder.png') }}" alt="Foto Display">
                    </div>
                </div>
            </div>
        </x-section-card>
		<x-section-card>
            <x-slot:title>Secondary</x-slot:title>
			<div class="grid gap-12">
				<div>
					<h2 class="font-semibold text-xl mb-4 text-white">Core 1</h2>
						<p class="font-bold text-sm mb-6 text-white">Jenis POSM : <span class="font-normal">Glofier</span></p>
						<div>
							<h2 class="font-bold text-sm text-white mb-4">Foto Display</h2>
							<img class="w-[500px] h-[500px]" src="{{ asset('/assets/images/banner-placeholder.png') }}" alt="Foto Display">
						</div>
				</div>
				<div>
					<h2 class="font-semibold text-xl mb-8 text-white">Baby 1</h2>
						<p class="font-bold text-sm mb-6 text-white">Jenis POSM : <span class="font-normal">Glofier</span></p>
						<div>
							<h2 class="font-bold text-sm text-white mb-4">Foto Display</h2>
							<img class="w-[500px] h-[500px]" src="{{ asset('/assets/images/banner-placeholder.png') }}" alt="Foto Display">
						</div>
				</div>
			</div>
        </x-section-card>
    </x-card>
@endsection;
