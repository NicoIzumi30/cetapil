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
            <x-input.search wire:model.live="search" class="border-0" id="global-search" placeholder="Cari data penjualan"></x-input.search>
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
        </table>
        {{-- Selling Table End --}}
    </x-card>
    {{-- Selling End --}}
@endsection

@push('scripts')
    <script>
        $(document).ready(function() {
            let table = $('#selling-table').DataTable({
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
                    processing: "Memuat data...",
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
                    url: "{{ route('selling.data') }}",
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
                    { data: 'waktu', name: 'waktu', className: 'table-data', },
                    { data: 'sales', name: 'sales', className: 'table-data', },
                    { data: 'outlet', name: 'outlet', className: 'table-data', },
                    {
                        data: 'actions',
                        name: 'actions',
                        orderable: false,
                        searchable: false
                    }
                ]
            });

            // Search dengan debounce
            let searchTimer;
            $('#global-search').on('input', function () {
                clearTimeout(searchTimer);
                searchTimer = setTimeout(() => table.ajax.reload(null, false), 500);
            });
        });
    </script>
@endpush
