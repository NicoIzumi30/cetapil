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
			<x-button.info onclick="openModal('unggah-av3m-bulk')">AV3M</x-button.info>
            <x-modal id="upload-product-knowledge">
                <x-slot:title>Upload Product Knowledge</x-slot:title>
                <form action="{{ route('update-product-knowledge') }}" method="POST" enctype="multipart/form-data">
                    @csrf
                    @method('PUT')
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

        {{-- Upload AV3M Bulk --}}
        <x-modal id="unggah-av3m-bulk">
            <div class="flex flex-col items-center w-full">
                <div class="relative w-full mx-3">
                    {{-- Upload Area --}}
                    <div class="cursor-pointer w-full h-[300px] text-center grid place-items-center rounded-md border-2 border-dashed border-blue-400 bg-[#EFF9FF]rounded-lg p-4"
                        id="upload-area-av3m">
                        <div id="upload-helptext-av3m" class="flex flex-col items-center text-center">
                            <svg width="30" height="63" viewBox="0 0 64 63" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <path
                                    d="M28 43.2577C28 45.4323 29.7909 47.1952 32 47.1952C34.2091 47.1952 36 45.4323 36 43.2577V15.074L48.971 27.8423L54.6279 22.2739L32.0005 0L9.37305 22.2739L15.0299 27.8423L28 15.0749V43.2577Z"
                                    fill="#39B5FF" />
                                <path
                                    d="M0 39.375H8V55.125H56V39.375H64V55.125C64 59.4742 60.4183 63 56 63H8C3.58172 63 0 59.4742 0 55.125V39.375Z"
                                    fill="#39B5FF" />
                            </svg>
                            <h5 class="text-primary font-medium mt-2">Tarik atau klik disini untuk mulai unggah
                                dokumen berformat CSV/XLS</h5>
                            <p class="text-primary font-light text-sm">
                                Ukuran maksimal file <strong>5MB</strong>
                            </p>
                        </div>
                        <p class="hidden text-primary font-bold text-xl" id="filename-display-av3m"></p>
                    </div>
                    {{-- Hidden File Input --}}
                    <input type="file" name="file_upload-av3m" id="file_upload-av3m" class="hidden">
                </div>
            </div>
            <x-slot:footer>
                <div class="flex gap-4">
                    <x-button.light onclick="closeModal('unggah-av3m-bulk')"
                        class="w-full border rounded-md ">Batalkan</x-button.light>
                    <x-button.light class="w-full !text-white !bg-primary " id="importBtnAv3m">Mulai
                        Unggah</x-button.light>
                    <x-button.light id="downloadTemplateAv3m" class="w-full !text-white !bg-primary ">Download
                        Template</x-button.light>
                </div>
            </x-slot:footer>
        </x-modal>
        {{-- END Upload AV3M Bulk --}}

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
        $('#updateBtn').click(function(e) {
            e.preventDefault();

            // Konstanta untuk validasi
            const MAX_VIDEO_SIZE = 5 * 1024 * 1024; // 5MB
            const MAX_PDF_SIZE = 5 * 1024 * 1024; // 5MB
            const MAX_VIDEO_DURATION = 180; // 3 menit dalam detik

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

@push('scripts')
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const uploadArea = document.getElementById('upload-area-av3m');
            const fileInput = document.getElementById('file_upload-av3m');
            const displayFileName = document.getElementById('filename-display-av3m');
            const uploadHelptext = document.getElementById('upload-helptext-av3m');
            const maxFileSize = 5 * 1024 * 1024;

            // Click handler for the upload area
            uploadArea.addEventListener('click', () => {
                fileInput.click();
            });

            // Drag and drop handlers
            uploadArea.addEventListener('dragover', (e) => {
                e.preventDefault();
                uploadArea.classList.add('drag-over');
            });

            uploadArea.addEventListener('dragleave', (e) => {
                e.preventDefault();
                uploadArea.classList.remove('drag-over');
            });

            uploadArea.addEventListener('drop', (e) => {
                e.preventDefault();
                uploadArea.classList.remove('drag-over');

                const files = e.dataTransfer.files;
                handleFiles(files);
            });

            fileInput.addEventListener('change', (e) => {
                handleFiles(e.target.files);
            });

            function handleFiles(files) {
                if (files.length === 0) return;

                const file = files[0];

                const validTypes = [
                        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                        'application/wps-office.xlsx',
                        'application/vnd.ms-excel'
                    ];


                if (!validTypes.includes(file.type)) {
                    alert('Upload file gagal, Tolong Unggah Hanya file berformat .xlsx');
                    fileInput.value = '';
                    return;
                }

                if (file.size > maxFileSize) {
                    alert('Upload file gagal, Ukuran file lebih dari 5 MB');
                    fileInput.value = '';
                    return;
                }

                if (file.size > maxFileSize && file.size > maxFileSize) {
                    return
                }

                const reader = new FileReader();
                reader.onload = function(e) {
                    displayFileName.classList.remove('hidden')
                    uploadHelptext.classList.add('hidden')
                    displayFileName.innerText = file.name
                };
                reader.readAsText(file);
            }
        });
    </script>
@endpush

