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
        <x-button.light onclick="openModal('unggah-routing-bulk')">Unggah Secara Bulk</x-button.light>
        <x-modal id="unggah-routing-bulk">
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
                    <x-button.light class="w-full !text-white !bg-primary " id="importBtn">Mulai Unggah</x-button.light>
                    <x-button.light id="downloadTemplate" class="w-full !text-white !bg-primary ">Download
                        Template</x-button.light>
                </div>
            </x-slot:footer>
        </x-modal>
    </x-slot:cardAction>
    <form action="{{ route('routing.store') }}" method="POST" enctype="multipart/form-data">
        @csrf
        <div class="grid grid-cols-2 gap-4">
            <div>
                <label for="name" class="form-label">Nama Outlet</label>
                <input id="name" class="form-control @error('name') is-invalid @enderror" value="{{ old('name') }}" type="text" name="name"
                    placeholder="Masukan nama outlet" aria-describedby="name" />
                @if ($errors->has('name'))
                    <span id="name-error" class="text-sm text-red-600 mt-1">{{ $errors->first('name') }}</span>
                @endif
            </div>
            <div>
                <label for="code" class="form-label">Kode Outlet</label>
                <input id="code" class="form-control @error('code') is-invalid @enderror" value="{{ old('code') }}" type="text" name="code"
                    placeholder="Masukan nama outlet" aria-describedby="name" />
                @if ($errors->has('code'))
                    <span id="code-error" class="text-sm text-red-600 mt-1">{{ $errors->first('code') }}</span>
                @endif
            </div>
            <div>
                <label for="outlet_type" class="form-label">Tipe Outlet</label>
                <input id="outlet_type" class="form-control @error('outlet_type') is-invalid @enderror" value="{{ old('outlet_type') }}" type="text" name="outlet_type"
                    placeholder="Masukan tipe outlet" aria-describedby="outlet_type" />
                @if ($errors->has('outlet_type'))
                    <span id="outlet_type-error" class="text-sm text-red-600 mt-1">{{ $errors->first('outlet_type') }}</span>
                @endif
            </div>
            <div>
                <label for="account_type" class="form-label">Tipe Akun</label>
                <input id="account_type" class="form-control @error('account_type') is-invalid @enderror" value="{{ old('account_type') }}" type="text" name="account_type"
                    placeholder="Masukan tipe akun" aria-describedby="name" />
                @if ($errors->has('account_type'))
                    <span id="account_type-error" class="text-sm text-red-600 mt-1">{{ $errors->first('account_type') }}</span>
                @endif
            </div>
            <div>
                <label for="user_id">Nama Sales</label>
                <select id="user_id" name="user_id" class="form-control @error('user_id') is-invalid @enderror">
                    <option value="" selected disabled>
                        -- Pilih nama sales yang ditugaskan --
                    </option>
                    @foreach ($salesUsers as $sales)
                        <option value="{{ $sales->id }}" {{ old('user_id') == $sales->id ? 'selected' : ''}}>
                            {{ $sales->name }}
                        </option>
                    @endforeach
                </select>
                @error('user_id')
                    <span class="invalid-feedback" role="alert">
                        <strong>{{ $message }}</strong>
                    </span>
                @enderror
            </div>
            <div>
                <label for="category">Kategori Outlet</label>
                <select id="category" name="category" class="w-full">
                    <option value="" selected disabled>
                        -- Pilih kategori outlet --
                    </option>
                    <option value="MT" {{ old('category') == 'MT' ? 'selected' : ''}}>
                        MT
                    </option>
                    <option value="GT" {{ old('category') == 'GT' ? 'selected' : ''}}>
                        GT
                    </option>
                </select>
                @if ($errors->has('category'))
                    <span id="category-error" class="text-sm text-red-600 mt-1">{{ $errors->first('category') }}</span>
                @endif
            </div>
            <div>
                <label for="visit_day">Waktu Kunjungan</label>
                <select id="visit_day" name="visit_day" class=" w-full">
                    <option value="" selected disabled>
                        -- Pilih waktu kunjungan --
                    </option>
                    @foreach ($waktuKunjungan as $hari)
                        <option value="{{$hari['value']}}" {{ old('visit_day') == $hari['value'] ? 'selected' : ''}}>{{$hari['name']}}</option>
                    @endforeach
                </select>
                @if ($errors->has('visit_day'))
                    <span id="visit_day-error" class="text-sm text-red-600 mt-1">{{ $errors->first('visit_day') }}</span>
                @endif
            </div>
            <div>
                <label for="cycle">Cycle</label>
                <select id="cycle" name="cycle" class=" w-full">
                    <option value="" selected disabled>
                        -- Pilih cycle --
                    </option>
                    @foreach ($cycles as $cycle)
                        <option value="{{$cycle}}" {{ old('cycle') == $cycle ? 'selected' : ''}}>{{$cycle}}</option>
                    @endforeach
                </select>
                @if ($errors->has('cycle'))
                    <span id="cycle-error" class="text-sm text-red-600 mt-1">{{ $errors->first('cycle') }}</span>
                @endif
            </div>
            <div id="week-container" class="@if(!in_array(old('cycle', ''), ['1x2', '1x4'])) hidden @endif">
                <label for="week" class="form-label">Week</label>
                <select id="week" name="week" class="form-control @error('week') is-invalid @enderror">
                    <option value="" selected disabled>-- Pilih Week --</option>
                </select>
                @error('week')
                    <span class="invalid-feedback" role="alert">
                        <strong>{{ $message }}</strong>
                    </span>
                @enderror
            </div>
            <div>
                <label for="channel">Channel</label>
                <select id="channel" name="channel" class=" w-full">
                    <option value="" selected disabled>
                        -- Pilih Channel --
                    </option>
                    @foreach ($channels as $channel)
                        <option value="{{$channel->id}}" {{ old('channel') == $channel->id ? 'selected' : ''}}>{{$channel->name}}</option>
                    @endforeach
                </select>
                @if ($errors->has('channel'))
                    <span id="channel-error" class="text-sm text-red-600 mt-1">{{ $errors->first('channel') }}</span>
                @endif
            </div>
        </div>

        <x-section-card :title="'Produk'">
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label for="product_category">Kategori Produk</label>
                    <select id="product_category" name="product_category[]" class="w-full" multiple="multiple">
                        @foreach ($categories as $category)
                            <option value="{{ $category->id }}" {{ old('product_category') == $category->id ? 'selected' : ''}} data-name="{{ \Str::slug($category->name) }}">
                                {{ $category->name }}
                            </option>
                        @endforeach
                    </select>
                    @if ($errors->has('product_category'))
                        <span id="product_category-error"
                            class="text-sm text-red-600 mt-1">{{ $errors->first('product_category') }}</span>
                    @endif
                </div>
            </div>
        </x-section-card>


        @foreach ($categories as $category)
            <div id="{{ \Str::slug($category->name) }}" class="hidden border-b-2 border-dashed py-6">
                <h3 class="font-bold text-2xl text-white py-2 mb-6">
                    {{ $category->name }}
                </h3>
                <div class="grid grid-cols-1 gap-4">
                    @foreach ($category->products as $product)
                        <div class="grid grid-cols-3 items-center p-4 rounded-lg">
                            <div class="col-span-2">
                                <p class="text-white font-medium">{{$product->sku}}</p>
                            </div>
                            <div>
                                <label for="av3m-{{$product->sku}}" class="form-label text-white">AV3M</label>
                                <input 
                                    type="number" 
                                    name="av3m[{{$product->sku}}]" 
                                    id="av3m-{{$product->sku}}" 
                                    class="form-control av3m-input w-full" 
                                    min="0"
                                    placeholder="Masukan Jumlah AV3M"
                                    value="{{ old('av3m.'.$product->sku, 0) }}"
                                />
                                @error('av3m.'.$product->sku)
                                    <span class="text-red-500 text-sm">{{ $message }}</span>
                                @enderror
                            </div>
                        </div>
                    @endforeach
                </div>
            </div>
        @endforeach

        <x-section-card :title="'Area Domisili Outlet'">
            <div class="grid grid-cols-2 gap-6">
                <div>
                    <label for="longitude" class="form-label">Longitudes <span class="font-normal">(DD
                            Coordinates)</span></label>
                    <input id="longitude" class="form-control @error('longtitude') is-invalid @enderror" {{ old('longitude')}} type="text"
                        name="longitude" placeholder="Masukkan Koordinat Longitude" aria-describedby="longitude" />
                    @if ($errors->has('longtitude'))
                        <span id="longtitude-error"
                            class="text-sm text-red-600 mt-1">{{ $errors->first('longtitude') }}</span>
                    @endif
                </div>
                <div>
                    <label for="latitude" class="form-label">Latitudes <span class="font-normal">(DMS
                            Coordinates)</span></label>
                    <input id="latitude" class="form-control @error('latitude') is-invalid @enderror" value="{{ old('latitude') }}" type="text"
                        name="latitude" placeholder="Masukkan Koordinat Latitude" aria-describedby="latitude" />
                    @if ($errors->has('latitude'))
                        <span id="latitude-error" class="text-sm text-red-600 mt-1">{{ $errors->first('latitude') }}</span>
                    @endif
                </div>
                <div>
                    <label for="city">Kabupaten/Kota</label>
                    <select id="city" name="city" class=" w-full">
                        <option value="" selected disabled>
                            -- Pilih Kabupaten/Kota--
                        </option>
                        @foreach ($cities as $city)
                            <option value="{{$city->id}}"  {{ old('city') == $city->id ? 'selected' : ''}}>{{$city->name}}</option>
                        @endforeach
                    </select>
                    @if ($errors->has('city'))
                        <span id="city-error" class="text-sm text-red-600 mt-1">{{ $errors->first('city') }}</span>
                    @endif
                </div>
                <div>
                    <label for="address" class="form-label">Alamat Lengkap</label>
                    <input id="address" class="form-control" value="{{ old('address') }}" type="text" name="address"
                        placeholder="Masukkan Alamat Lengkap" aria-describedby="address" />
                    @if ($errors->has('address'))
                        <span id="address-error" class="text-sm text-red-600 mt-1">{{ $errors->first('address') }}</span>
                    @endif
                </div>
            </div>
            <div class="relative mt-6">
                <div class="h-[450px] z-10" id="user-map-location"></div>
                <button id="fullscreen-button"
                    class="absolute top-3 right-3 rounded-sm w-10 h-10 grid place-items-center bg-white z-50 hover:bg-slate-200">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
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
                <x-input.image id="front_outlet" name="img_front" label="Foto tampak depan outlet" :max-size="2" />
                {{-- Foto Tampak Depan Outlet End --}}

                {{-- Foto Spanduk/Banner/Neon Box --}}
                <x-input.image id="banner_outlet" name="img_banner" label="Foto spanduk/banner/neon Box"
                    :max-size="2" />
                {{-- Foto Spanduk/Banner/Neon Box End --}}

                {{-- Foto jalan utama outlet --}}
                <x-input.image id="street_outlet" name="img_main_road" label="Foto jalan utama outlet" :max-size="2" />
                {{-- Foto jalan utama outlet End --}}
            </div>

        </x-section-card>

        <x-section-card :title="'Formulir Survey Outlet'">
            @foreach ($outletForms as $form)
                @if($form->type == 'bool')
                    <div class="flex flex-col gap-6">
                        <div class="flex justify-between items-center w-full">
                            <p class="text-white font-bold text-sm">{{$form->question}}</p>
                            <div class="relative inline-flex items-center">
                                <input type="checkbox" name="survey[{{$form->id}}]" id="gih-checkbox" checked value="Sudah"
                                    class="sr-only" />
                                    <div class="flex w-[160px] cursor-pointer items-center rounded-md bg-gray-200 p-1">
                                    <span id="gih-checked"
                                        class="flex h-10 w-[90px] items-center justify-center rounded-md bg-blue-400 text-sm text-white font-medium transition-all duration-200">
                                        Sudah
                                    </span>
                                    <span id="gih-unchecked"
                                        class="flex h-10 w-[90px] items-center justify-center rounded-md text-sm font-medium text-blue-400 transition-all duration-200">
                                        Belum
                                    </span>
                                    </div>
                                <!-- <label for="gih-checkbox"
                                    class="flex w-[160px] cursor-pointer items-center rounded-md bg-gray-200 p-1"> -->
                                  
                                <!-- </label> -->
                            </div>
                        </div>
                @elseif($form->type == 'text')
                    <x-pages.routing.outlet-form>
                        <x-slot:title>{{$form->question}}</x-slot:title>
                        <x-slot:name>survey[{{$form->id}}]</x-slot:name>
                        <x-slot:value>{{old('survey['.$form->id.']') ?? '0'}}</x-slot:value>
                    </x-pages.routing.outlet-form>
                @endif
            @endforeach
            </div>
            <x-button.info class="w-full mt-20 !text-xl" type="submit" id="submitBtn">
                <span id="submitBtnText">Konfirmasi</span>
                <span id="submitBtnLoading" class="hidden">Menyimpan...</span>
            </x-button.info>

        </x-section-card>
    </form>
