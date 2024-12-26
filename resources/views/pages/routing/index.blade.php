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
            <x-select.light :title="'Filter Hari'" id="filter_day" name="day">
                <option value="all">Semua</option>
                @foreach ($waktuKunjungan as $hari)
                    <option value="{{ $hari['value'] }}">{{ $hari['name'] }}</option>
                @endforeach
            </x-select.light>
            <x-button.light id="downloadBtnRouting">
                <span id="downloadBtnTextRouting">Download</span>
                <span id="downloadBtnLoadingRouting" class="hidden">Downloading...</span>
            </x-button.light>
            <x-button.light href="/routing/request" class="!text-white !bg-[#39B5FF] py-2">
                Need Approval <span class="py-1 px-2 ml-2 rounded-md bg-white text-primary">{{ $countPending }}</span>
            </x-button.light>
            <x-button.info onclick="openModal('upload-product-knowledge')">Upload Product knowledge</x-button.info>
            <x-modal id="upload-product-knowledge">
                <x-slot:title>Upload Product Knowledge</x-slot:title>
                <form action="{{ route('update-product-knowledge') }}" method="POST" enctype="multipart/form-data">
                    @csrf
                    @method('PUT')
                    <div class="mb-6">
                        <label for="channel" class="!text-black">Channel</label>
                        <select id="channel" name="channel_id" class=" w-full">
                            <option value="" selected disabled>
                                -- Pilih Channel --
                            </option>
                            @foreach ($channels as $channel)
                                <option value="{{ $channel->id }}">{{ $channel->name }}</option>
                            @endforeach
                        </select>
                    </div>
                    <div class="flex gap-4 w-full">
                        <div class="w-full">
                            <label for="pamflet_file" class="!text-black">
                                Unggah Flyer
                                <div id="pamfletFileUpload" class="flex mt-2">
                                    <input type="text" id="pamfletFileNameDisplay" readonly disabled
                                        class="form-control mt-0 border-r-none"
                                        placeholder="Unggah product knowledge berupa file pdf"
                                        aria-describedby="pamflet file name display">
                                    <div
                                        class="bg-primary text-white align-middle p-3 rounded-r-md cursor-pointer -translate-x-2">
                                        Browse</div>
                                </div>
                                <input type="file" id="pamflet_file" name="file_pdf" class="form-control hidden"
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
                                <input type="file" id="video_file" name="file_video" class="form-control hidden"
                                    accept="video/mp4,video/*" aria-label="Unggah product knowledge berupa file mp4">
                            </label>
                        </div>
                    </div>
                    <x-slot:footer>
                        <x-button.info class="w-full" id="updateBtn">Upload</x-button.info>
                    </x-slot:footer>
                </form>
            </x-modal>
            <x-button.info href="/routing/create">Tambah Daftar Outlet</x-button.info>
        </x-slot:cardAction>
        {{-- Routing Action End --}}

        {{-- Update AV3M --}}
        <x-modal id="update-av3m">
            <x-slot:title>Update AV3M</x-slot:title>
            <form id="av3mForm" class="grid grid-cols-2 gap-6">
                @csrf
                @foreach ($channels as $channel)
                    <div>
                        <label for="channel{{ $channel->id }}" class="!text-black">{{ $channel->name }}</label>
                        <input id="channel-{{ $channel->id }}" class="form-control channer_{{ $loop->iteration }}"
                            type="text" name="channel_{{ $loop->iteration }}"
                            placeholder="Masukan A3M {{ $channel->name }}" aria-describedby="channel-{{ $channel->name }}"
                            value="">
                    </div>
                @endforeach

                <x-slot:footer>
                    <x-button.primary class="w-full" id="saveAv3mBtn">Simpan Perubahan</x-button.primary>
                </x-slot:footer>
            </form>
        </x-modal>
        {{-- END Update AV3M --}}

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
            <x-input.search wire:model.live="search" id="global-search-sales" class="border-0"
                placeholder="Cari data sales"></x-input.search>
            <x-select.light :title="'Filter Hari'" id="filter_day_sales" name="day">
                <option value="all">Semua</option>
                @foreach ($waktuKunjungan as $hari)
                    <option value="{{ $hari['value'] }}">{{ $hari['name'] }}</option>
                @endforeach
            </x-select.light>
            <x-select.light :title="'Filter Area'" id="filter_area" name="area">
                <option value="all">Semua</option>
                @foreach ($cities as $city)
                    <option value="{{ $city->id }}">{{ $city->name }}</option>
                @endforeach
            </x-select.light>
            <x-input.datepicker id="sales-date-range" value=""></x-input.datepicker>
            <x-button.light id="downloadBtnSalesActivity">
                <span id="downloadBtnTextSales">Download</span>
                <span id="downloadBtnLoadingSales" class="hidden">Downloading...</span>
            </x-button.light>
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
        </table>
    </x-card>
    {{-- Sales Activity End --}}
