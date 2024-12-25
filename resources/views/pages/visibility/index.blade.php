@extends('layouts.main')

@section('banner-content')
<x-banner-content :title="'Visibility'" />
@endsection

@section('dashboard-content')
<x-card>
    <x-slot:cardTitle>
        Visibility Activity
    </x-slot:cardTitle>
    <x-slot:cardAction>
        <x-input.search wire:model.live="search" id="global-search-activity" class="border-0"
            placeholder="Cari data visibility activity"></x-input.search>
            <x-button.info id="downloadActivityBtn">
                <span id="downloadBtnText">Download</span>
                <span id="downloadBtnLoading" class="hidden">Downloading...</span>
            </x-button.info>
        <x-input.datepicker id="activity-date-range" value=""></x-input.datepicker>
    </x-slot:cardAction>

    <table id="activity-table" class="table">
        <thead>
            <tr>
                <th scope="col">
                    <a class="table-head">
                        {{ __('Nama Outlet') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col">
                    <a class="table-head">
                        {{ __('Nama Sales') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col">
                    <a class="table-head">
                        {{ __('Kode Outlet') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col">
                    <a class="table-head">
                        {{ __('Tipe Outlet') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col">
                    <a class="table-head">
                        {{ __('Channel') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col">
                    <a class="table-head">
                        Aksi
                    </a>
                </th>
            </tr>
        </thead>
    </table>
    {{-- Visibility Table End --}}
</x-card>
@endsection

@push('scripts')
    <script>
        $(document).ready(function () {
            $("#activity-date-range").flatpickr({
                mode: "range"
            });
            const form = $('#posmImageForm');
            const submitBtn = $('#submitPosmBtn');
            const btnText = $('#submitBtnText');
            const loadingText = $('#submitBtnLoading');

            let table = $('#visibility-table').DataTable({
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
                    url: "{{ route('visibility.data') }}",
                    data: function (d) {
                        d.search_term = $('#global-search').val();
                        d.filter_visibility = $('#posm-filter').val();
                    },
                    dataSrc: function (json) {
                        $('.dt-length select').closest('.dt-length')
                            .find('label')
                            .html(`Menampilkan <select  name="request-table_length" aria-controls="request-table" class="dt-input" id="dt-length-0">${$('.dt-length select').html()}</select> dari ${json.recordsFiltered} data`);
                        return json.data;
                    }
                },
                columns: [
                    { data: 'outlet', name: 'name', className: 'table-data' },
                    { data: 'sales', name: 'user.name', className: 'table-data' },
                    { data: 'product', name: 'product', className: 'table-data', orderable: false },
                    { data: 'visual', name: 'visual', className: 'table-data' },
                    { data: 'status', name: 'status', className: 'table-data', escapeHtml: false },
                    { data: 'periode', name: 'periode', className: 'table-data', escapeHtml: false },
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
            $('#posm-filter').on('change', function () {
                table.ajax.reload(null, false)
            });

            let tableActivity = $('#activity-table').DataTable({
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
                    url: "{{ route('visibility.activity.data') }}",
                    type: 'GET',
                    data: function (d) {
                        d.search_term = $('#global-search-activity').val();
                        d.date = $('#activity-date-range').val() == 'Date Range' ? '' : $('#activity-date-range').val();
                    }
                },
                columns: [
                    {
                        data: 'outlet',
                        name: 'outlet',
                        class: 'table-data'
                    },
                    {
                        data: 'sales',
                        name: 'sales',
                        class: 'table-data'
                    },
                   
                    {
                        data: 'code',
                        name: 'code',
                        class: 'table-data'
                    },
                    {
                        data: 'type',
                        name: 'type',
                        class: 'table-data'
                    },
                    {
                        data: 'channel',
                        name: 'channel',
                        class: 'table-data'
                    },
                    {
                        data: 'actions',
                        name: 'actions',
                        class: 'table-data',
                        orderable: false,
                        searchable: false
                    }
                ],
                order: [[0, 'asc']]
            });
            // Event Handlers for Sales Table
            $(document).on('change', '#dt-length-activity', function () {
                var length = $(this).val();
                tableActivity.page.len(length).draw();
            });

            let searchTimerSales;
            $('#global-search-activity').on('input', function () {
                clearTimeout(searchTimerSales);
                searchTimerSales = setTimeout(() => tableActivity.ajax.reload(null, false), 500);
            });


            $('#activity-date-range').on('change', function () {
                tableActivity.ajax.reload(null, false);
            });


            $(document).on('click', '#visibility-table .delete-btn', function (e) {
                e.preventDefault();
                const url = $(this).attr('href');
                const name = $(this).data('name');
                deleteData(url, name);
            });

            // Function untuk memuat gambar yang ada
            function loadExistingImages() {
                $.ajax({
                    url: "{{ route('posm.get-images') }}",
                    type: 'GET',
                    success: function (response) {
                        if (response.status === 'success' && response.data) {
                            response.data.forEach(function (item) {
                                const input = $(`#${item.input_name}`);
                                const inputContainer = input.closest('.image-input-container');

                                // Update preview container
                                inputContainer.find('.preview-container').html(`
                                    <div class="relative">
                                        <img src="${item.image_url}" class="h-20 w-20 object-cover rounded" />
                                        <button type="button" 
                                                onclick="removeImage(this)"
                                                class="absolute -top-2 -right-2 bg-white rounded-full p-1 shadow-md">
                                            <svg xmlns="http://www.w3.org/2000/svg" 
                                                 class="h-4 w-4 text-red-500" 
                                                 viewBox="0 0 20 20" 
                                                 fill="currentColor">
                                                <path fill-rule="evenodd" 
                                                      d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" 
                                                      clip-rule="evenodd" />
                                            </svg>
                                        </button>
                                    </div>
                                `);
                            });
                        }
                    }
                });
            }

            // Load gambar saat modal dibuka
            $(document).on('click', '[onclick="openModal(\'update-photo\')"]', function () {
                loadExistingImages();
            });

            // Handle form submission
            submitBtn.on('click', function (e) {
                e.preventDefault();

                btnText.addClass('hidden');
                loadingText.removeClass('hidden');
                submitBtn.prop('disabled', true);

                const formData = new FormData(form[0]);

                $.ajax({
                    url: "{{ route('posm.update-image') }}",
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    success: function (response) {
                        if (response.status === 'success') {
                            toast('success', response.message);
                            setTimeout(() => {
                                closeModal('update-photo');
                                window.location.reload();
                            }, 1500);
                        }
                    },
                    error: function (xhr) {
                        toast('error', xhr.responseJSON?.message || 'Terjadi kesalahan saat mengupload gambar');
                    },
                    complete: function () {
                        btnText.removeClass('hidden');
                        loadingText.addClass('hidden');
                        submitBtn.prop('disabled', false);
                    }
                });
            });

            // Handle file input change for preview
            $('input[type="file"]').on('change', function () {
                const file = this.files[0];
                if (file) {
                    if (file.size > 5 * 1024 * 1024) {
                        toast('error', 'Ukuran file tidak boleh lebih dari 5MB');
                        this.value = '';
                        return;
                    }

                    const reader = new FileReader();
                    const inputContainer = $(this).closest('.image-input-container');

                    reader.onload = function (e) {
                        inputContainer.find('.preview-container').html(`
                            <div class="relative">
                                <img src="${e.target.result}" class="h-20 w-20 object-cover rounded" />
                                <button type="button" 
                                        onclick="removeImage(this)"
                                        class="absolute -top-2 -right-2 bg-white rounded-full p-1 shadow-md">
                                    <svg xmlns="http://www.w3.org/2000/svg" 
                                         class="h-4 w-4 text-red-500" 
                                         viewBox="0 0 20 20" 
                                         fill="currentColor">
                                        <path fill-rule="evenodd" 
                                              d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" 
                                              clip-rule="evenodd" />
                                    </svg>
                                </button>
                            </div>
                        `);
                    };
                    reader.readAsDataURL(file);
                }
            });
        });

        // Function to remove image preview
        function removeImage(button) {
            const container = $(button).closest('.image-input-container');
            container.find('input[type="file"]').val('');
            container.find('.preview-container').empty();
        }

        $('#downloadActivityBtn').click(function(e) {
    e.preventDefault();
    
    // Get the current date filter
    const dateFilter = $('#activity-date-range').val();
    
    // Show loading state
    const $btn = $(this);
    const $btnText = $btn.find('#downloadBtnText');
    const $btnLoading = $btn.find('#downloadBtnLoading');
    
    $btnText.addClass('hidden');
    $btnLoading.removeClass('hidden');
    $btn.prop('disabled', true);

    // Create URL with date filter
    const url = "{{ route('visibility.download-activity') }}?" + new URLSearchParams({
        date: dateFilter === 'Date Range' ? '' : dateFilter
    }).toString();

    // Start download
    fetch(url)
        .then(response => {
            if (!response.ok) {
                return response.json().then(data => {
                    throw new Error(data.message || 'Gagal mengunduh file');
                });
            }
            return response.blob();
        })
        .then(blob => {
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'visibility_activity_' + new Date().toISOString().slice(0,19).replace(/[:]/g, '-') + '.xlsx';
            document.body.appendChild(a);
            a.click();
            window.URL.revokeObjectURL(url);
            document.body.removeChild(a);
            toast('success', 'File berhasil diunduh', 500);
        })
        .catch(error => {
            console.error('Download error:', error);
            toast('error', error.message || 'Gagal mengunduh file', 300);
        })
        .finally(() => {
            $btnText.removeClass('hidden');
            $btnLoading.addClass('hidden');
            $btn.prop('disabled', false);
        });
});
    </script>
@endpush