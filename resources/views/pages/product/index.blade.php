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
                    <form method="POST" action="{{ route('products.store') }}" id="createProductForm" class="grid grid-cols-2 gap-6">
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
                                name="sku" placeholder="Masukan produk SKU" >
                                <span id="sku-error" class="text-red-500 text-xs hidden"></span>
                        </div>
                        <div>
                            <label for="md-price" class="!text-black">Harga MD</label>
                            <input id="md_price" class="form-control @error('md_price') is-invalid @enderror"
                                type="number" name="md_price" placeholder="Masukan Harga MD">
                                <span id="md_price-error" class="text-red-500 text-xs hidden"></span>
                        </div>
                        <div>
                            <label for="sales-price" class="!text-black">Harga Sales</label>
                            <input id="sales_price" class="form-control @error('sales_price') is-invalid @enderror"
                                type="number" name="sales_price" placeholder="Masukan Harga Sales">
                                <span id="sales_price-error" class="text-red-500 text-xs hidden"></span>
                        </div>
                        <x-slot:footer>
                            <x-button.primary type="submit" id="saveBtn" class="w-full"> <span id="saveBtnText">Tambah Produk</span>
                                <span id="saveBtnLoading" class="hidden">
                                    Menyimpan...
                                </span></x-button.primary>
                        </x-slot:footer>
                    </form>

                </x-modal>
                {{-- Tambah Produk Modal End --}}
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
                                        <a href="{{ route('products.edit', $item->id) }}" class="dropdown-option">
                                            Lihat Data
                                        </a>
                                    </li>
                                    <li>
                                        <a href="{{ route('products.destroy', $item->id) }}" 
                                            class="dropdown-option text-red-400 delete-product" 
                                            data-id="{{ $item->id }}">
                                             Hapus Data
                                         </a>
                                        {{-- <button onclick="deleteProduct('{{ $item->id }}')" class="dropdown-option text-red-400">
                                            Hapus Data
                                        </button> --}}
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
            <x-modal id="edit-produk">

            </x-modal>
            {{ $items->links() }}
            {{-- Tabel Daftar Produk End --}}
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
            {{ $items->links() }}
            {{-- Tabel Stock-on-Hand End --}}

        </x-card>
        {{-- Stock On Hand End --}}
    </main>
@endsection

@push('scripts')
    <script>
        $(document).ready(function() {
            $('.categories').select2();
            $("#stock-date-range").flatpickr({
                mode: "range"
            });
            $('#product-table').DataTable({
                paging: false,
                searching: false,
                info: false
            });
            $('#stock-on-hand-table').DataTable({
                paging: false,
                searching: false,
                info: false
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
                // Reset error states
                
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

        $(document).ready(function() {
        // Event handler untuk delete
        $('.delete-product').on('click', function(e) {
            e.preventDefault();
            const deleteUrl = $(this).attr('href');
            
            Swal.fire({
                title: 'Apakah Anda yakin?',
                text: "Data produk akan dihapus",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Ya, hapus!',
                cancelButtonText: 'Batal'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        type: 'DELETE',
                        url: deleteUrl,
                        headers: {
                            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                        },
                        success: function(response) {
                            if (response.status === 'success') {
                                new Notify({
                                    status: 'success',
                                    title: 'Success',
                                    text: response.message,
                                    effect: 'fade',
                                    speed: 300,
                                    showIcon: true,
                                    showCloseButton: true,
                                    autoclose: true,
                                    autotimeout: 1000,
                                    position: 'right top',
                                    type: 'outline'
                                });
                                
                                setTimeout(() => {
                                    window.location.reload();
                                }, 1500);
                            }
                        },
                        error: function(xhr) {
                            new Notify({
                                status: 'error',
                                title: 'Error',
                                text: 'Gagal menghapus produk',
                                effect: 'fade',
                                speed: 300,
                                showIcon: true,
                                showCloseButton: true,
                                autoclose: true,
                                autotimeout: 1000,
                                position: 'right top',
                                type: 'outline'
                            });
                        }
                    });
                }
            });
        });
    });
    </script>
@endpush