</x-card>
@endsection

@push('scripts')
    <script>
        $(document).ready(function () {
            $('#user_id').select2();
            $('#visit_day').select2();
            $('#cycle').select2({
                minimumResultsForSearch: Infinity
            });
            $('#week_type').select2({
                minimumResultsForSearch: Infinity
            });
            $('#category').select2();
            $('#city').select2();
            $('#channel').select2();
            $('#product_category').select2({
                placeholder: '-- Pilih Kategori Produk --'
            });
            $('#product_category').on('change', function () {
                var selectedCategories = $(this).find(':selected');
                selectedCategories.each(function () {
                    var categoryName = $(this).data('name');
                    $('#' + categoryName).show();
                });
            });

            $('#product_category').on('select2:unselect', function (e) {
                var unselectedCategory = e.params.data.id;
                $('#' + unselectedCategory).hide();
            });
            $('#outlet-categories').select2({
                minimumResultsForSearch: Infinity
            });
            $('#downloadTemplate').on('click', function () {
                window.location.href = "{{asset('assets/template/template_bulk_routing.xlsx')}}";
            })
            function handleSuccess(modalId, message) {
                toggleLoading(false, 'update');
                closeModal(modalId);
                toast('success', message, 150);
                setTimeout(() => window.location.reload(), 1500);
            }
            $('#importBtn').click(function () {
                const file = $('#file_upload')[0].files[0];
                if (!file) {
                    return toast('error', 'Silakan pilih file terlebih dahulu', 200);
                }

                const formData = new FormData();
                formData.append('excel_file', file);
                toggleLoading(true, 'import');

                $.ajax({
                    url: '/routing/bulk',
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function (response) {
                        handleSuccess('unggah-routing-bulk', response.message);
                    },
                    error: function (xhr) {
                        toggleLoading(false, 'import');
                        toast('error', xhr.responseJSON.message, 200);
                    }
                });
            });
        });
    </script>
