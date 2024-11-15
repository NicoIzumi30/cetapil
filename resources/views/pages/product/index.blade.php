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
                    <form class="grid grid-cols-2 gap-6">
                        <div>
                            <label for="categories" class="!text-black">Kategori Produk</label>
                            <div>
                                <select id="categories" name="category" class="categories w-full">
                                    <option value="" selected disabled>
                                        -- Pilih Category Product --
                                    </option>
                                    <option value="cleanser">
                                        SunProtect
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div>
                            <label for="sku" class="!text-black">Produk SKU</label>
                            <input id="sku" class="form-control @error('sku') is-invalid @enderror" type="text"
                                wire:model="sku" name="sku" placeholder="Masukan produk SKU" aria-describedby="sku"
                                value="">
                            @error('sku')
                                <div class="invalid-feedback">
                                    {{ $message }}
                                </div>
                            @enderror
                        </div>
                        <div>
                            <label for="md-price" class="!text-black">Harga MD</label>
                            <input id="md-price" class="form-control" wire:model="md-price" name="md-price"
                                placeholder="Masukan Harga MD" aria-describedby="md-price" value="">
                            @error('md-price')
                                <div class="invalid-feedback">
                                    {{ $message }}
                                </div>
                            @enderror
                        </div>
                        <div>
                            <label for="sales-price" class="!text-black">Harga Sales</label>
                            <input id="sales-price" class="form-control @error('sales-price') is-invalid @enderror"
                                type="text" wire:model="sales-price" name="sales-price" placeholder="Masukan Harga Sales"
                                aria-describedby="sales-price" value="">
                            @error('sales-price')
                                <div class="invalid-feedback">
                                    {{ $message }}
                                </div>
                            @enderror
                        </div>
                    </form>
                    <x-slot:footer>
                        <x-button.primary class="w-full">Tambah Produk</x-button.primary>
                    </x-slot:footer>
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
                                Aksi
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
                                <x-action-table-dropdown>
                                    <li>
                                        <button onclick="openModal('edit-produk-{{ $loop->index }}')"
                                            class="dropdown-option ">Lihat
                                            Data</button>
                                    </li>
                                    <li>
                                        <a href="#" class="dropdown-option text-red-400">Hapus
                                            Data</a>
                                    </li>
                                </x-action-table-dropdown>

                            </td>
                        </tr>
                    @empty
                        <p>data not found</p>
                    @endforelse
                </tbody>
            </table>
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
            <table class="table">
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
            $(document).ready(function() {
                $('#product-table').DataTable({
					paging: false
				});
            });
        });
    </script>
@endpush

@push('scripts')
    <script>
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
    </script>
@endpush
