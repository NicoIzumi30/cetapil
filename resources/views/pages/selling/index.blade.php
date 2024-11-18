@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Selling'" />
@endsection

@section('dashboard-content')
    {{-- Selling --}}
    <x-card>
        <x-slot:cardTitle>
            Daftar Penjualan
        </x-slot:cardTitle>
        {{-- Selling Action --}}
        <x-slot:cardAction>
            <x-input.search wire:model.live="search" class="border-0" placeholder="Cari data penjualan"></x-input.search>
            <x-button.info href="/selling/create">Tambah Penjualan</x-button.info>
            <x-button.info>Download</x-button.info>
        </x-slot:cardAction>
        {{-- Selling Action End --}}

        {{-- Selling Table --}}
        <table id="selling-table" class="table">
            <thead>
                <tr>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Waktu/Tanggal') }}
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
                            {{ __('Nama Outlet') }}
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
                    <td class="table-data">
                        <x-action-table-dropdown>
                            <li>
                                <a class="dropdown-option" href="/selling/edit">
                                    Lihat Data
                                </a>
                            </li>
                            <li>
                                <button onclick="openModal('delete-selling')" class="dropdown-option text-red-400">Hapus
                                    Data</button>
                            </li>
                        </x-action-table-dropdown>
                    </td>
                </tr>
            </tbody>
        </table>
        <x-modal id="delete-selling">
			<x-slot:title>Hapus Selling</x-slot:title>
			<p>Apakah kamu yakin Ingin Menghapus Data Selling ini?</p>
			<x-slot:footer>
				<x-button.light onclick="closeModal('delete-selling')" class="border-primary border">Batal</x-button.light>
				<x-button.light class="!bg-red-400 text-white border border-red-400">Hapus Data</x-button.light>
			</x-slot:footer>
		</x-modal>
        {{-- Selling Table End --}}
    </x-card>
    {{-- Selling End --}}
@endsection

@push('scripts')
    <script>
        $(document).ready(function() {
            $("#sales-date-range").flatpickr({
                mode: "range"
            });
            $('#selling-table').DataTable({
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
