@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Routing'" />
@endsection

@section('dashboard-content')
    <x-card>

        <x-slot:cardTitle>
            Tambah Daftar Outlet
        </x-slot:cardTitle>

        <x-slot:cardAction>
            <label for="upload_products" class="cursor-pointer">
                <x-button.light class="pointer-events-none">Unggah Secara Bulk</x-button.light>
                <input type="file" id="upload_products" name="upload_products" class="hidden" accept=".csv"
                    aria-label="Unggah Secara Bulk">
            </label>
        </x-slot:cardAction>

        <div class="grid grid-cols-2 gap-4">
            <div>
                <label for="name" class="form-label">Nama Pengguna</label>
                <input id="name" class="form-control" type="text" name="name" placeholder="Masukan nama pengguna"
                    aria-describedby="name" />
            </div>
            <div>
                <label for="sales-names">Nama Sales</label>
                <select id="sales-names" name="sales-names" class="w-full">
                    <option value="" selected disabled>
                        -- Pilih nama sales yang ditugaskan --
                    </option>
                    <option value="cleanser">
                        SunProtect
                    </option>
                </select>
            </div>
            <div>
                <label for="outlet-categories">Kategori Outlet</label>
                <select id="outlet-categories" name="outlet-categories" class=" w-full">
                    <option value="" selected disabled>
                        -- Pilih kategori outlet --
                    </option>
                    <option value="cleanser">
                        SunProtect
                    </option>
                </select>
            </div>
            <div>
                <label for="time-visit">Waktu Kunjungan</label>
                <select id="time-visit" name="time-visit" class=" w-full">
                    <option value="" selected disabled>
                        -- Pilih waktu kunjungan --
                    </option>
                    <option value="cleanser">
                        SunProtect
                    </option>
                </select>
            </div>
            <div>
                <label for="cycle">Cycle</label>
                <select id="cycle" name="cycle" class=" w-full">
                    <option value="" selected disabled>
                        -- Pilih cycle --
                    </option>
                    <option value="cleanser">
                        SunProtect
                    </option>
                </select>
            </div>
        </div>

        <x-section-card :title="'Produk'">
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label for="product-categories">Kategori Produk</label>
                    <select id="product-categories" name="product-categories" class=" w-full">
                        <option value="" selected disabled>
                            -- Pilih kategori produk --
                        </option>
                        <option value="cleanser">
                            SunProtect
                        </option>
                    </select>
                </div>
            </div>
        </x-section-card>


        <div class="border-b-2 border-dashed py-6">
            <h3 class="font-bold text-2xl text-white py-2 mb-6">
                Cleanser
            </h3>
            <div class="grid grid-cols-2 items-center my-2">
                <p class="text-white">Cetaphil Baby Daily Lotion with Organic Calendula 500ml</p>
                <div>
                    <label for="name" class="form-label">AV3M</label>
                    <input id="name" class="form-control" type="text" name="name"
                        placeholder="Masukan Jumlah AV3M" aria-describedby="name" />
                </div>
            </div>
        </div>

        <div class="border-b-2 border-dashed py-6">
            <h3 class="font-bold text-2xl text-white py-2 mb-6">
                Baby Treatment
            </h3>
            <div class="grid grid-cols-2 items-center my-2">
                <p class="text-white">Cetaphil Baby Daily Lotion with Organic Calendula 400ml</p>
                <div>
                    <label for="name" class="form-label">AV3M</label>
                    <input id="name" class="form-control" type="text" name="name"
                        placeholder="Masukan Jumlah AV3M" aria-describedby="name" />
                </div>
            </div>
        </div>

        <div class="grid grid-cols-2 items-center my-6">
            <p class="text-white">Cetaphil Baby Daily Lotion with Organic Calendula 200ml</p>
            <div>
                <label for="name" class="form-label">AV3M</label>
                <input id="name" class="form-control" type="text" name="name" placeholder="Masukan Jumlah AV3M"
                    aria-describedby="name" />
            </div>
        </div>

        <x-section-card :title="'Area Domisili Outlet'">
            <div class="grid grid-cols-2 gap-6">
                <div>
                    <label for="longitude" class="form-label">Longitudes <span class="font-normal">(DD
                            Coordinates)</span></label>
                    <input id="longitude" class="form-control" type="text" name="longitude"
                        placeholder="Masukkan Koordinat Longitude" aria-describedby="longitude" />
                </div>
                <div>
                    <label for="latitude" class="form-label">Latitudes <span class="font-normal">(DMS
                            Coordinates)</span></label>
                    <input id="latitude" class="form-control" type="text" name="latitude"
                        placeholder="Masukkan Koordinat Latitude" aria-describedby="latitude" />
                </div>
                <div>
                    <label for="states-option">Kabupaten/Kota</label>
                    <select id="states-option" name="states-option" class=" w-full">
                        <option value="" selected disabled>
                            -- Pilih Kabupaten/Kota--
                        </option>
                        <option value="cleanser">
                            Sumatra
                        </option>
                    </select>
                </div>
                <div>
                    <label for="adresss" class="form-label">Alamat Lengkap</label>
                    <input id="adresss" class="form-control" type="text" name="adresss"
                        placeholder="Masukkan Alamat Lengkap" aria-describedby="adresss" />
                </div>
            </div>
        </x-section-card>

        <x-section-card :title="'Tambahkan Foto Outlet'">
            <div class="flex flex-col items-center w-fit">
                <div class="relative w-fit mx-3">
                    <div class="flex justify-center items-center flex-col py-2">
                        {{-- Upload Area --}}
                        <div class="cursor-pointer text-center grid place-items-center border-2 border-dashed border-blue-400 rounded-lg p-4"
                            id="upload-area-front">
                            <svg width="30" height="63" viewBox="0 0 64 63" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <path
                                    d="M28 43.2577C28 45.4323 29.7909 47.1952 32 47.1952C34.2091 47.1952 36 45.4323 36 43.2577V15.074L48.971 27.8423L54.6279 22.2739L32.0005 0L9.37305 22.2739L15.0299 27.8423L28 15.0749V43.2577Z"
                                    fill="#fff" />
                                <path
                                    d="M0 39.375H8V55.125H56V39.375H64V55.125C64 59.4742 60.4183 63 56 63H8C3.58172 63 0 59.4742 0 55.125V39.375Z"
                                    fill="#fff" />
                            </svg>
                            <h5 class="text-white font-medium mt-2">Klik disini untuk unggah foto</h5>
                            <p class="text-white font-light text-sm">
                                Ukuran maksimal foto <strong>2MB</strong>
                            </p>
                        </div>

                        {{-- Preview Container --}}
                        <div id="preview-container-front" class="hidden w-[250px] relative">
                            <img id="preview-image-front" src="" alt="Preview"
                                class="w-full mx-auto rounded-lg" />
                            <button
                                class="absolute bottom-2 right-2 bg-white p-2 rounded-full shadow-md hover:bg-gray-100 transition-colors"
                                onclick="removeImage('front')">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-red-500" viewBox="0 0 20 20"
                                    fill="currentColor">
                                    <path fill-rule="evenodd"
                                        d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z"
                                        clip-rule="evenodd" />
                                </svg>
                            </button>
                        </div>
                    </div>

                    {{-- Hidden File Input --}}
                    <input type="file" name="img_front" id="img_front" class="hidden" accept="image/png, image/jpeg"
                        onchange="previewImage(this, 'front')">
                </div>

                {{-- Label --}}
                <label class="text-center mt-3 text-xs text-white cursor-pointer" for="img_front">
                    Foto tampak depan outlet
                </label>
            </div>

        </x-section-card>

        <x-section-card :title="'Formulir Survey Outlet'">
            <div class="relative inline-flex items-center">
                <input type="checkbox" id="toggle" class="peer sr-only">
                <label for="toggle" class="flex w-[180px] cursor-pointer items-center rounded-full bg-gray-200 p-1">
                    <!-- Active state (Sudah) -->
                    <span
                        class="flex h-8 w-[90px] items-center justify-center rounded-full text-sm font-medium transition-all duration-200 
						peer-checked:bg-blue-400 peer-checked:text-white">
                        Sudah
                    </span>
                    <!-- Inactive state (Belum) -->
                    <span
                        class="absolute flex h-8 w-[90px] items-center justify-center rounded-full bg-blue-400 text-sm font-medium text-white transition-all duration-200 
						peer-checked:translate-x-[90px] left-1">
                        Belum
                    </span>
                </label>
            </div>

        </x-section-card>

    </x-card>
