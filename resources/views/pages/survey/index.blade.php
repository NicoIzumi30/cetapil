@extends('layouts.main')

@section('banner-content')
<x-banner-content :title="'Survey'" />
@endsection

@section('dashboard-content')
{{-- Users --}}
<x-card>
    <x-slot:cardTitle>
        Sales Activity
    </x-slot:cardTitle>
    {{-- Users Action --}}
    <x-slot:cardAction>
        <x-input.search id="global-search" class="border-0"
            placeholder="Cari data survey"></x-input.search>
			<x-button.info>Download</x-button.info>
    </x-slot:cardAction>
    {{-- Users Action End --}}

    <table class="table" id="table_survey">
        <thead>
            <tr>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="name">
                        {{ __('Nama Sales') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="email">
                        {{ __('Nama Outlet') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="position">
                        {{ __(key: 'Hari Kunjungan') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="outlet_area">
                        {{ __(key: 'Check-In') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="status">
                        {{ __('Check-Out') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="status">
                        {{ __('Views') }}
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
        $(document).ready(function() {
            let table = $('#table_survey').DataTable({
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
                    url: "{{ route('survey.data') }}",
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
                    { data: 'sales', name: 'sales', className: 'table-data', },
                    { data: 'outlet', name: 'outlet', className: 'table-data', },
                    { data: 'visit_day', name: 'visit_day', className: 'table-data', },
                    { data: 'checkin', name: 'checkin', className: 'table-data', },
                    { data: 'checkout', name: 'checkout', className: 'table-data', },
                    { data: 'views', name: 'views', className: 'table-data', },
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

