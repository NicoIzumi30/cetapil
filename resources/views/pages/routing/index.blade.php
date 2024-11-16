@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Routing'" />
@endsection

@section('dashboard-content')
    {{-- Routing --}}
    <x-card>
        <x-slot:cardTitle>
            Routing Outlet
        </x-slot:cardTitle>
        {{-- Routing Action --}}
        <x-slot:cardAction>
            <x-input.search wire:model.live="search" class="border-0" placeholder="Cari data sales"></x-input.search>
            <x-select.light :title="'Filter Hari'" id="day" name="day">
                <option value="senin">
                    senin
                </option>
            </x-select.light>
            <x-button.light>Download</x-button.light>
            <x-button.light href="/routing/request" class="!text-white !bg-[#39B5FF] py-2">
                Need Approval <span class="py-1 px-2 ml-2 rounded-md bg-white text-primary">4</span>
            </x-button.light>
            <x-button.info href="/routing/avg-three-month">AV3M</x-button.info>
            <x-button.info href="/routing/create">Tambah Daftar Outlet</x-button.info>
        </x-slot:cardAction>
        {{-- Routing Action End --}}

        {{-- Routing Table --}}
        <table class="table">
            <thead>
                <tr>
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
                            {{ __('Area Outlet') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Hari Kunjungan') }}
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
                    <td scope="row" class="table-data !text-[#70FFE2]">
                        halo
                    </td>
                    <td scope="row" class="table-data">
                        halo
                    </td>
                    <td class="table-data">
                        <x-action-table-dropdown>
                            <li>
                                <a href="/routing/edit" class="dropdown-option">Lihat
                                    Data</a>
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
        {{-- Routing Table End --}}
    </x-card>
    {{-- Routing End --}}

    {{-- Sales Activity --}}
    <x-card>
        <x-slot:cardTitle>
            Sales Activity
        </x-slot:cardTitle>
        {{-- Sales Activity Action --}}
        <x-slot:cardAction>
            <x-input.search wire:model.live="search" class="border-0" placeholder="Cari data sales"></x-input.search>
            <x-select.light :title="'Filter Hari'" id="day" name="day">
                <option value="senin">
                    senin
                </option>
            </x-select.light>
            <x-select.light :title="'Filter Area'" id="area" name="area">
                <option value="senin">
                    senin
                </option>
            </x-select.light>
            <x-input.datepicker id="sales-date-range"></x-input.datepicker>
            <x-button.info>Download</x-button.info>
        </x-slot:cardAction>
        {{-- Sales Activity Action End --}}

        {{-- Sales Activity Table --}}
        <table class="table">
            <thead>
                <tr>
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
                            {{ __('Hari Kunjungan') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Check-In') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Check-Out') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            Views
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
                    <td scope="row" class="table-data !text-[#70FFE2]">
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
                                <button onclick="openModal('') class="dropdown-option ">Lihat
                                        Data</a>
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
            {{-- Sales Activity Table End --}}
        </x-card>
        {{-- Sales Activity End --}}
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
