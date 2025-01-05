@extends('layouts.main')

@section('banner-content')
<x-banner-content :title="'Routing'" />
@endsection

@section('dashboard-content')
<x-card>
    <x-slot:cardTitle>
        Daftar Request NOO
    </x-slot:cardTitle>
    <table id="request-table" class="table">
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
        $(document).ready(function () {
            $("#sales-date-range").flatpickr({
                mode: "range"
            });
            let table = $('#request-table').DataTable({
                processing: true,
                serverSide: true,
                paging: true,
                searching: false,
                info: true,
                pageLength: 10,
                lengthMenu: [10, 20, 30, 40, 50],
                dom: 'rt<"bottom-container"<"bottom-left"l><"bottom-right"p>>',
                language: {
                    lengthMenu: "Menampilkan _MENU_ ",
                    paginate: {
                        previous: '<',
                        next: '>',
                        last: 'Terakhir',
                    },

                },
                ajax: {
                    url: "{{ route('routing.request.data') }}",
                    dataSrc: function (json) {
                    const $labelElement = $('label[for="dt-length-0"]');
                    $labelElement.find('span').remove();
                    const recordInfo = `dari ${json.recordsFiltered} data`;
                    const $span = $('<span>').text(recordInfo).css({
                        color: 'white',
                        marginLeft: '5px',
                    });
                    $labelElement.append($span);
                    return json.data;
                }
                },
                columns: [
                    { data: 'outlet', name: 'name', className: 'table-data' },
                    { data: 'sales', name: 'user.name', className: 'table-data' },
                    { data: 'area', name: 'area', className: 'table-data', orderable: false },
                    { data: 'visit_day', name: 'visit_day', className: 'table-data' },
                    { data: 'status', name: 'status', className: 'table-data', escapeHtml: false },
                    {
                        data: 'actions',
                        name: 'actions',
                        orderable: false,
                        searchable: false
                    }
                ]
            });

            $(document).on('click', '#routing-table .delete-btn', function (e) {
                e.preventDefault();
                const url = $(this).attr('href');
                const name = $(this).data('name');
                deleteData(url, name);
            });
        });
    </script>
@endpush