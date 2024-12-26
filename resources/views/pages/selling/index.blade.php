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
                <x-input.search wire:model.live="search" class="border-0" placeholder="Cari data penjualan"></x-input.search>
                <x-button.light id="downloadBtn">
                    <span id="downloadBtnText">Download</span>
                    <span id="downloadBtnLoading" class="hidden">Downloading...</span>
                </x-button.light>
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
                    { data: 'total', name: 'total', className: 'table-data', },
                    {
                        data: 'actions',
                        name: 'actions',
                        orderable: false,
                        searchable: false
                    }
                ]

            });

          // Download button functionality
$('#downloadBtn').click(function(e) {
    e.preventDefault();
    
    // Show loading state
    const btn = $(this);
    const btnText = $('#downloadBtnText');
    const btnLoading = $('#downloadBtnLoading');
    
    btnText.addClass('hidden');
    btnLoading.removeClass('hidden');
    btn.prop('disabled', true);

    const form = document.createElement('form');
    form.method = 'GET';
    form.action = '{{ route("selling.download") }}';
    document.body.appendChild(form);

    fetch('{{ route("selling.download") }}')
        .then(response => {
            if (response.ok) {
                form.submit();
                toast('success', 'File berhasil diunduh', 300);
            } else {
                return response.json().then(data => {
                    throw new Error(data.message || 'Gagal mengunduh file');
                });
            }
        })
        .catch(error => {
            console.error('Download error:', error);
            toast('error', error.message || 'Gagal mengunduh file', 200);
        })
        .finally(() => {
            setTimeout(() => {
                btnText.removeClass('hidden');
                btnLoading.addClass('hidden');
                btn.prop('disabled', false);
                document.body.removeChild(form);
            }, 1000);
        });
});
        </script>
    @endpush