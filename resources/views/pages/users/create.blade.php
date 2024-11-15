@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Pengguna'" />
@endsection

@section('dashboard-content')
    <main class="w-full">
        <div>
            <div class="form-edit">
                <x-card>
                    <x-slot:cardTitle>
                        Tambah Pengguna
                    </x-slot:cardTitle>
                    {{-- Profil Pengguna --}}
                    <div class="grid grid-cols-2 gap-4">
                        <div class="mb-4">
                            <label for="name" class="form-label">Nama Pengguna</label>
                            <input id="name" class="form-control" type="text" name="name"
                                placeholder="Masukan nama pengguna" aria-describedby="name" />
                        </div>
                        <div class="mb-4">
                            <label for="email" class="form-label">Email Pengguna</label>
                            <input id="email" class="form-control" type="email" name="email"
                                placeholder="Masukan email pengguna" aria-describedby="email" />
                        </div>
                        <div class="mb-4">
                            <label for="phone" class="form-label">Nomor Telepon Pengguna</label>
                            <input id="phone" class="form-control" type="text" name="phone"
                                placeholder="Masukan nomor telepon pengguna" aria-describedby="phone" />
                        </div>
                        <div>
                            <label for="role" class="form-label">Jabatan Pengguna</label>
                            <div>
                                <select id="role" class="form-select-search text-primary">
                                    <option value="" disabled selected>
                                        -- Pilih Jabatan Pengguna --
                                    </option>
                                    <option value="superadmin">
                                        SuperAdmin
                                    </option>
                                    <option value="admin">
                                        Admin
                                    </option>
                                    <option value="sales">
                                        Sales
                                    </option>
                                </select>
                            </div>
                        </div>
                    </div>
                    {{-- Profil Pengguna End --}}

                    {{-- Area Domisili --}}
                    <x-section-card :title="'Area Domisili Pengguna'">
                        <div class="grid grid-cols-2 gap-4">
                            <div class="mb-4">
                                <label for="longitude" class="form-label">Longitudes <span class="font-normal">(DD
                                        Coordinates)</span></label>
                                <input id="longitude" class="form-control" type="text" name="longitude"
                                    placeholder="Masukkan Koordinat Longitude" aria-describedby="longitude" />
                            </div>
                            <div class="mb-4">
                                <label for="latitude" class="form-label">Latitudes<span class="font-normal">(DMS
                                        Coordinates)</span></label>
                                <input id="latitude" class="form-control" type="text" name="latitude"
                                    placeholder="Masukkan Koordinat Latitude" aria-describedby="latitude" />
                            </div>
                        </div>
                        <div class="relative">
                            <div class="h-[350px] z-10" id="user-map-location"></div>
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
                    {{-- Area Domisili End --}}


                    {{-- Manajemen Akun --}}
                    <div id="account-management" class="hidden">
                        <x-section-card :title="'Manajemen Akun'">
                            <div>
                                <div class="grid grid-cols-3 gap-12 ">
                                    {{-- @foreach ($form['permissions'] as $permission) --}}
                                    <x-input.switch>Main Reports</x-input.switch>
                                    <x-input.switch>Menu Produk</x-input.switch>
                                    <x-input.switch>Menu Routing</x-input.switch>
                                    <x-input.switch>Menu Selling</x-input.switch>
                                    <x-input.switch>Menu Pengguna</x-input.switch>
                                    {{-- @endforeach --}}
                                </div>
                            </div>
                        </x-section-card>
                    </div>
                    {{-- Manajemen Akun End --}}

                    <x-button.info class="w-full mt-20 !text-xl">Konfirmasi</x-button.info>

            </div>
            </x-card>
        </div>
        </div>
    </main>
@endsection

@push('scripts')
    <script>
        $(document).ready(function() {
            // Initialize map with default view of Indonesia
            var map = L.map('user-map-location').setView([-2.4833826, 117.8902853],
            5); // Centered on Indonesia by default

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

            // Function to handle geolocation success
            function handleLocationSuccess(position) {
                const latlng = L.latLng(position.coords.latitude, position.coords.longitude);
                map.setView(latlng, 15);
            }

            // Try to get user's location
            if ("geolocation" in navigator) {
                navigator.geolocation.getCurrentPosition(handleLocationSuccess);
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
                mapResize.classList.toggle("!h-[500px]");
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
        const roleSelect = document.getElementById('role');
        const accountManagement = document.getElementById('account-management');

        roleSelect.addEventListener('change', () => {
            if (roleSelect.value) {
                accountManagement.classList.remove('hidden');
            } else {
                accountManagement.classList.add('hidden');
            }
        });
    </script>
@endpush