@endpush

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
    $(document).ready(function () {
        $('#week').select2({
            minimumResultsForSearch: Infinity,
            placeholder: "-- Pilih Week --"
        });
        
        const weekContainer = document.getElementById('week-container');
        
        const weekOptions = {
            '1x4': [
                {name: 'Week 1', value: '1'},
                {name: 'Week 2', value: '2'},
                {name: 'Week 3', value: '3'},
                {name: 'Week 4', value: '4'}
            ],
            '1x2': [
                {name: 'Week 1 & 3', value: '13'},
                {name: 'Week 2 & 4', value: '24'}
            ]
        };

        function updateWeekOptions(cycle) {
            const weekSelect = $('#week');
            weekSelect.empty();
            
            // Destroy and reinitialize select2
            if (weekSelect.data('select2')) {
                weekSelect.select2('destroy');
            }
            
            weekSelect.append(`<option value="" selected disabled>-- Pilih Week --</option>`);

            if (cycle === '1x2' || cycle === '1x4') {
                weekContainer.classList.remove('hidden');
                const options = weekOptions[cycle];
                
                options.forEach(option => {
                    weekSelect.append(new Option(option.name, option.value));
                });
                
                // Make week field required
                weekSelect.prop('required', true);
            } else {
                weekContainer.classList.add('hidden');
                weekSelect.val('').prop('required', false);
            }

            // Reinitialize select2
            weekSelect.select2({
                minimumResultsForSearch: Infinity,
                placeholder: "-- Pilih Week --",
                width: '100%'
            });
        }

        // Handle cycle change
        $('#cycle').on('change', function() {
            const selectedCycle = $(this).val();
            updateWeekOptions(selectedCycle);
        });

        // Form submission validation
        $('form').on('submit', function(e) {
            const cycle = $('#cycle').val();
            const week = $('#week').val();
            
            if ((cycle === '1x2' || cycle === '1x4') && !week) {
                e.preventDefault();
                alert('Mohon pilih Week terlebih dahulu');
                return false;
            }
        });

        // Initialize with current value if exists
        const initialCycle = $('#cycle').val();
        if (initialCycle) {
            updateWeekOptions(initialCycle);
            
            // Set initial week value if exists
            const initialWeek = "{{ old('week') }}";
            if (initialWeek) {
                $('#week').val(initialWeek).trigger('change');
            }
        }
    });


        $(document).ready(function () {
        // Existing Select2 initialization
        $('#product_category').on('change', function () {
            // Hide all product sections first
            $('[id^="category-"]').hide();
            
            var selectedCategories = $(this).find(':selected');
            selectedCategories.each(function () {
                var categoryName = $(this).data('name');
                $('#' + categoryName).show();
                
                // Initialize AV3M inputs for visible products
                $('#' + categoryName + ' .av3m-input').prop('required', true);
            });

            // Make AV3M inputs not required for hidden sections
            $('[id^="category-"]:hidden .av3m-input').prop('required', false);
        });

        // Handle numeric validation for AV3M inputs
        $('.av3m-input').on('input', function() {
            var value = $(this).val();
            if (value < 0) {
                $(this).val(0);
            }
        });

        // Form validation for AV3M
        $('form').on('submit', function(e) {
            var hasError = false;
            $('.av3m-input:visible').each(function() {
                if ($(this).val() === '') {
                    hasError = true;
                    $(this).addClass('is-invalid');
                } else {
                    $(this).removeClass('is-invalid');
                }
            });

            if (hasError) {
                e.preventDefault();
                alert('Mohon isi semua data AV3M untuk produk yang dipilih');
                return false;
            }
        });
    });

    $(document).ready(function() {
    // Form submission handling
    $('form').on('submit', function(e) {
        e.preventDefault();
        
        // Reset any previous errors
        resetFormErrors();
        
        // Show loading state
        toggleLoading(true, 'submit');
        
        // Create FormData object to handle file uploads
        const formData = new FormData(this);
        
        $.ajax({
            url: $(this).attr('action'),
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(response) {
                // Show success message
                toast('success', response.message, 300);
                
                // Redirect after delay
                setTimeout(() => {
                    window.location.href = "{{ route('routing.index') }}";
                }, 1500);
            },
            error: function(xhr) {
                toggleLoading(false, 'submit');
                
                if (xhr.status === 422) {
                    // Validation errors
                    handleFieldErrors(xhr.responseJSON.errors);
                } else {
                    // General error
                    toast('error', xhr.responseJSON.message || 'Terjadi kesalahan', 200);
                }
            }
        });
    });

    // Helper functions
    function resetFormErrors() {
        $('.text-red-500').addClass('hidden');
        $('input, select').removeClass('border-red-500');
    }

    function handleFieldErrors(errors) {
        $.each(errors, function(key, value) {
            $(`#${key}-error`).text(value[0]).removeClass('hidden');
            $(`[name="${key}"]`).addClass('border-red-500');
        });
    }

    function toggleLoading(show, btnId) {
        const $btn = $(`#${btnId}Btn`);
        const $btnText = $(`#${btnId}BtnText`);
        const $btnLoading = $(`#${btnId}BtnLoading`);
        
        if (show) {
            $btnText.addClass('hidden');
            $btnLoading.removeClass('hidden');
            $btn.prop('disabled', true);
        } else {
            $btnText.removeClass('hidden');
            $btnLoading.addClass('hidden');
            $btn.prop('disabled', false);
        }
    }
});

    function deleteOutlet(id) {
            if (confirm('Apakah Anda yakin ingin menghapus outlet ini?')) {
                $.ajax({
                    url: `/routing/${id}`,
                    type: 'DELETE',
                    data: {
                        _token: '{{ csrf_token() }}'
                    },
                    success: function(response) {
                        if (response.status === 'success') {
                            // Refresh datatable atau redirect
                            toast('success', response.message);
                            setTimeout(() => window.location.reload(), 1500);
                        } else {
                            toast('error', response.message);
                        }
                    },
                    error: function(xhr) {
                        toast('error', 'Gagal menghapus outlet');
                    }
                });
            }
        }
        
    </script>
@endpush

@push('scripts')
    <script>
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
    </script>
@endpush
