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
            <div class="relative mt-6">
                <div class="h-[450px] z-10" id="user-map-location"></div>
                <button id="fullscreen-button"
                    class="absolute top-3 right-3 rounded-sm w-10 h-10 grid place-items-center bg-white z-50 hover:bg-slate-200">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none"
                        xmlns="http://www.w3.org/2000/svg">
                        <path
                            d="M6 14C5.45 14 5 14.45 5 15V18C5 18.55 5.45 19 6 19H9C9.55 19 10 18.55 10 18C10 17.45 9.55 17 9 17H7V15C7 14.45 6.55 14 6 14ZM6 10C6.55 10 7 9.55 7 9V7H9C9.55 7 10 6.55 10 6C10 5.45 9.55 5 9 5H6C5.45 5 5 5.45 5 6V9C5 9.55 5.45 10 6 10ZM17 17H15C14.45 17 14 17.45 14 18C14 18.55 14.45 19 15 19H18C18.55 19 19 18.55 19 18V15C19 14.45 18.55 14 18 14C17.45 14 17 14.45 17 15V17ZM14 6C14 6.55 14.45 7 15 7H17V9C17 9.55 17.45 10 18 10C18.55 10 19 9.55 19 9V6C19 5.45 18.55 5 18 5H15C14.45 5 14 5.45 14 6Z"
                            fill="#000" />
                    </svg>
                </button>
            </div>
        </x-section-card>

        <x-section-card :title="'Tambahkan Foto Outlet'">
            <div class="flex">
                {{-- Foto Tampak Depan Outlet --}}
                <x-input.image id="front_outlet" name="front_outlet" label="Foto tampak depan outlet"
                    :max-size="2" />
                {{-- Foto Tampak Depan Outlet End --}}

                {{-- Foto Spanduk/Banner/Neon Box --}}
                <x-input.image id="banner_outlet" name="banner_outlet" label="Foto spanduk/banner/neon Box"
                    :max-size="2" />
                {{-- Foto Spanduk/Banner/Neon Box End --}}

                {{-- Foto jalan utama outlet --}}
                <x-input.image id="street_outlet" name="istreet_outlet" label="Foto jalan utama outlet"
                    :max-size="2" />
                {{-- Foto jalan utama outlet End --}}
            </div>
        </x-section-card>

        <x-section-card :title="'Formulir Survey Outlet'">

            <div class="flex flex-col gap-6">
                <div class="flex justify-between items-center w-full">
                    <p class="text-white font-bold text-sm">Apakah outlet sudah menjual produk GIH ?</p>
                    <div class="relative inline-flex items-center">
                        <input type="checkbox" checked id="gih-checkbox" class="sr-only" />
                        <label for="gih-checkbox"
                            class="flex w-[160px] cursor-pointer items-center rounded-md bg-gray-200 p-1">
                            <!-- Active state (Sudah) -->
                            <span id="gih-checked"
                                class="flex h-10 w-[90px] items-center justify-center rounded-md bg-blue-400 text-sm text-white font-medium transition-all duration-200 ">
                                Sudah
                            </span>
                            <!-- Inactive state (Belum) -->
                            <span id="gih-unchecked"
                                class="flex h-10 w-[90px] items-center justify-center rounded-md text-sm font-medium text-blue-400 transition-all duration-200 
						  peer-checked:-translate-x-[90px]">
                                Belum
                            </span>
                        </label>
                    </div>
                </div>
                <x-pages.routing.outlet-form>
                    <x-slot:title>Berapa banyak produk GIH yang sudah terjual?</x-slot:title>
                </x-pages.routing.outlet-form>
                <x-pages.routing.outlet-form>
                    <x-slot:title>Selling out GSC500/week<span class="font-normal">(in pcs)</span></x-slot:title>
                </x-pages.routing.outlet-form>
                <x-pages.routing.outlet-form>
                    <x-slot:title>Selling out GSC250/week<span class="font-normal">(in pcs)</span></x-slot:title>
                </x-pages.routing.outlet-form>
                <x-pages.routing.outlet-form>
                    <x-slot:title>Selling out GSC125/week<span class="font-normal">(in pcs)</span></x-slot:title>
                </x-pages.routing.outlet-form>
                <x-pages.routing.outlet-form>
                    <x-slot:title>Selling out Oily 125/week<span class="font-normal">(in pcs)</span></x-slot:title>
                </x-pages.routing.outlet-form>
                <x-pages.routing.outlet-form>
                    <x-slot:title>Selling out wash & shampo 400ml/week<span class="font-normal">(in
                            pcs)</span></x-slot:title>
                </x-pages.routing.outlet-form>
                <x-pages.routing.outlet-form>
                    <x-slot:title>Selling out wash & shampo cal 400ml/week <span class="font-normal">(in
                            pcs)</span></x-slot:title>
                </x-pages.routing.outlet-form>
                <x-pages.routing.outlet-form>
                    <x-slot:title>Selling out baby lotion cal 400ml/week <span class="font-normal">(in
                            pcs)</span></x-slot:title>
                </x-pages.routing.outlet-form>
                <x-pages.routing.outlet-form>
                    <x-slot:title>Selling out baby lotion 400ml/week<span class="font-normal">(in
                            pcs)</span></x-slot:title>
                </x-pages.routing.outlet-form>
                <x-pages.routing.outlet-form>
                    <x-slot:title>Selling out baby advance protection cream cal/week<span class="font-normal">(in
                            pcs)</span></x-slot:title>
                </x-pages.routing.outlet-form>
                <x-pages.routing.outlet-form>
                    <x-slot:title>Selling out BHR night/week<span class="font-normal">(in pcs)</span></x-slot:title>
                </x-pages.routing.outlet-form>
                <x-pages.routing.outlet-form>
                    <x-slot:title>Selling out BHR day protection/week<span class="font-normal">(in
                            pcs)</span></x-slot:title>
                </x-pages.routing.outlet-form>
                <x-pages.routing.outlet-form>
                    <x-slot:title>Selling out BHR serum <span class="font-normal">(in pcs)</span></x-slot:title>
                </x-pages.routing.outlet-form>
            </div>

            <x-button.info class="w-full mt-20 !text-xl">Konfirmasi</x-button.info>

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
        $(document).ready(function() {
            // Initialize map
            var map = L.map('user-map-location').setView([-6.200000, 106.816666],
                10); // Centered on Jakarta by default
            L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 20,
                attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
            }).addTo(map);

            // Initialize marker variable
            let marker;

            // Function to update marker position
            function updateMarker(latlng) {
                // Remove existing marker if it exists
                if (marker) {
                    marker.remove();
                }

                // Add new marker
                marker = L.marker(latlng).addTo(map);

                // Update form fields
                $('#latitude').val(latlng.lat.toFixed(6));
                $('#longitude').val(latlng.lng.toFixed(6));
            }

            // Handle map click events
            map.on('click', function(e) {
                updateMarker(e.latlng);
            });

            // Handle manual coordinate input
            function handleCoordinateInput() {
                const lat = parseFloat($('#latitude').val());
                const lng = parseFloat($('#longitude').val());

                if (!isNaN(lat) && !isNaN(lng)) {
                    const latlng = L.latLng(lat, lng);

                    // Update marker
                    updateMarker(latlng);

                    // Center map on new coordinates
                    map.setView(latlng, map.getZoom());
                }
            }

            // Add event listeners to coordinate inputs
            $('#latitude, #longitude').on('change', handleCoordinateInput);

            // Handle fullscreen toggle
            const fullScreenButton = document.querySelector('#fullscreen-button');
            const mapResize = document.querySelector('#user-map-location');

            fullScreenButton.addEventListener("click", () => {
                mapResize.classList.toggle("!h-[00px]");
                // Invalidate map size after resize
                setTimeout(() => {
                    map.invalidateSize();
                }, 100);
            });

            // Optional: Handle initial coordinates if they exist
            handleCoordinateInput();
        });
    </script>
@endpush

@push('scripts')
    <script>
        $(document).ready(function() {
            const gihCheckbox = document.querySelector('#gih-checkbox');
            const gihChecked = document.querySelector('#gih-checked');
            const gihUnChecked = document.querySelector('#gih-unchecked');
			

            gihCheckbox.addEventListener('change', function() {
                if (this.checked) {
					gihChecked.classList.add("bg-blue-400", "!text-white");
					gihUnChecked.classList.remove("bg-blue-400", "!text-white");
                } else {
					gihUnChecked.classList.add("bg-blue-400", "!text-white");
					gihChecked.classList.remove("bg-blue-400", "!text-white");
					gihChecked.classList.add("text-blue-400");
                }
            });
        });
    </script>
@endpush
