@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Routing'" />
@endsection

@section('dashboard-content')
<main class="w-full">
	<x-card>
		<x-slot:cardTitle>
		Routing Outlet
	</x-slot:cardTitle>

	<x-slot:cardAction>
		<x-input.search wire:model.live="search" class="border-0" col="col-3"
			placeholder="Cari data sales"></x-input.search>
		<div class="col-2 mx-3">
			<select id="day" name="day" wire:model.change="day" class="form-select">
				<option value="" selected>
					Filter Hari
				</option>
				{{-- @foreach ($days as $key => $option)
					<option value="{{ $key }}">
						{{ $option }}
					</option>
				@endforeach --}}
			</select>
		</div>
		<x-button.light wire:click="download" wire:loading.attr="disabled"
			class="col-2 mx-3">Download</x-button.light>
		<x-button.info href="/routing/request" wire:navigate class="col-2 mx-3 d-flex justify-content-center">
			{{-- Need Approval <span class="badge bg-white text-primary ms-1">{{ $totalNoo }}</span> --}}
		</x-button.info>
		<x-button.light href="/routing/avg-three-month" class="col-1">A3VM</x-button.light>
		<x-button.light href="/routing/create" class="col-3 mx-3">Tambah Daftar Outlet</x-button.light>
	</x-slot:cardAction>
	</x-card>
	</main
@endsection
