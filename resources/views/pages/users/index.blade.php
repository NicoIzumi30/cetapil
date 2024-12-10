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

    <table class="table" id="table_user">
        <thead>
            <tr>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="name">
                        {{ __('Nama') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="email">
                        {{ __('Email') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="position">
                        {{ __(key: 'Position') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="outlet_area">
                        {{ __(key: 'Outlet Area') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="status">
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
            @forelse($users as $user)
                {{-- Users Table --}}
                <tr class="table-row">
                    <td scope="row" class="table-data">
                        {{ $user->name }}
                    </td>
                    <td scope="row" class="table-data">
                        {{ $user->email }}
                    </td>
                    <td scope="row" class="table-data !text-[#70FFE2]">
                        {{ ucwords($user->roles[0]->name) }}
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
                                <a href="{{ route('users.destroy', $user->id) }}"
                                    class="delete-btn dropdown-option text-red-400 delete-user" data-id="{{ $user->id }}" data-name="{{$user->name}}">
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
{{-- Users End --}}

@endsection

@push('scripts')
    <script>
        $(document).ready(function () {
            $('#users-table').DataTable({
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
        $(document).ready(function () {
            $("#sales-date-range").flatpickr({
                mode: "range"

            });
            $(document).on('click', '#table_user .delete-btn', function (e) {
                e.preventDefault();
                const url = $(this).attr('href');
                const name = $(this).data('name');
                deleteData(url, name);
            });
        });
    </script>
@endpush