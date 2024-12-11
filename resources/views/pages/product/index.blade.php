@extends('layouts.main')

@section('banner-content')
<x-banner-content :title="'Produk'" />
@endsection


@section('dashboard-content')
<main class="w-full">
    {{-- Daftar Produk --}}
    <x-card>
        <x-slot:cardTitle>
            Daftar Produk
        </x-slot:cardTitle>

        {{-- Product Action --}}
        <x-slot:cardAction>
            <x-input.search class="border-0" placeholder="Cari data produk" id="global-search"></x-input.search>
            <x-button.light id="downloadBtn">
                <span id="downloadBtnText">Download</span>
                <span id="downloadBtnLoadingProduct" class="hidden">Downloading...</span>
            </x-button.light>
            <x-button.info onclick="openModal('tambah-produk')">
                Tambah Daftar Produk
            </x-button.info>
            {{-- Tambah Produk Modal --}}
            <x-modal id="tambah-produk">
                <x-slot:title>
                    Tambah Produk
                </x-slot:title>
                <form id="createProductForm" class="grid grid-cols-2 gap-6">
                    @csrf
                    <div>
                        <label for="categories" class="!text-black">Kategori Produk</label>
                        <div>
                            <select id="categories" name="category_id"
                                class="categories w-full form-control @error('category_id') is-invalid @enderror">
                                <option value="" selected disabled>-- Pilih Category Product --</option>
                                @foreach ($categories as $category)
                                    <option value="{{ $category->id }}">
                                        {{ $category->name }}
                                    </option>
                                @endforeach
                            </select>
                            <span id="category_id-error" class="text-red-500 text-xs hidden"></span>
                        </div>
                    </div>
                    <div>
                        <label for="sku" class="!text-black">Produk SKU</label>
                        <input id="sku" class="form-control @error('sku') is-invalid @enderror" type="text" name="sku"
                            placeholder="Masukan produk SKU">
                        <span id="sku-error" class="text-red-500 text-xs hidden"></span>
                    </div>
                    <div>
                        <label for="md_price" class="!text-black">Harga MD</label>
                        <input id="md_price" class="form-control" type="number" name="md_price"
                            placeholder="Masukan Harga MD">
                        <span id="md_price-error" class="text-red-500 text-xs hidden"></span>
                    </div>
                    <div>
                        <label for="sales_price" class="!text-black">Harga Sales</label>
                        <input id="sales_price" class="form-control" type="number" name="sales_price"
                            placeholder="Masukan Harga Sales">
                        <span id="sales_price-error" class="text-red-500 text-xs hidden"></span>
                    </div>
                    <x-slot:footer>
                        <x-button.primary type="submit" id="saveBtn" class="w-full">
                            <span id="saveBtnText">Tambah Produk</span>
                            <span id="saveBtnLoading" class="hidden">Menyimpan...</span>
                        </x-button.primary>
                    </x-slot:footer>
                </form>

            </x-modal>
            {{-- Tambah Produk Modal End --}}

            {{-- Edit Produk Modal --}}
            <x-modal id="edit-produk">
                <x-slot:title>Ubah Produk</x-slot:title>
                <form id="editProductForm" class="grid grid-cols-2 gap-6">
                    @csrf
                    @method('PUT')
                    <div>
                        <label for="edit-category" class="!text-black">Kategori Produk</label>
                        <div>
                            <select id="edit-category" name="category_id" class="edit-category w-full form-control">
                                <option value="" selected disabled>-- Pilih Category Product --</option>
                                @foreach ($categories as $category)
                                    <option value="{{ $category->id }}">
                                        {{ $category->name }}
                                    </option>
                                @endforeach
                            </select>
                            <span id="edit-category_id-error" class="text-red-500 text-xs hidden"></span>
                        </div>
                    </div>
                    <div>
                        <label for="edit-sku" class="!text-black">Produk SKU</label>
                        <input id="edit-sku" class="form-control" type="text" name="sku"
                            placeholder="Masukan produk SKU">
                        <span id="edit-sku-error" class="text-red-500 text-xs hidden"></span>
                    </div>
                    <div>
                        <label for="edit-md-price" class="!text-black">Harga MD</label>
                        <input id="edit-md-price" class="form-control" type="number" name="md_price"
                            placeholder="Masukan Harga MD">
                        <span id="edit-md_price-error" class="text-red-500 text-xs hidden"></span>
                    </div>
                    <div>
                        <label for="edit-sales-price" class="!text-black">Harga Sales</label>
                        <input id="edit-sales-price" class="form-control" type="number" name="sales_price"
                            placeholder="Masukan Harga Sales">
                        <span id="edit-sales_price-error" class="text-red-500 text-xs hidden"></span>
                    </div>
                </form>
                <x-slot:footer>
                    <x-button.primary type="submit" id="updateBtn" class="w-full">
                        <span id="updateBtnText">Simpan Perubahan</span>
                        <span id="updateBtnLoading" class="hidden">Menyimpan...</span>
                    </x-button.primary>
                </x-slot:footer>
            </x-modal>

            {{-- Edit Produk Modal End --}}

            <x-button.info onclick="openModal('unggah-produk-bulk')">Unggah Secara Bulk</x-button.info>
            <x-modal id="unggah-produk-bulk">
                <div class="flex flex-col items-center w-full">
                    <div class="relative w-full mx-3">
                        {{-- Upload Area --}}
                        <div class="cursor-pointer w-full h-[300px] text-center grid place-items-center rounded-md border-2 border-dashed border-blue-400 bg-[#EFF9FF]rounded-lg p-4"
                            id="upload-area">
                            <div id="upload-helptext" class="flex flex-col items-center text-center">
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
                                    dokumen berformat .XLSX</h5>
                                <p class="text-primary font-light text-sm">
                                    Ukuran maksimal file <strong>5MB</strong>
                                </p>
                            </div>
                            <p class="hidden text-primary font-bold text-xl" id="filename-display"></p>
                        </div>
                        {{-- Hidden File Input --}}
                        <input type="file" name="file_upload" id="file_upload" class="hidden">
                    </div>
                </div>
                <x-slot:footer>
                    <div class="flex gap-4">
                        <x-button.light onclick="closeModal('unggah-produk-bulk')"
                            class="w-full border rounded-md ">Batalkan</x-button.light>
                        <x-button.light class="w-full !text-white !bg-primary" id="importBtn"> <span
                                id="importBtnText">Mulai Unggah</span>
                            <span id="importBtnLoading" class="hidden">Memproses...</span></x-button.light>
                        <x-button.light class="w-full !text-white !bg-primary" id="downloadTemplate">Download
                            Template</x-button.light>
                    </div>
                </x-slot:footer>
            </x-modal>
        </x-slot:cardAction>
        {{-- Product Action End --}}

        {{-- Tabel Daftar Produk --}}
        <table id="product-table" class="table">
            <thead>
                <tr>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Kategori Produk') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('SKU') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Harga MD') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Harga Sales') }}
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

        {{-- TAMBAH AV3M --}}
        <x-modal id="update-av3m">
            <x-slot:title>Update AV3M</x-slot:title>
            <form id="av3mForm" class="grid grid-cols-2 gap-6">
                @csrf
                @foreach ($channels as $channel)
                    <div>
                        <label for="channel{{$channel->id}}" class="!text-black">{{$channel->name}}</label>
                        <input id="channel-{{$channel->id}}" class="form-control channer_{{$loop->iteration}}" type="text"
                            name="channel_{{$loop->iteration}}" placeholder="Masukan A3M {{$channel->name}}"
                            aria-describedby="channel-{{$channel->name}}" value="">
                    </div>
                @endforeach

                <x-slot:footer>
                    <x-button.primary class="w-full" id="saveAv3mBtn">Simpan Perubahan</x-button.primary>
                </x-slot:footer>
            </form>
        </x-modal>
        {{-- END TAMBAH AV3M --}}
    </x-card>
    {{-- Daftar Produk End --}}

    {{-- Stock On Hand --}}
    <x-card>
        <x-slot:cardTitle>
            Stock-On-Hand
        </x-slot:cardTitle>

        {{-- Stock-on-Hand Action --}}
        <x-slot:cardAction>
            <x-button.light id="downloadBtnStockOnHand">
                <span id="downloadBtnText">Download</span>
                <span id="downloadBtnLoading" class="hidden">Downloading...</span>
            </x-button.light>
            <x-select.light :title="'Filter Produk'" id="filter_product">
                <option value="all">Semua</option>
                @foreach ($products as $product)
                    <option value="{{$product->id}}">{{$product->sku}}</option>
                @endforeach
            </x-select.light>
            <x-select.light :title="'Filter Area'" id="filter_area">
                <option value="all">Semua</option>
                @foreach ($cities as $city)
                    <option value="{{$city->id}}">{{$city->name}}</option>
                @endforeach
            </x-select.light>
            <x-input.datepicker id="stock-date-range"></x-input.datepicker>
            {{-- <input type='text' id="basic-date" placeholder="Select Date..."> --}}
        </x-slot:cardAction>
        {{-- Stock-on-Hand Action End --}}

        {{-- Tabel Stock-on-Hand --}}
        <table id="stock-on-hand-table" class="table">
            <thead>
                <tr>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Outlet') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('SKU') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Stock-on-Hand(pcs)') }}
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
                            AV3M
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            Rekomendasi
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            Keterangan
                        </a>
                    </th>
                </tr>
            </thead>
        </table>
        {{-- Tabel Stock-on-Hand End --}}

    </x-card>
    {{-- Stock On Hand End --}}
