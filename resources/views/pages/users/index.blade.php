@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Pengguna'" />
@endsection

@section('dashboard-content')
    {{-- Users --}}
    <x-card>
        <x-slot:cardTitle>
            Manajemen Pengguna
        </x-slot:cardTitle>
        {{-- Users Action --}}
        <x-slot:cardAction>
            <x-button.info href="/users/create">Tambah Pengguna</x-button.info>
        </x-slot:cardAction>
        {{-- Users Action End --}}

        {{-- Users Table --}}
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
                            {{ __('Alamat Email') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Jabatan') }}
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
                            {{ __('Status') }}
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
                    <td scope="row" class="table-data !text-[#70FFE2]">
                        halo
                    </td>
                    <td scope="row" class="table-data">
                        halo
                    </td>
                    <td class="table-data">
                        <x-action-table-dropdown>
                            <li>
                                <a href="/users/edit" class="dropdown-option">Lihat
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
