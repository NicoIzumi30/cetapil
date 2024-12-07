@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Visibility'" />
@endsection

@section('dashboard-content')
    <x-card>
        <x-slot:cardTitle>
            Daftar Visibility
        </x-slot:cardTitle>
        {{-- Visibility Action --}}
        <x-slot:cardAction>
            <x-input.search wire:model.live="search" class="border-0" placeholder="Cari data visibility"></x-input.search>
            <x-select.light :title="'Filter Jenis Visibility'" id="day" name="day">
                <option value="senin">
                    senin
                </option>
            </x-select.light>
            <x-button.info onclick="openModal('update-photo')">Update Foto</x-button.info>
            <x-button.info href="/visibility/create">Tambah Visibility</x-button.info>
        </x-slot:cardAction>
        {{-- Visibility Action End --}}

		<x-modal id="update-photo">
			<x:slot:title>Update Foto Visibility Berdasarkan Jenis POSM</x:slot:title>
				<div class="flex">
					<x-input.image class="!text-primary" id="backwall" name="backwall" label="Backwall"
						:max-size="5" />
					<x-input.image class="!text-primary" id="standee" name="standee" label="Standee"
						:max-size="5" />
					<x-input.image class="!text-primary" id="Glolifier" name="Glolifier" label="Glolifier"
						:max-size="5" />
					<x-input.image class="!text-primary" id="COC" name="COC" label="COC"
						:max-size="5" />
				</div>
			<x:slot:footer>
				<x-button.info class="w-full">Konfirmasi</x-button.info>
			</x:slot:footer>
		</x-modal>


		
        {{-- Visibility Table --}}
        <table id="visibility-table" class="table">
            <thead>
                <tr>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Nama Outlet') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Nama Sales') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('SKU') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Visual') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Status') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Jangka Waktu') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            Aksi
                        </a>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr class="table-row">
                    <td scope="row" class="table-data">
                        halo
                    </td>
                    <td scope="row" class="table-data">
                        halo
                    </td>
                    <td scope="row" class="table-data">
                        halo
                    </td>
                    <td scope="row" class="table-data">
                        halo
                    </td>
                    <td scope="row" class="table-data !text-[#70FFE2]">
                        halo
                    </td>
                    <td scope="row" class="table-data">
                        halo
                    </td>
                    <td class="table-data">
                        <x-action-table-dropdown>
                            <li>
                                <a href="/visibility/edit" class="dropdown-option">Lihat
                                    Data</a>
                            </li>
                            <li>
                                <button onclick="openModal('delete-visibility')" class="dropdown-option text-red-400">Hapus
                                    Data</button>
                            </li>
                        </x-action-table-dropdown>
                    </td>
                </tr>
            </tbody>
        </table>
		<x-modal id="delete-visibility">
			<x-slot:title>Hapus Visibility</x-slot:title>
			<p>Apakah kamu yakin Ingin Menghapus Data Pengguna ini?</p>
			<x-slot:footer>
				<x-button.light onclick="closeModal('delete-visibility')" class="border-primary border">Batal</x-button.light>
				<x-button.light class="!bg-red-400 text-white border border-red-400">Hapus Data</x-button.light>
			</x-slot:footer>
		</x-modal>
        {{-- Visibility Table End --}}
    </x-card>

	<x-card>
        <x-slot:cardTitle>
           Visibility Activity
        </x-slot:cardTitle>
        <x-slot:cardAction>
            <x-input.search wire:model.live="search" class="border-0" placeholder="Cari data visibility activity"></x-input.search>
			<x-button.info>Download</x-button.info>
			<x-input.datepicker id="visibility-activity-daterange"/>
        </x-slot:cardAction>

        <table id="visibility-activity-table" class="table">
            <thead>
                <tr>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Nama Outlet') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Nama Sales') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('SKU') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Visual') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Condition') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            Aksi
                        </a>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr class="table-row">
                    <td scope="row" class="table-data">
                        halo
                    </td>
                    <td scope="row" class="table-data">
                        halo
                    </td>
                    <td scope="row" class="table-data">
                        halo
                    </td>
                    <td scope="row" class="table-data">
                        halo
                    </td>
                    <td scope="row" class="table-data">
                        halo
                    </td>
                    <td class="table-data">
                        <x-action-table-dropdown>
                            <li>
                                <a href="/visibility/activity" class="dropdown-option">Lihat
                                    Data</a>
                            </li>
                            <li>
                                <button onclick="openModal('delete-visibility-activity')" class="dropdown-option text-red-400">Hapus
                                    Data</button>
                            </li>
                        </x-action-table-dropdown>
                    </td>
                </tr>
            </tbody>
        </table>
		<x-modal id="delete-visibility-activity">
			<x-slot:title>Hapus Visibility Activity</x-slot:title>
			<p>Apakah kamu yakin Ingin Menghapus Data Visibility Activity ini?</p>
			<x-slot:footer>
				<x-button.light onclick="closeModal('delete-visibility-activity')" class="border-primary border">Batal</x-button.light>
				<x-button.light class="!bg-red-400 text-white border border-red-400">Hapus Data</x-button.light>
			</x-slot:footer>
		</x-modal>
        {{-- Visibility Table End --}}
    </x-card>

@endsection

@push('scripts')
    <script>
        $(document).ready(function() {
            $("#visibility-activity-daterange").flatpickr({
                mode: "range"
            });
            $('#visibility-table').DataTable({
                paging: true,
                searching: false,
                info: true,
                pageLength: 10,
                lengthMenu: [10, 20, 30, 40, 50],
                dom: 'rt<"bottom-container"<"bottom-left"l><"bottom-right"p>>',
                language: {
                    lengthMenu: "Menampilkan _MENU_ dari 4,768 data",
                    paginate: {
                        previous: '<',
                        next: '>',
                        last: 'Terakhir',
                    }
                },
            });
            $('#visibility-activity-table').DataTable({
                paging: true,
                searching: false,
                info: true,
                pageLength: 10,
                lengthMenu: [10, 20, 30, 40, 50],
                dom: 'rt<"bottom-container"<"bottom-left"l><"bottom-right"p>>',
                language: {
                    lengthMenu: "Menampilkan _MENU_ dari 4,768 data",
                    paginate: {
                        previous: '<',
                        next: '>',
                        last: 'Terakhir',
                    }
                },
            });
        });
    </script>
@endpush
