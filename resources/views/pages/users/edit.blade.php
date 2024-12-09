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
                    Ubah Pengguna
                </x-slot:cardTitle>
                {{-- Profil Pengguna --}}
                <form action="{{ route('users.update', $user) }}" method="POST" id="createUserForm">
                    @csrf
                    @method('PUT')
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label for="name" class="form-label">Nama Pengguna</label>
                            <input id="name" class="form-control @if($errors->has('name')) is-invalid @endif"
                                value="{{ $user->name }}" type="text" value="{{ $user->name }}" name="name"
                                placeholder="Masukan nama pengguna" aria-describedby="name" />
                            @if ($errors->has('name'))
                                <span id="name-error" class="text-sm text-red-600 mt-1">{{ $errors->first('name') }}</span>
                            @endif
                        </div>
                        <div>
                            <label for="email" class="form-label">Email Pengguna</label>
                            <input id="email" class="form-control @if($errors->has('email')) is-invalid @endif"
                                value="{{ $user->email }}" type="email" name="email"
                                placeholder="Masukan email pengguna" aria-describedby="email" />
                            @if ($errors->has('email'))
                                <span id="name-error" class="text-sm text-red-600 mt-1">{{ $errors->first('email') }}</span>
                            @endif

                        </div>
                        <div>
                            <label for="phone" class="form-label">Nomor Telepon Pengguna</label>
                            <input id="phone" class="form-control @if($errors->has('phone_number')) is-invalid @endif"
                                value="{{ $user->phone_number }}" type="text" name="phone_number"
                                placeholder="Masukan nomor telepon pengguna" aria-describedby="phone" />
                            @if ($errors->has('phone_number'))
                                <span id="name-error"
                                    class="text-sm text-red-600 mt-1">{{ $errors->first('phone_number') }}</span>
                            @endif
                        </div>
                        <div>
                            <label for="role" class="form-label">Jabatan Pengguna</label>
                            <select id="role" name="role_id"
                                class="form-select-search text-primary @if($errors->has('role_id')) is-invalid @endif"
                                value="{{ old('role_id') }}">
                                <option value="" disabled selected>
                                    -- Pilih Jabatan Pengguna --
                                </option>
                                @foreach ($roles as $role)
                                    <option value="{{ $role->id }}" {{ $role->id == $user->roles[0]->id ? 'selected' : '' }}
                                        data-name="{{ $role->name }}">{{ $role->name }}</option>
                                @endforeach
                            </select>
                            @if ($errors->has('role_id'))
                                <span id="name-error"
                                    class="text-sm text-red-600 mt-1">{{ $errors->first('role_id') }}</span>
                            @endif
                        </div>
                        <div>
                            <label for="password" class="form-label">Kata Sandi</label>
                            <input id="password" class="form-control @if($errors->has('password')) is-invalid @endif"
                                type="password" name="password" placeholder="Masukan kata Sandi"
                                aria-describedby="password" />
                            @if ($errors->has('password'))
                                <span id="name-error"
                                    class="text-sm text-red-600 mt-1">{{ $errors->first('password') }}</span>
                            @endif
                        </div>
                        <div>
                            <label for="password-confirmation" class="form-label">Konfirmasi Kata Sandi</label>
                            <input id="password-confirmation"
                                class="form-control @if($errors->has('password')) is-invalid @endif" type="password"
                                name="password_confirmation" placeholder="Masukan kata Sandi"
                                aria-describedby="password-confirmation" />
                        </div>
                        <div>
                            <label for="region" class="form-label">Region</label>
                            <input id="region" class="form-control @if($errors->has('region')) is-invalid @endif"
                                value="{{ $user->region }}" type="text" name="region" placeholder="Masukan Region"
                                aria-describedby="region" />
                            @if ($errors->has('region'))
                                <span id="name-error"
                                    class="text-sm text-red-600 mt-1">{{ $errors->first('region') }}</span>
                            @endif
                        </div>
                    </div>
                    {{-- Profil Pengguna End --}}

                    {{-- Area Domisili --}}
                    <x-section-card :title="'Area Domisili Pengguna'">
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label for="longitude" class="form-label">Longitudes <span class="font-normal">(DD
                                        Coordinates)</span></label>
                                <input id="longitude"
                                    class="form-control @if($errors->has('longitude')) is-invalid @endif"
                                    value="{{ $user->longitude }}" type="text" name="longitude"
                                    placeholder="Masukkan Koordinat Longitude" aria-describedby="longitude" />
                                @if ($errors->has('longtitude'))
                                    <span id="name-error"
                                        class="text-sm text-red-600 mt-1">{{ $errors->first('longtitude') }}</span>
                                @endif
                            </div>
                            <div>
                                <label for="latitude" class="form-label">Latitudes<span class="font-normal">(DMS
                                        Coordinates)</span></label>
                                <input id="latitude"
                                    class="form-control @if($errors->has('latitude')) is-invalid @endif"
                                    value="{{ $user->latitude }}" type="text" name="latitude"
                                    placeholder="Masukkan Koordinat Latitude" aria-describedby="latitude" />
                                @if ($errors->has('latitude'))
                                    <span id="name-error"
                                        class="text-sm text-red-600 mt-1">{{ $errors->first('latitude') }}</span>
                                @endif
                            </div>
                            <div>
                                <label for="states-option">Kabupaten/Kota</label>
                                <select id="states-option" name="city"
                                    class="w-full @if($errors->has('city')) is-invalid @endif"
                                    value="{{ old('city') }}">
                                    <option value="" selected disabled>
                                        -- Pilih Kabupaten/Kota--
                                    </option>
                                    @foreach ($cities as $city)
                                        <option value="{{ $city->name}}" {{ $city->name == $user->city ? 'selected' : ''}}>
                                            {{$city->name}}
                                        </option>
                                    @endforeach
                                </select>
                                @if ($errors->has('city'))
                                    <span id="name-error"
                                        class="text-sm text-red-600 mt-1">{{ $errors->first('city') }}</span>
                                @endif
                            </div>
                            <div>
                                <label for="address" class="form-label">Alamat Lengkap</label>
                                <input id="address" class="form-control @if($errors->has('address')) is-invalid @endif"
                                    value="{{ $user->address }}" type="text" name="address"
                                    placeholder="Masukkan Alamat Lengkap" aria-describedby="address" />
                                @if ($errors->has('address'))
                                    <span id="name-error"
                                        class="text-sm text-red-600 mt-1">{{ $errors->first('address') }}</span>
                                @endif
                            </div>
                        </div>
                        <div class="relative mt-10">
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
                    <x-section-card :title="'Manajemen Akun'">
                        @if ($errors->has('permissions'))
                            <span id="name-error"
                                class="text-sm text-red-600 mt-1">{{ $errors->first('permissions') }}</span>
                        @endif
                        @foreach(['admin', 'sales', 'superadmin', 'merchandiser'] as $role)
                            <div id="{{ $role }}-access" class="grid-cols-3 gap-12 hidden">
                                @foreach($rolePermissions[$role] as $menu)
                                    @php
                                        $isChecked = in_array($menu['value'], $permissions) && $user->roles[0]->name === $role;
                                    @endphp
                                    <x-input.switch name="permissions[]" value="{{ $menu['value'] }}" :checked="$isChecked">
                                        {{ $menu['label'] }}
                                    </x-input.switch>
                                @endforeach
                            </div>
                        @endforeach
                    </x-section-card>
                    {{-- Manajemen Akun End --}}

                    <x-button.info class="w-full mt-20 !text-xl" type="submit">Konfirmasi</x-button.info>
                </form>
                {{-- Manajemen Akun End --}}
        </div>
        </x-card>
    </div>
    </div>