@endsection

@push('scripts')
    <script>
        $(document).ready(function() {
            $('#sales-names').select2();
            $('#time-visit').select2();
            $('#cycle').select2();
            $('#states-option').select2();
            $('#product-categories').select2();
            $('#outlet-categories').select2({
                minimumResultsForSearch: Infinity
            });
        });
    </script>
@endpush

@push('scripts')
    <script>
        function previewImage(input, type) {
            const file = input.files[0];
            if (file) {
                // Check file size (2MB = 2 * 1024 * 1024 bytes)
                if (file.size > 2 * 1024 * 1024) {
                    alert('Ukuran file terlalu besar. Maksimal 2MB');
                    input.value = '';
                    return;
                }

                const reader = new FileReader();
                const uploadArea = document.getElementById(`upload-area-${type}`);
                const previewContainer = document.getElementById(`preview-container-${type}`);
                const previewImage = document.getElementById(`preview-image-${type}`);

                reader.onload = function(e) {
                    previewImage.src = e.target.result;
                    uploadArea.classList.add('hidden');
                    previewContainer.classList.remove('hidden');
                }

                reader.readAsDataURL(file);
            }
        }

        function removeImage(type) {
            const input = document.getElementById(`img_${type}`);
            const uploadArea = document.getElementById(`upload-area-${type}`);
            const previewContainer = document.getElementById(`preview-container-${type}`);
            const previewImage = document.getElementById(`preview-image-${type}`);

            input.value = '';
            previewImage.src = '';
            uploadArea.classList.remove('hidden');
            previewContainer.classList.add('hidden');
        }

        // Make the entire upload area clickable
        document.addEventListener('DOMContentLoaded', function() {
            const uploadArea = document.getElementById('upload-area-front');
            uploadArea.addEventListener('click', function() {
                document.getElementById('img_front').click();
            });
        });
    </script>
@endpush
