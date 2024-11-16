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

    <table class="table">
        <thead>
            <tr>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="name">
                        <{{ __('name') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="email">
                        {{ __('email') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="position">
                    {{ __(key: 'position') }}
                    <x-icons.sort />
                    </a>
                </th>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="outlet_area">
                    {{ __(key: 'outlet_area') }}
                    <x-icons.sort />
                    </a>
                </th>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="status">
                    {{ __('active') }}
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
            @forelse($users as $user)
                <tr class="table-row">
                    <td scope="row" class="table-data">
                        {{ $user->name }}
                    </td>
                    <td scope="row" class="table-data">
                        {{ $user->email }}
                    </td>
                    <td scope="row" class="table-data !text-[#70FFE2]">
                        {{ $user->roles[0]->name }}
                    </td>
                    <td scope="row" class="table-data !text-[#70FFE2]">
                        {{ $user->longitude . ', ' . $user->latitude }}
                    </td>
                    <td scope="row" class="table-data">
                        {{ ($user->active == 1 ? 'Aktif' : 'Tidak Aktif') }}
                    </td>
                    <td class="table-data">
                        <x-action-table-dropdown>
                            <li>
                                <a href="{{ route('users.edit', $user->id) }}" class="dropdown-option">
                                    Lihat Data
                                </a>
                            </li>
                            <li>
                                <a href="#" class="dropdown-option text-red-400 delete-user" data-id="{{ $user->id }}">
                                    Hapus Data
                                </a>
                            </li>
                        </x-action-table-dropdown>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="6" class="text-center py-4">
                        Tidak ada data yang ditemukan
                    </td>
                </tr>
            @endforelse
        </tbody>
    </table>

    {{ $users->links() }}
    {{-- Users Table End --}}
</x-card>
{{-- Users End --}}
@endsection

@push('scripts')
    <script>
        $(document).ready(function () {
            $("#sales-date-range").flatpickr({
                mode: "range"
            });
        });
    </script>
@endpush