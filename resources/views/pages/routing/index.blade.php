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
        <x-input.search id="global-search" class="border-0" placeholder="Cari data sales"></x-input.search>
        <x-select.light :title="'Filter Hari'" id="day" name="day">
            <option value="senin">
                senin
            </option>
        </x-select.light>
        <x-button.light>Download</x-button.light>
        <x-button.light href="/routing/request" class="!text-white !bg-[#39B5FF] py-2">
            Need Approval <span class="py-1 px-2 ml-2 rounded-md bg-white text-primary">4</span>
        </x-button.light>
        <x-button.info onclick="openModal('upload-product-knowledge')">Upload Product knowledge</x-button.info>
        <x-modal id="upload-product-knowledge">
            <x-slot:title>Upload Product Knowledge</x-slot:title>
            <div class="flex gap-4 w-full">
                <div class="w-full">
                    <label for="pamflet_file" class="!text-black">
                        Unggah Pamflet
                        <div id="pamfletFileUpload" class="flex mt-2">
                            <input type="text" id="pamfletFileNameDisplay" readonly disabled
                                class="form-control mt-0 border-r-none"
                                placeholder="Unggah product knowledge berupa file pdf"
                                aria-describedby="pamflet file name display">
                            <div
                                class="bg-primary text-white align-middle p-3 rounded-r-md cursor-pointer -translate-x-2">
                                Browse</div>
                        </div>
                        <input type="file" id="pamflet_file" name="pamflet_file" class="form-control hidden"
                            accept="application/pdf" aria-label="Unggah product knowledge berupa file pdf">
                    </label>
                </div>
                <div class="w-full">
                    <label for="video_file" class="!text-black">
                        Unggah Video
                        <div id="fileUpload" class="flex mt-2">
                            <input type="text" id="videofileNameDisplay" readonly disabled
                                class="form-control mt-0 border-r-none"
                                placeholder="Unggah product knowledge berupa file mp4"
                                aria-describedby="video file name display">
                            <div
                                class="bg-primary text-white align-middle p-3 rounded-r-md cursor-pointer -translate-x-2">
                                Browse</div>
                        </div>
                        <input type="file" id="video_file" name="video_file" class="form-control hidden"
                            accept="video/mp4,video/*" aria-label="Unggah product knowledge berupa file mp4">
                    </label>
                </div>
            </div>
            <x-slot:footer>
                <x-button.info class="w-full">Upload</x-button.info>
            </x-slot:footer>
        </x-modal>
        <x-button.info href="/routing/create">Tambah Daftar Outlet</x-button.info>
    </x-slot:cardAction>
    {{-- Routing Action End --}}

    {{-- Routing Table --}}
    <table id="routing-table" class="table">
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
    </table>
    {{-- Delete Modal --}}
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
    <table id="sales-table" class="table">
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
                            <a href="/routing/sales-activity" class="dropdown-option">Lihat
                                Data</a>
                        </li>
                        <li>
                            <button onclick="openModal('delete-sales-activity')"
                                class="dropdown-option text-red-400">Hapus
                                Data</button>
                        </li>
                    </x-action-table-dropdown>
                </td>
            </tr>
        </tbody>
    </table>
    {{-- Delete Modal --}}
    <x-modal id="delete-sales-activity">
        <x-slot:title>Hapus Sales Activity</x-slot:title>
        <p>Apakah kamu yakin Ingin Menghapus data Sales Activity ini?</p>
        <x-slot:footer>
            <x-button.light onclick="closeModal('delete-sales-activity')"
                class="border-primary border">Batal</x-button.light>
            <x-button.light class="!bg-red-400 text-white border border-red-400">Hapus Data</x-button.light>
        </x-slot:footer>
    </x-modal>
    {{-- Sales Activity Table End --}}
</x-card>
{{-- Sales Activity End --}}
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

@push('scripts')
    <script>
        $(document).ready(function () {
            let table = $('#routing-table').DataTable({
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
                    url: "{{ route('routing.data') }}",
                    data: function (d) {
                        d.search_term = $('#global-search').val();
                    },
                    dataSrc: function (json) {
                        $('.dataTables_length select').closest('.dataTables_length')
                            .find('label')
                            .html(`Menampilkan <select>${$('.dataTables_length select').html()}</select> dari ${json.recordsFiltered} data`);
                        return json.data;
                    }
                },
                columns: [
                    { data: 'sales', name: 'user.name', className: 'table-data' }, { data: 'outlet', name: 'name', className: 'table-data' }, { data: 'area', name: 'area', className: 'table-data' }, { data: 'visit_day', name: 'visit_day', className: 'table-data' },
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
            $(document).on('click', '#routing-table .delete-btn', function (e) {
                e.preventDefault();
                const url = $(this).attr('href');
                const name = $(this).data('name');
                deleteData(url, name);
            });
            $('#sales-table').DataTable({
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

@push('scripts')
    <script>
        document.getElementById('pamflet_file').addEventListener('change', function (e) {
            const fileName = e.target.files[0] ? e.target.files[0].name : 'No file selected';
            document.getElementById('pamfletFileNameDisplay').value = fileName;
        });
        document.getElementById('video_file').addEventListener('change', function (e) {
            const fileName = e.target.files[0] ? e.target.files[0].name : 'No file selected';
            document.getElementById('videofileNameDisplay').value = fileName;
        });
    </script>
@endpush