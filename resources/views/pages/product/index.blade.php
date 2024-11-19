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
                <x-input.search class="border-0" placeholder="Cari data produk"></x-input.search>
                <x-button.light>Download</x-button.light>
                <x-button.info onclick="openModal('tambah-produk')">
                    Tambah Daftar Produk
                </x-button.info>
                {{-- Tambah Produk Modal --}}
                <x-modal id="tambah-produk">
                    <x-slot:title>
                        Tambah Produk
                    </x-slot:title>
                    <form method="POST" action="{{ route('products.store') }}" id="createProductForm"
                        class="grid grid-cols-2 gap-6">
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
                            <input id="sku" class="form-control @error('sku') is-invalid @enderror" type="text"
                                name="sku" placeholder="Masukan produk SKU">
                            <span id="sku-error" class="text-red-500 text-xs hidden"></span>
                        </div>
                        <div>
                            <label for="md_price" class="!text-black">Harga MD</label>
                            <input id="md_price" class="form-control" type="text" name="md_price"
                                placeholder="Masukan Harga MD">
                            <span id="md_price-error" class="text-red-500 text-xs hidden"></span>
                        </div>
                        <div>
                            <label for="sales_price" class="!text-black">Harga Sales</label>
                            <input id="sales_price" class="form-control" type="text" name="sales_price"
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

                {{-- Edit Produk Modal  --}}
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
                            <input id="edit-md-price" class="form-control" type="text" name="md_price"
                                placeholder="Masukan Harga MD">
                            <span id="edit-md_price-error" class="text-red-500 text-xs hidden"></span>
                        </div>
                        <div>
                            <label for="edit-sales-price" class="!text-black">Harga Sales</label>
                            <input id="edit-sales-price" class="form-control" type="text" name="sales_price"
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
                                        dokumen berformat CSV/XLS</h5>
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
                            <x-button.light class="w-full !text-white !bg-primary ">Mulai Unggah</x-button.light>
                            <x-button.light class="w-full !text-white !bg-primary ">Download Template</x-button.light>
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
                <tbody>
                    @forelse ($items as $item)
                        <tr class="table-row">
                            <td scope="row" class="table-data">
                                {{ $item->category->name }}
                            </td>
                            <td class="table-data">
                                {{ $item->sku }}
                            </td>
                            <td class="table-data">
                                Rp {{ number_format($item->md_price, 0, ',', '.') }}
                            </td>
                            <td class="table-data">
                                Rp {{ number_format($item->sales_price, 0, ',', '.') }}
                            </td>
                            <td class="table-data">
                                <x-action-table-dropdown>
                                    <li>
                                        <button class="dropdown-option" id="view-product" data-id="{{ $item->id }}">
                                            Lihat Data
                                        </button>
                                    </li>
                                    <li>
                                        <a href="{{ route('products.destroy', $item->id) }}"
                                            class="dropdown-option text-red-400 delete-product">
                                            Hapus Data
                                        </a>
                                        <button class="dropdown-option" id="view-av3m" data-id="{{ $item->id }}" >
                                            Update AV3M
                                        </button>
                                    </li>
                                </x-action-table-dropdown>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="5" class="px-6 py-4 text-center text-gray-500">
                                Tidak ada data produk
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>

            {{-- TAMBAH AV3M --}}
            <x-modal id="update-av3m">
                <x-slot:title>Update AV3M</x-slot:title>
                <form id="av3mForm" class="grid grid-cols-2 gap-6">
                    @csrf
                    <div>
                        <label for="channel-a" class="!text-black">Channel A</label>
                        <input id="channel-a" class="form-control @error('channel-a') is-invalid @enderror"
                            type="text" wire:model="channel-a" name="channel-a" placeholder="Masukan Channel A"
                            aria-describedby="channel-a" value="">
                    </div>
                    <div>
                        <label for="channel-b" class="!text-black">Channel B</label>
                        <input id="channel-b" class="form-control @error('channel-b') is-invalid @enderror"
                            type="text" wire:model="channel-b" name="channel-b" placeholder="Masukan Channel B"
                            aria-describedby="channel-b" value="">
                    </div>
                    <div>
                        <label for="channel-c" class="!text-black">Channel C</label>
                        <input id="channel-c" class="form-control @error('channel-c') is-invalid @enderror"
                            type="text" wire:model="channel-c" name="channel-c" placeholder="Masukan Channel C"
                            aria-describedby="channel-c" value="">
                    </div>
                    <div>
                        <label for="channel-d" class="!text-black">Channel D</label>
                        <input id="channel-d" class="form-control @error('channel-d') is-invalid @enderror"
                            type="text" wire:model="channel-d" name="channel-d" placeholder="Masukan Channel D"
                            aria-describedby="channel-d" value="">
                    </div>
                    <x-slot:footer>
                        <x-button.primary class="w-full">Simpan Perubahan</x-button.primary>
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
                <x-button.light>Download
                </x-button.light>
                <x-select.light :title="'Filter Produk'">
                    <option value="apalah">apalah</option>
                </x-select.light>
                <x-select.light :title="'Filter Area'">
                    <option value="maa">mamah</option>
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
                <tbody>
                    @forelse ($items as $item)
                        <tr class="table-row">
                            <td scope="row" class="table-data">
                                {{ $item['name'] }}
                            </td>
                            <td class="table-data">
                                {{ $item['price'] }}
                            </td>
                            <td class="table-data">
                                100
                            </td>
                            <td class="table-data {{ $item['status'] == 'Yes' ? 'text-green-400' : 'text-red-400' }}">
                                {{ $item['status'] }}
                            </td>
                            <td class="table-data">
                                80
                            </td>
                            <td class="table-data {{ $item['recommendation'] > 0 ? 'text-green-400' : 'text-red-400' }}">
                                {{ $item['recommendation'] }}
                            </td>
                            <td class="table-data {{ $item['ket'] == 'Ideal' ? 'text-green-400' : 'text-red-400' }}">
                                {{ $item['ket'] }}
                            </td>
                        </tr>
                    @empty
                        <p>data not found</p>
                    @endforelse
                </tbody>
            </table>
            {{-- Tabel Stock-on-Hand End --}}

        </x-card>
        {{-- Stock On Hand End --}}
    </main>