</main>
@endsection

@push('scripts')
    <script>
        $(document).ready(function () {
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
            map.on('click', function (e) {
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
        const roleConfig = {
            "admin": {
                showElement: 'admin-access',
                hideElements: ['sales-access', 'superadmin-access', 'merchandiser-access']
            },
            "sales": {
                showElement: 'sales-access',
                hideElements: ['admin-access', 'superadmin-access', 'merchandiser-access']
            },
            "merchandiser": {
                showElement: 'merchandiser-access',
                hideElements: ['admin-access', 'superadmin-access','sales-access']
            },
            "superadmin": {
                showElement: 'superadmin-access',
                hideElements: ['admin-access', 'sales-access', 'merchandiser-access']
            }
        };

        const roleSelect = document.getElementById('role');
        let isInitialLoad = true;

        function toggleElementVisibility(elementId, show) {
            const element = document.getElementById(elementId);
            if (!element) return;

            element.classList.toggle('hidden', !show);
            element.classList.toggle('grid', show);

            // Hanya hapus checked jika bukan initial load dan element disembunyikan
            if (!isInitialLoad && !show) {
                const switches = element.querySelectorAll('input[type="checkbox"][name="permissions[]"]');
                switches.forEach(switchElement => {
                    switchElement.checked = false;
                });
            }
        }

        function clearAllPermissions() {
            // Hanya hapus semua checked jika bukan initial load
            if (!isInitialLoad) {
                const allSwitches = document.querySelectorAll('input[type="checkbox"][name="permissions[]"]');
                allSwitches.forEach(switchElement => {
                    switchElement.checked = false;
                });
            }
        }

        function handleRoleChange(event) {
            const selectedOption = event.target.options[event.target.selectedIndex];
            const selectedRoleId = selectedOption.value;
            const selectedRoleName = selectedOption.getAttribute('data-name');

            clearAllPermissions();

            const config = roleConfig[selectedRoleName];

            if (!config) return;

            toggleElementVisibility(config.showElement, true);

            config.hideElements.forEach(elementId => {
                toggleElementVisibility(elementId, false);
            });

            // Setelah initial load selesai, set flag menjadi false
            if (isInitialLoad) {
                isInitialLoad = false;
            }
        }

        // Tambahkan event listener
        roleSelect.addEventListener('change', handleRoleChange);

        // Trigger event change secara otomatis saat halaman dimuat
        document.addEventListener('DOMContentLoaded', function () {
            // Buat event change baru
            const event = new Event('change');
            // Trigger event pada roleSelect
            roleSelect.dispatchEvent(event);
        });
    </script>
@endpush

@push('scripts')
    <script>
        $(document).ready(function () {
            $('#states-option').select2();
        });
    </script>
@endpush