</main>
@endsection



@push('scripts')
    <script>
        $(document).ready(function () {
            // Inisialisasi komponen
            $('.categories, .edit-category').select2();
            $("#stock-date-range").flatpickr({ mode: "range" });

            // Konfigurasi DataTable utama
            let table = $('#product-table').DataTable({
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
                    url: "{{ route('products.data') }}",
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
                    { data: 'category', name: 'category.name', className: 'table-data', },

                    { data: 'sku', name: 'sku', className: 'table-data', },
                    {
                        data: 'md_price',
                        name: 'md_price',
                        className: 'table-data',
                        render: data => 'Rp ' + data
                    },
                    {
                        data: 'sales_price',
                        name: 'sales_price',
                        className: 'table-data',
                        render: data => 'Rp ' + data
                    },
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

            // Stock on hand table
            let tableSOD = $('#stock-on-hand-table').DataTable({
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
                    url: "{{ route('products.data-stock-on-hand') }}",
                    type: 'GET',
                    data: function (d) {
                        d.date = $('#stock-date-range').val() == 'Date Range' ? '' : $('#stock-date-range').val();
                        d.filter_area = $('#filter_area').val();
                        d.filter_product = $('#filter_product').val();
                    }
                },
                columns: [
                    {
                        data: 'outlet',
                        name: 'outlet',
                        class: 'table-data'
                    },
                    {
                        data: 'sku',
                        name: 'sku',
                        class: 'table-data'
                    },
                    {
                        data: 'sod',
                        name: 'sod',
                        class: 'table-data'
                    },
                    {
                        data: 'status',
                        name: 'status',
                        class: 'table-data'
                    },
                    {
                        data: 'av3m',
                        name: 'av3m',
                        class: 'table-data'
                    },
                    {
                        data: 'ideal',
                        name: 'ideal',
                        class: 'table-data'
                    },

                    {
                        data: 'keterangan',
                        name: 'keterangan',
                        class: 'table-data'
                    }
                ],
                order: [[0, 'asc']]
            });
            // Event Handlers for Sales Table
            $(document).on('change', '#dt-length-stock-on-hand', function () {
                var length = $(this).val();
                tableSOD.page.len(length).draw();
            });

            $('#stock-date-range').on('change', function () {
                tableSOD.ajax.reload(null, false);
            });

            $('#filter_area').on('change', function () {
                tableSOD.ajax.reload(null, false);
            });
            $('#filter_product').on('change', function () {
                tableSOD.ajax.reload(null, false);
            });
            $(document).on('click', '#product-table .delete-btn', function (e) {
                e.preventDefault();
                const url = $(this).attr('href');
                const name = $(this).data('name');
                deleteData(url, name);
            });
            // Create Product
            $('#saveBtn').click(function () {
                resetFormErrors();
                toggleLoading(true, 'save');

                $.ajax({
                    type: 'POST',
                    url: '{{ route('products.store') }}',
                    data: $('#createProductForm').serialize(),
                    success: function (response) {
                        handleSuccess('tambah-produk', response.message);
                    },
                    error: handleFormErrors
                });
            });

            // Edit product handler
            $(document).on('click', '#view-product', function (e) {
                e.preventDefault();
                const productId = $(this).data('id');
                resetFormErrors();

                $.ajax({
                    url: `/products/${productId}/edit`,
                    type: 'GET',
                    success: function (response) {
                        $('#edit-category').val(response.category_id).trigger('change');
                        $('#edit-sku').val(response.sku);
                        $('#edit-md-price').val(response.md_price);
                        $('#edit-sales-price').val(response.sales_price);
                        $('#editProductForm').data('id', response.id);
                        openModal('edit-produk');
                    },
                    error: function () {
                        toast('error', 'Terjadi kesalahan saat mengambil data produk', 200);
                    }
                });
            });

            // Update product handler
            $('#updateBtn').click(function (e) {
                e.preventDefault();
                const productId = $('#editProductForm').data('id');
                const formData = {
                    category_id: $('#edit-category').val(),
                    sku: $('#edit-sku').val(),
                    md_price: $('#edit-md-price').val().replace(/[^\d]/g, ''),
                    sales_price: $('#edit-sales-price').val().replace(/[^\d]/g, '')
                };

                resetFormErrors();
                toggleLoading(true, 'update');

                $.ajax({
                    url: `/products/${productId}`,
                    type: 'PUT',
                    data: formData,
                    success: function (response) {
                        handleSuccess('edit-produk', response.message);
                    },
                    error: handleFormErrors
                });
            });

            // AV3M update handler
            $(document).on('click', '#view-av3m', function (e) {
                e.preventDefault();
                const productId = $(this).data('id');
                resetFormErrors();
                openModal('update-av3m');

                $.ajax({
                    url: `/products/${productId}/av3m`,
                    type: 'GET',
                    success: function (response) {
                        @foreach ($channels as $channel)
                            $('#channel-{{$channel->id}}').val(response.channel_{{$loop->iteration}});
                        @endforeach
                        $('#av3mForm').data('id', response.id);
                    }
                });
            });

            // Save AV3M handler
            $('#saveAv3mBtn').click(function (e) {
                e.preventDefault();
                const productId = $('#av3mForm').data('id');

                $.ajax({
                    url: `/products/${productId}/av3m`,
                    type: 'POST',
                    data: $('#av3mForm').serialize(),
                    success: function (response) {
                        handleSuccess('update-av3m', response.message);
                    },
                    error: function (xhr) {
                        if (xhr.status === 422) {
                            toast('error', xhr.responseJSON.message, 200);
                            handleFieldErrors(xhr.responseJSON.errors, true);
                        }
                    }
                });
            });

            // Import/Upload handlers
            $('#downloadTemplate').click(function () {
                window.location.href = "{{ asset('assets/template/template_bulk_product.xlsx') }}";
            });

            $('#importBtn').click(function () {
                const file = $('#file_upload')[0].files[0];
                if (!file) {
                    return toast('error', 'Silakan pilih file terlebih dahulu', 200);
                }

                const formData = new FormData();
                formData.append('excel_file', file);
                toggleLoading(true, 'import');

                $.ajax({
                    url: '/products/bulk',
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function (response) {
                        handleSuccess('unggah-produk-bulk', response.message);
                    },
                    error: function (xhr) {
                        toggleLoading(false, 'import');
                        toast('error', xhr.responseJSON.message, 200);
                    }
                });
            });

            // Download Excel handler
            $('#downloadBtn').click(function (e) {
                e.preventDefault();
                
                // Show loading state
                const $btn = $(this);
                const $btnText = $btn.find('#downloadBtnText');
                const $btnLoading = $btn.find('#downloadBtnLoadingProduct');
                
                $btnText.addClass('hidden');
                $btnLoading.removeClass('hidden');
                $btn.prop('disabled', true);

                const form = document.createElement('form');
                form.method = 'GET';
                form.action = '/products/generate-excel';
                document.body.appendChild(form);

                fetch('/products/generate-excel')
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
                            $btnText.removeClass('hidden');
                            $btnLoading.addClass('hidden');
                            $btn.prop('disabled', false);
                            document.body.removeChild(form);
                        }, 1000);
                    });
            });

            // File Upload Area
            const setupFileUpload = () => {
                const uploadArea = document.getElementById('upload-area');
                const fileInput = document.getElementById('file_upload');
                const displayFileName = document.getElementById('filename-display');
                const uploadHelptext = document.getElementById('upload-helptext');
                const maxFileSize = 5 * 1024 * 1024;

                uploadArea.addEventListener('click', () => fileInput.click());

                ['dragover', 'dragleave', 'drop'].forEach(eventName => {
                    uploadArea.addEventListener(eventName, (e) => {
                        e.preventDefault();
                        uploadArea.classList.toggle('drag-over', eventName === 'dragover');
                        if (eventName === 'drop') handleFiles(e.dataTransfer.files);
                    });
                });

                fileInput.addEventListener('change', (e) => handleFiles(e.target.files));

                function handleFiles(files) {
                    if (!files.length) return;

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

                    displayFileName.classList.remove('hidden');
                    uploadHelptext.classList.add('hidden');
                    displayFileName.innerText = file.name;
                }
            };

            setupFileUpload();

            // Helper functions
            function resetFormErrors() {
                $('.text-red-500').addClass('hidden');
                $('input, select').removeClass('border-red-500');
            }

            function handleSuccess(modalId, message) {
                toggleLoading(false, 'update');
                closeModal(modalId);
                toast('success', message, 300);
                setTimeout(() => window.location.reload(), 1500);
            }

            function handleFormErrors(xhr) {
                toggleLoading(false, 'update');
                if (xhr.status === 422) {
                    handleFieldErrors(xhr.responseJSON.errors);
                }
            }

            function handleFieldErrors(errors, isAv3m = false) {
                $.each(errors, function (key, value) {
                    const prefix = isAv3m ? '.' : '#edit-';
                    const suffix = isAv3m ? '' : '-error';
                    $(`${prefix}${key}${suffix}`).text(value[0]).removeClass('hidden');
                    $(`[name="${key}"]`).addClass('border-red-500');
                });
            }
        });

        $('#downloadBtnStockOnHand').click(function(e) {
    e.preventDefault();
    
    // Get current filter values
    const filters = {
        filter_date: $('#stock-date-range').val() === 'Date Range' ? '' : $('#stock-date-range').val(),
        filter_product: $('#filter_product').val() || 'all',
        filter_area: $('#filter_area').val() || 'all'
    };

    // Show loading state
    const $btn = $(this);
    const $btnText = $btn.find('#downloadBtnText');
    const $btnLoading = $btn.find('#downloadBtnLoading');
    
    $btnText.addClass('hidden');
    $btnLoading.removeClass('hidden');
    $btn.prop('disabled', true);

    // Gunakan fetch untuk download
    fetch('/products/download-stock-on-hand?' + new URLSearchParams(filters), {
        method: 'GET',
    })
    .then(response => {
        if (!response.ok) throw new Error('Network response was not ok');
        return response.blob();
    })
    .then(blob => {
        // Create download link
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'stock_on_hand_' + new Date().toISOString().slice(0,19).replace(/[:]/g, '-') + '.xlsx';
        document.body.appendChild(a);
        a.click();
        window.URL.revokeObjectURL(url);
        a.remove();
        
        toast('success', 'File berhasil diunduh', 300);
    })
    .catch(error => {
        console.error('Download error:', error);
        toast('error', 'Gagal mengunduh file', 200);
    })
    .finally(() => {
        $btnText.removeClass('hidden');
        $btnLoading.addClass('hidden');
        $btn.prop('disabled', false);
    });
});
    </script>
@endpush