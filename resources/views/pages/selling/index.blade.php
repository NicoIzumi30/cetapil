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
            <x-button.info href="/routing/create">Tambah Penjualan</x-button.info>
            <x-button.info>Download</x-button.info>
        </x-slot:cardAction>
        {{-- Selling Action End --}}
		
        {{-- Selling Table --}}
        <table class="table">
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
                                <button onclick="openModal('') class="dropdown-option ">Lihat
                                                        Data</button>
                                                </li>
                                                <li>
                                                    <a href="#" class="dropdown-option text-red-400">Hapus
                                                        Data</a>
                                                </li>
                                    </x-action-table-dropdown>
                 </td>
                </tr>
              </tbody>
             </table>
             {{-- {{ $items->links() }} --}}
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
        });
</script>
@endpush
