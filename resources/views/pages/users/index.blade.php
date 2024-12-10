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
        <x-input.search wire:model.live="search" id="global-search" class="border-0"
            placeholder="Cari data pengguna"></x-input.search>
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
    </table>
</x-card>

@endsection

@push('scripts')
    <script>
           let table = $('#table_user').DataTable({
                processing: true,
                serverSide: true,
                paging: true,
                searching: false,
                info: true,
                pageLength: 10,
                lengthMenu: [10, 20, 30, 40, 50],
                dom: 'rt<"bottom-container"<"bottom-left"l><"bottom-right"p>>',
                language: {
                    lengthMenu: "Menampilkan _MENU_ dari _TOTAL_ data",
                    paginate: {
                        previous: '<',
                        next: '>',
                        last: 'Terakhir',
                    },
                    info: "Menampilkan _START_ sampai _END_ dari _TOTAL_ data",
                    infoEmpty: "Menampilkan 0 sampai 0 dari 0 data",
                    emptyTable: "Tidak ada data yang tersedia"
                },
                ajax: {
                    url: "{{ route('users.data') }}",
                    data: function (d) {
                        d.search_term = $('#global-search').val();
                    },
                    dataSrc: function (json) {
                        $('.dataTables_length select').closest('.dataTables_length')
                            .find('label')
                            .html(` <select>${$('.dataTables_length select').html()}</select> dari ${json.recordsFiltered} data`);
                        return json.data;
                    }
                },
                columns: [
                    { data: 'name', name: 'name', className: 'table-data', },

                    { data: 'email', name: 'email', className: 'table-data', },
                    { data: 'role', name: 'role', className: 'table-data', },
                    { data: 'outlet_area', name: 'outlet_area', className: 'table-data', },
                    { data: 'status', name: 'status', className: 'table-data', },
                    {
                        data: 'actions',
                        name: 'actions',
                        orderable: false,
                        searchable: false
                    }
                ]
            });
            let searchTimer;
            $('#global-search').on('input', function () {
                clearTimeout(searchTimer);
                searchTimer = setTimeout(() => table.ajax.reload(null, false), 500);
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