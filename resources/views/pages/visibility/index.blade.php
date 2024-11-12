@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Visibility'" />
@endsection

@section('dashboard-content')
    {{-- Users --}}
    <x-card>
        <x-slot:cardTitle>
            Daftar Visibility
        </x-slot:cardTitle>
        {{-- Users Action --}}
        <x-slot:cardAction>
            <x-input.search wire:model.live="search" class="border-0" placeholder="Cari data produk"></x-input.search>
            <x-select.light :title="'Filter Jenis Visibility'" id="day" name="day">
                <option value="senin">
                    senin
                </option>
            </x-select.light>
            <x-button.info href="/routing/avg-three-month">Update Foto</x-button.info>
            <x-button.info href="/routing/create">Tambah Visibility</x-button.info>
        </x-slot:cardAction>
        {{-- Users Action End --}}

        {{-- Users Table --}}
        <table class="table">
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
             {{-- Users Table End --}}
        </x-card>
     {{-- Users End --}}
     
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