@endsection



@push('scripts')
    <script>
        $(document).ready(function() {
            $('.categories').select2();
            $('.edit-category').select2();
            $("#stock-date-range").flatpickr({
                mode: "range"
            });
            $('#product-table').DataTable({
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
            $('#stock-on-hand-table').DataTable({
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
        $(document).ready(function() {
            // Setup AJAX CSRF
            $.ajaxSetup({
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                }
            });

            function resetForm() {
                $('#createProductForm')[0].reset();
                $('.text-red-500').addClass('hidden');
                $('input').removeClass('border-red-500');
            }

            function toggleLoading(show) {
                if (show) {
                    $('#saveBtnText').addClass('hidden');
                    $('#saveBtnLoading').removeClass('hidden');
                    $('#saveBtn').prop('disabled', true);
                } else {
                    $('#saveBtnText').removeClass('hidden');
                    $('#saveBtnLoading').addClass('hidden');
                    $('#saveBtn').prop('disabled', false);
                }
            }

            // Form submission
            $('#saveBtn').click(function() {

                $('.text-red-500').addClass('hidden');
                $('input').removeClass('border-red-500');

                toggleLoading(true);

                $.ajax({
                    type: 'POST',
                    url: '{{ route('products.store') }}',
                    data: $('#createProductForm').serialize(),
                    success: function(response) {
                        toggleLoading(false);
                        if (response.status === 'success') {
                            closeModal('tambah-produk');
                            new Notify({
                                status: 'success',
                                title: 'Success',
                                text: response.message,
                                effect: 'fade',
                                speed: 300,
                                customClass: '',
                                customIcon: '',
                                showIcon: true,
                                showCloseButton: true,
                                autoclose: true,
                                autotimeout: 1000,
                                notificationsGap: null,
                                notificationsPadding: null,
                                type: 'outline',
                                position: 'right top',
                                customWrapper: '',
                            })
                            setTimeout(() => {
                                window.location.reload();
                            }, 1500);
                        }
                    },
                    error: function(xhr) {
                        toggleLoading(false);
                        if (xhr.status === 422) {
                            const errors = xhr.responseJSON.errors;
                            $.each(errors, function(key, value) {
                                $(`#${key}-error`)
                                    .text(value[0])
                                    .removeClass('hidden');
                                $(`[name="${key}"]`).addClass('border-red-500');
                            });
                        }
                    }
                });
            });

            // Format number inputs with thousand separator
            // $('input[type="number"]').on('input', function() {
            //     const value = $(this).val().replace(/[^\d]/g, '');
            //     if (value) {
            //         $(this).val(parseInt(value).toLocaleString('id-ID'));
            //     }
            // });

            // Clean number format before submit
            // $('#createProductForm').on('submit', function() {
            //     $('input[type="number"]').each(function() {
            //         $(this).val($(this).val().replace(/[^\d]/g, ''));
            //     });
            // });
        });
        document.addEventListener('DOMContentLoaded', function() {
            const uploadArea = document.getElementById('upload-area');
            const fileInput = document.getElementById('file_upload');
            const displayFileName = document.getElementById('filename-display');
            const uploadHelptext = document.getElementById('upload-helptext');
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
                    'text/csv',
                    'application/vnd.ms-excel',
                    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                ];

                if (!validTypes.includes(file.type)) {
                    alert('Upload file gagal, Tolong Unggah Hanya file berformat .csv/xls');
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

                console.log(file.name);

                const reader = new FileReader();
                reader.onload = function(e) {
                    displayFileName.classList.remove('hidden')
                    uploadHelptext.classList.add('hidden')
                    displayFileName.innerText = file.name
                };
                reader.readAsText(file);
            }
        });

        //delete product

        $('meta[name="csrf-token"]').attr('content')

        $(document).ready(function() {
            // Setup AJAX CSRF
            $.ajaxSetup({
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                }
            });

            $(document).ready(function() {
                // Event handler untuk tombol delete
                $(document).on('click', '.delete-product', function(e) {
                    e.preventDefault();
                    const deleteUrl = $(this).attr('href');

                    // Konfirmasi penghapusan dengan Sweet Alert
                    Swal.fire({
                        title: 'Apakah Anda yakin?',
                        text: "Data produk akan dihapus secara permanen",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#d33',
                        cancelButtonColor: '#3085d6',
                        confirmButtonText: 'Ya, hapus!',
                        cancelButtonText: 'Batal'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            // Kirim request DELETE
                            $.ajax({
                                url: deleteUrl,
                                type: 'DELETE',
                                success: function(response) {
                                    if (response.status === 'success') {
                                        // Tampilkan notifikasi sukses
                                        new Notify({
                                            status: 'success',
                                            title: 'Berhasil',
                                            text: response.message,
                                            effect: 'fade',
                                            speed: 300,
                                            customClass: '',
                                            customIcon: '',
                                            showIcon: true,
                                            showCloseButton: true,
                                            autoclose: true,
                                            autotimeout: 1000,
                                            gap: 20,
                                            distance: 20,
                                            type: 'outline',
                                            position: 'right top'
                                        });

                                        // Reload halaman setelah delay
                                        setTimeout(() => {
                                            window.location.reload();
                                        }, 1500);
                                    }
                                },
                                error: function(xhr) {
                                    // Tampilkan notifikasi error
                                    Swal.fire(
                                        'Gagal!',
                                        'Terjadi kesalahan saat menghapus data.',
                                        'error'
                                    );
                                }
                            });
                        }
                    });
                });
            });
        });

        // (document).ready(function() {
            // Format number untuk input harga
            function formatNumber(input) {
                let value = input.val().replace(/\D/g, '');
                if (value) {
                    input.val(new Intl.NumberFormat('id-ID').format(value));
                }
            }

            $('input[name="md_price"], input[name="sales_price"], #edit_md_price, #edit_sales_price').on('input',
                function() {
                    formatNumber($(this));
                });

        // });


        //EDIT PRODUK

        $(document).ready(function() {
            // Setup AJAX CSRF
            $.ajaxSetup({
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                }
            });

            // Initialize select2 for category dropdown
            $('.edit-category').select2();

            function toggleUpdateLoading(show) {
                if (show) {
                    $('#updateBtnText').addClass('hidden');
                    $('#updateBtnLoading').removeClass('hidden');
                    $('#updateBtn').prop('disabled', true);
                } else {
                    $('#updateBtnText').removeClass('hidden');
                    $('#updateBtnLoading').addClass('hidden');
                    $('#updateBtn').prop('disabled', false);
                }
            }

            // Load product data into form
            $(document).on('click', '#view-product', function(e) {
                e.preventDefault();
                const productId = $(this).data('id');

                // Reset form state
                $('.text-red-500').addClass('hidden');
                $('input, select').removeClass('border-red-500');

                $.ajax({
                    url: `/products/${productId}/edit`,
                    type: 'GET',
                    success: function(response) {
                        $('#edit-category').val(response.category_id).trigger('change');
                        $('#edit-sku').val(response.sku);
                        $('#edit-md-price').val(new Intl.NumberFormat('id-ID').format(response
                            .md_price));
                        $('#edit-sales-price').val(new Intl.NumberFormat('id-ID').format(
                            response.sales_price));
                        $('#editProductForm').data('id', response.id);
                        openModal('edit-produk');
                    },
                    error: function(xhr) {
                        new Notify({
                            status: 'error',
                            title: 'Error',
                            text: 'Gagal mengambil data produk',
                            effect: 'fade',
                            speed: 300,
                            showIcon: true,
                            showCloseButton: true,
                            autoclose: true,
                            autotimeout: 3000,
                            type: 'outline',
                            position: 'right top'
                        });
                    }
                });
            });

            // Handle form submission
            $('#updateBtn').click(function(e) {
                e.preventDefault();

                $('.text-red-500').addClass('hidden');
                $('input, select').removeClass('border-red-500');

                toggleUpdateLoading(true);

                const productId = $('#editProductForm').data('id');
                const formData = {
                    category_id: $('#edit-category').val(),
                    sku: $('#edit-sku').val(),
                    md_price: $('#edit-md-price').val().replace(/[^\d]/g, ''),
                    sales_price: $('#edit-sales-price').val().replace(/[^\d]/g, '')
                };

                $.ajax({
                    url: `/products/${productId}`,
                    type: 'PUT',
                    data: formData,
                    success: function(response) {
                        toggleUpdateLoading(false);
                        closeModal('edit-produk');

                        new Notify({
                            status: 'success',
                            title: 'Success',
                            text: response.message,
                            effect: 'fade',
                            speed: 300,
                            showIcon: true,
                            showCloseButton: true,
                            autoclose: true,
                            autotimeout: 1500,
                            type: 'outline',
                            position: 'right top'
                        });

                        setTimeout(() => {
                            window.location.reload();
                        }, 1500);
                    },
                    error: function(xhr) {
                        toggleUpdateLoading(false);
                        if (xhr.status === 422) {
                            const errors = xhr.responseJSON.errors;
                            $.each(errors, function(key, value) {
                                $(`#edit-${key}-error`)
                                    .text(value[0])
                                    .removeClass('hidden');
                                $(`[name="${key}"]`).addClass('border-red-500');
                            });
                        }
                    }
                });
            });

            // Format number inputs with thousand separator
            $('#edit-md-price, #edit-sales-price').on('input', function() {
                const value = $(this).val().replace(/[^\d]/g, '');
                if (value) {
                    $(this).val(new Intl.NumberFormat('id-ID').format(value));
                }
            });
        });


        // TAMBAH AV3M

        $(document).on('click', '#view-av3m', function(e) {
    e.preventDefault();
    const productId = $(this).data('id');
    openModal('update-av3m');

    // Reset form
    $('.text-red-500').addClass('hidden');
    $('input').removeClass('border-red-500');

    $.ajax({
        url: `/products/${productId}/av3m`,
        type: 'GET',
        success: function(response) {
            $('#channel-a').val(response.channel_a);
            $('#channel-b').val(response.channel_b);
            $('#channel-c').val(response.channel_c);
            $('#channel-d').val(response.channel_d);
            $('#av3mForm').data('id', response.id);
        }
    });
});

// Handle form submission
$('#saveAv3mBtn').click(function(e) {
    e.preventDefault();
    const productId = $('#av3mForm').data('id');

    $.ajax({
        url: `/products/${productId}/av3m`,
        type: 'POST',
        data: $('#av3mForm').serialize(),
        success: function(response) {
            closeModal('update-av3m');
            new Notify({
                status: 'success',
                title: 'Success',
                text: response.message,
                effect: 'fade',
                speed: 300,
                showIcon: true,
                showCloseButton: true,
                autoclose: true,
                autotimeout: 1500,
                type: 'outline',
                position: 'right top'
            });
            setTimeout(() => {
                window.location.reload();
            }, 1500);
        },
        error: function(xhr) {
            if (xhr.status === 422) {
                const errors = xhr.responseJSON.errors;
                $.each(errors, function(key, value) {
                    $(`#${key}-error`).text(value[0]).removeClass('hidden');
                    $(`#${key}`).addClass('border-red-500');
                });
            }
        }
    });
});
    </script>
@endpush