@endsection

@push('scripts')
    <script>
        $(document).ready(function() {
            $("#sales-date-range").flatpickr({
                mode: "range"
            });
            $('#channel').select2({
                minimumResultsForSearch: Infinity
            });
        });
    </script>
@endpush

@push('scripts')
    <script>
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
                data: function(d) {
                    d.search_term = $('#global-search').val();
                    d.filter_day = $('#filter_day').val();
                },
                dataSrc: function(json) {
                    $('#routing-table_wrapper .dt-length select').closest('.dt-length')
                        .find('label')
                        .html(
                            `Menampilkan <select  name="routing-table_length" aria-controls="routing-table" class="dt-input" id="dt-length-0">${$('.dt-length select').html()}</select> dari ${json.recordsFiltered} data`
                        );
                    return json.data;
                }
            },
            columns: [{
                    data: 'sales',
                    name: 'user.name',
                    className: 'table-data'
                }, {
                    data: 'outlet',
                    name: 'name',
                    className: 'table-data'
                }, {
                    data: 'area',
                    name: 'area',
                    className: 'table-data'
                }, {
                    data: 'visit_day',
                    name: 'visit_day',
                    className: 'table-data'
                },
                {
                    data: 'actions',
                    name: 'actions',
                    orderable: false,
                    searchable: false
                }
            ]
        });
        $(document).on('change', '#dt-length-0', function() {
            var length = $(this).val();
            table.page.len(length).draw();
        });
        let searchTimer;
        $('#global-search').on('input', function() {
            clearTimeout(searchTimer);
            searchTimer = setTimeout(() => table.ajax.reload(null, false), 500);
        });
        $('#filter_day').on('input', function() {
            table.ajax.reload(null, false)
        });
        $(document).on('click', '#routing-table .delete-btn', function(e) {
            e.preventDefault();
            const url = $(this).attr('href');
            const name = $(this).data('name');
            deleteData(url, name);
        });

        let tableSales = $('#sales-table').DataTable({
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
                url: "{{ route('routing.sales.activity.data') }}",
                type: 'GET',
                data: function(d) {
                    d.search_term = $('#global-search-sales').val();
                    d.filter_day = $('#filter_day_sales').val();
                    d.date = $('#sales-date-range').val() == 'Date Range' ? '' : $('#sales-date-range').val();
                    d.filter_area = $('#filter_area').val();
                }
            },
            columns: [{
                    data: 'sales',
                    name: 'user.name',
                    class: 'table-data'
                },
                {
                    data: 'outlet',
                    name: 'name',
                    class: 'table-data'
                },
                {
                    data: 'visit_day',
                    name: 'visit_day',
                    class: 'table-data'
                },
                {
                    data: 'checkin',
                    name: 'checkin',
                    class: 'table-data'
                },
                {
                    data: 'checkout',
                    name: 'checkout',
                    class: 'table-data'
                },
                {
                    data: 'views',
                    name: 'views',
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
            order: [
                [0, 'asc']
            ]
        });
        // Event Handlers for Sales Table
        $(document).on('change', '#dt-length-sales', function() {
            var length = $(this).val();
            tableSales.page.len(length).draw();
        });

        let searchTimerSales;
        $('#global-search-sales').on('input', function() {
            clearTimeout(searchTimerSales);
            searchTimerSales = setTimeout(() => tableSales.ajax.reload(null, false), 500);
        });

        $('#filter_day_sales').on('input', function() {
            tableSales.ajax.reload(null, false);
        });

        $('#sales-date-range').on('change', function() {
            tableSales.ajax.reload(null, false);
        });

        $('#filter_area').on('change', function() {
            tableSales.ajax.reload(null, false);
        });
    </script>
@endpush

@push('scripts')
    <script>
        $('#channel').select2();
        $('#updateBtn').click(function(e) {
            e.preventDefault();

            // Konstanta untuk validasi
            const MAX_VIDEO_SIZE = 5 * 1024 * 1024; // 5MB
            const MAX_PDF_SIZE = 5 * 1024 * 1024; // 5MB
            const MAX_VIDEO_DURATION = 180; // 3 menit dalam detik
            const MAX_VIDEO_HEIGHT = 360; // 360p resolution

            const formData = new FormData();
            const pdfFile = $('#pamflet_file')[0].files[0];
            const videoFile = $('#video_file')[0].files[0];

            // Fungsi untuk menampilkan toast
            function showToast(type, message) {
                toast(type, message, 200);
            }

            // Validasi PDF
            if (pdfFile) {
                if (pdfFile.size > MAX_PDF_SIZE) {
                    showToast('error', 'Ukuran file PDF tidak boleh lebih dari 5MB');
                    return;
                }
                if (!pdfFile.type.includes('pdf')) {
                    showToast('error', 'File harus berformat PDF');
                    return;
                }
                formData.append('file_pdf', pdfFile);
            }

            // Validasi Video
            if (videoFile) {
                // Validasi ukuran dan tipe dasar
                if (videoFile.size > MAX_VIDEO_SIZE) {
                    showToast('error', 'Ukuran file Video tidak boleh lebih dari 5MB');
                    return;
                }
                if (!videoFile.type.includes('video/')) {
                    showToast('error', 'File harus berformat video');
                    return;
                }

                // Membuat promise untuk validasi video
                const validateVideo = new Promise((resolve, reject) => {
                    const video = document.createElement('video');
                    const videoUrl = URL.createObjectURL(videoFile);

                    video.addEventListener('loadedmetadata', function() {
                        URL.revokeObjectURL(videoUrl);

                        // Validasi durasi
                        if (video.duration > MAX_VIDEO_DURATION) {
                            reject('Durasi video tidak boleh lebih dari 3 menit');
                            return;
                        }

                        // Validasi resolusi
                        if (video.videoHeight > MAX_VIDEO_HEIGHT) {
                            reject('Resolusi video tidak boleh lebih dari 360p');
                            return;
                        }

                        resolve();
                    });

                    video.addEventListener('error', function() {
                        URL.revokeObjectURL(videoUrl);
                        reject('Gagal memvalidasi video');
                    });

                    video.src = videoUrl;
                });

                // Menjalankan validasi video dan melanjutkan dengan upload
                validateVideo
                    .then(() => {
                        formData.append('file_video', videoFile);
                        proceedWithUpload();
                    })
                    .catch((error) => {
                        showToast('error', error);
                    });

                return; // Menghentikan eksekusi di sini karena validasi video berjalan async
            }

            // Jika tidak ada video, langsung proceed dengan upload
            proceedWithUpload();

            function proceedWithUpload() {
                const channelId = $('#channel').val();
                if (!channelId) {
                    alert('Channel ID wajib diisi');
                    return;
                }
                formData.append('channel_id', channelId);
                formData.append('_method', 'PUT');

                $.ajax({
                    url: '{{ route('update-product-knowledge') }}',
                    type: 'POST',
                    data: formData,
                    contentType: false,
                    processData: false,
                    cache: false,
                    beforeSend: function() {
                        $('#updateBtn').prop('disabled', true);
                        $('#updateBtn').html('Uploading...');
                    },
                    success: function(response) {
                        if (response.status === 'success') {
                            closeModal('upload-product-knowledge');
                            showToast('success', response.message);
                            setTimeout(() => {
                                window.location.reload();
                            }, 2000);
                        }
                    },
                    error: function(xhr) {
                        showToast('error', 'Terjadi kesalahan saat upload');
                        console.error(xhr.responseText);
                    },
                    complete: function() {
                        $('#updateBtn').prop('disabled', false);
                        $('#updateBtn').html('Update');
                    }
                });
            }
        });
        $('#downloadBtn').click(function(e) {
            e.preventDefault();
            toggleLoading(true);
            const form = document.createElement('form');
            form.method = 'GET';
            form.action = '/routing/generate-excel';
            document.body.appendChild(form);
            fetch('/routing/generate-excel')
                .then(response => {
                    if (response.ok) {
                        form.submit();
                        toast('success', 'File berhasil diunduh', 150);
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
                    toggleLoading(false);
                    document.body.removeChild(form);
                });
        });
        document.getElementById('pamflet_file').addEventListener('change', function(e) {
            const fileName = e.target.files[0] ? e.target.files[0].name : 'No file selected';
            document.getElementById('pamfletFileNameDisplay').value = fileName;
        });
        document.getElementById('video_file').addEventListener('change', function(e) {
            const fileName = e.target.files[0] ? e.target.files[0].name : 'No file selected';
            document.getElementById('videofileNameDisplay').value = fileName;
        });


        // Add these handlers to your existing JavaScript
        $('#downloadBtnRouting').click(function(e) {
            e.preventDefault();

            // Get current filter values
            const filters = {
                search_term: $('#global-search').val(),
                filter_day: $('#filter_day').val()
            };

            // Show loading state
            const $btn = $(this);
            const $btnText = $btn.find('#downloadBtnTextRouting');
            const $btnLoading = $btn.find('#downloadBtnLoadingRouting');


            $btnText.addClass('hidden');
            $btnLoading.removeClass('hidden');
            $btn.prop('disabled', true);

            // Redirect to download - Gunakan route() helper
            window.location.href = "{{ route('routing.download-filtered') }}?" + new URLSearchParams(filters)
                .toString();

            setTimeout(() => {
                $btnText.removeClass('hidden');
                $btnLoading.addClass('hidden');
                $btn.prop('disabled', false);
                toast('success', 'File sedang diunduh', 300);
            }, 1000);

        });
        $('#downloadBtnSalesActivity').click(function(e) {
            e.preventDefault();

            // Ambil nilai filter yang sama persis dengan yang digunakan DataTable
            const filters = {
                search_term: $('#global-search-sales').val(),
                filter_day_sales: $('#filter_day_sales').val(),
                date: $('#sales-date-range').val() === 'Date Range' ? '' : $('#sales-date-range').val(),
                filter_area: $('#filter_area').val()
            };

            console.log('Download filters:', filters); // Untuk debugging

            const $btn = $(this);
            const $btnText = $btn.find('#downloadBtnTextSales');
            const $btnLoading = $btn.find('#downloadBtnLoadingSales');

            $btnText.addClass('hidden');
            $btnLoading.removeClass('hidden');
            $btn.prop('disabled', true);

            // Gunakan URLSearchParams untuk memastikan parameter terkirim dengan benar
            const queryString = new URLSearchParams(filters).toString();
            window.location.href = "{{ route('routing.download-sales-activity') }}?" + queryString;

            setTimeout(() => {
                $btnText.removeClass('hidden');
                $btnLoading.addClass('hidden');
                $btn.prop('disabled', false);
                toast('success', 'File sedang diunduh', 300);
            }, 1000);
        });
    </script>
@endpush
