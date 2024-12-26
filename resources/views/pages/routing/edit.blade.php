@extends('layouts.main')

@section('banner-content')
<x-banner-content :title="'Routing'" />
@endsection

@section('dashboard-content')
<x-card>
    <x-slot:cardTitle>
        Detail Daftar Outlet
    </x-slot:cardTitle>
    <form action="{{ route('routing.update', $outlet->id) }}" method="POST" enctype="multipart/form-data">
        @csrf
        @method('PUT')
        <div class="grid grid-cols-2 gap-4">
            <div>
                <label for="name" class="form-label">Nama Outlet</label>
                <input id="name" class="form-control @error('name') is-invalid @enderror" type="text" name="name"
                    value="{{$outlet->name}}" placeholder="Masukan nama outlet" aria-describedby="name" />
                @if ($errors->has('name'))
                    <span id="name-error" class="text-sm text-red-600 mt-1">{{ $errors->first('name') }}</span>
                @endif
            </div>
            <div>
                <label for="code" class="form-label">Kode Outlet</label>
                <input id="code" class="form-control @error('code') is-invalid @enderror" value="{{$outlet->code}}" type="text" name="code"
                    placeholder="Masukan nama outlet" aria-describedby="name" />
                @if ($errors->has('code'))
                    <span id="code-error" class="text-sm text-red-600 mt-1">{{ $errors->first('code') }}</span>
                @endif
            </div>
            <div>
                <label for="outlet_type" class="form-label">Tipe Outlet</label>
                <input id="outlet_type" class="form-control @error('outlet_type') is-invalid @enderror" 
                    value="{{ $outlet->tipe_outlet }}" {{-- Change from old() to outlet value --}}
                    type="text" name="outlet_type"
                    placeholder="Masukan tipe outlet" aria-describedby="outlet_type" />
                @if ($errors->has('outlet_type'))
                    <span id="outlet_type-error" class="text-sm text-red-600 mt-1">{{ $errors->first('outlet_type') }}</span>
                @endif
            </div>
            <div>
                <label for="account_type" class="form-label">Tipe Akun</label>
                <input id="account_type" class="form-control @error('account_type') is-invalid @enderror" 
                    value="{{ $outlet->account }}" {{-- Change from old() to outlet value --}}
                    type="text" name="account_type"
                    placeholder="Masukan tipe akun" aria-describedby="name" />
                @if ($errors->has('account_type'))
                    <span id="account_type-error" class="text-sm text-red-600 mt-1">{{ $errors->first('account_type') }}</span>
                @endif
            </div>
            <div>
                <label for="user_id">Nama Sales</label>
                <select id="user_id" name="user_id" class="w-full">
                    <option value="" selected disabled>
                        -- Pilih nama sales yang ditugaskan --
                    </option>
                    @foreach ($salesUsers as $sales)
                        <option value="{{ $sales->id }}" {{$sales->id == $outlet->user_id ? 'selected' : ''}}>
                            {{ $sales->name }}
                        </option>
                    @endforeach
                </select>
                @if ($errors->has('user_id'))
                    <span id="user_id-error" class="text-sm text-red-600 mt-1">{{ $errors->first('name') }}</span>
                @endif
            </div>
            <div>
                <label for="category">Kategori Outlet</label>
                <select id="category" name="category" class="w-full">
                    <option value="" selected disabled>
                        -- Pilih kategori outlet --
                    </option>
                    <option value="MT" {{$outlet->category == 'MT' ? 'selected' : ''}}>
                        MT
                    </option>
                    <option value="GT" {{$outlet->category == 'GT' ? 'selected' : ''}}>
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
                        <option value="{{$hari['value']}}" {{$hari['value'] == $outlet->visit_day ? 'selected' : ''}}>
                            {{$hari['name']}}
                        </option>
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
                        <option value="{{$cycle}}" {{$cycle == $outlet->cycle ? 'selected' : ''}}>{{$cycle}}</option>
                    @endforeach
                </select>
                @if ($errors->has('cycle'))
                    <span id="cycle-error" class="text-sm text-red-600 mt-1">{{ $errors->first('cycle') }}</span>
                @endif
            </div>
            <div id="week-container" class="@if(!in_array($outlet->cycle, ['1x2', '1x4'])) hidden @endif">
                <label for="week" class="form-label">Week</label>
                <select id="week" name="week" class="form-control @error('week') is-invalid @enderror">
                    <option value="" selected disabled>-- Pilih Week --</option>
                    @if($outlet->cycle === '1x2')
                        <option value="13" {{ $outlet->week === '1&3' ? 'selected' : '' }}>Week 1 & 3</option>
                        <option value="24" {{ $outlet->week === '2&4' ? 'selected' : '' }}>Week 2 & 4</option>
                    @elseif($outlet->cycle === '1x4')
                        @for($i = 1; $i <= 4; $i++)
                            <option value="{{ $i }}" {{ $outlet->week == $i ? 'selected' : '' }}>Week {{ $i }}</option>
                        @endfor
                    @endif
                </select>
                @error('week')
                    <span class="invalid-feedback" role="alert">
                        <strong>{{ $message }}</strong>
                    </span>
                @enderror
            </div>
            <div>
                <label for="channel">Channel</label>
                <select id="channel" name="channel" class="w-full">
                    <option value="" selected disabled>
                        -- Pilih Channel --
                    </option>
                    @foreach ($channels as $channel)
                        <option value="{{$channel->id}}" 
                            {{$channel->id == $outlet->channel_id ? 'selected' : ''}}>
                            {{$channel->name}}
                        </option>
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
                            <option 
                                value="{{ $category->id }}" data-name="{{ \Str::slug($category->name) }}" 
                                {{ $category->hasProductInOutlet ? 'selected' : '' }}>
                                {{ $category->name }}
                            </option>
                        @endforeach
                    </select>
                    @error('product_category')
                        <span id="product_category-error" class="text-sm text-red-600 mt-1">{{ $message }}</span>
                    @enderror
                </div>
            </div>
        </x-section-card>

        @foreach ($category->products as $product)
        
        @php
            $av3mValue = App\Models\Av3m::where('outlet_id', $outlet->id)
                ->where('product_id', $product->id)
                ->value('av3m') ?? 0;
        @endphp
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
                    value="{{ old('av3m.'.$product->sku, $av3mValue) }}"
                />
                @error('av3m.'.$product->sku)
                    <span class="text-red-500 text-sm">{{ $message }}</span>
                @enderror
            </div>
        </div>
    @endforeach

        <x-section-card :title="'Area Domisili Outlet'">
            <div class="grid grid-cols-2 gap-6">
                <div>
                    <label for="longitude" class="form-label">Longitudes <span class="font-normal">(DD
                            Coordinates)</span></label>
                    <input id="longitude" class="form-control @error('longtitude') is-invalid @enderror"
                        value="{{ $outlet->longitude }}" type="text" name="longitude"
                        placeholder="Masukkan Koordinat Longitude" aria-describedby="longitude" />
                    @if ($errors->has('longtitude'))
                        <span id="longtitude-error"
                            class="text-sm text-red-600 mt-1">{{ $errors->first('longtitude') }}</span>
                    @endif
                </div>
                <div>
                    <label for="latitude" class="form-label">Latitudes <span class="font-normal">(DMS
                            Coordinates)</span></label>
                    <input id="latitude" class="form-control @error('latitude') is-invalid @enderror"
                        value="{{ $outlet->latitude }}" type="text" name="latitude"
                        placeholder="Masukkan Koordinat Latitude" aria-describedby="latitude" />
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
                            <option value="{{$city->id}}" {{$city->id == ($outlet->city['id'] ?? '') ? 'selected' : ''}}>
                                {{$city->name}}</option>
                        @endforeach
                    </select>
                    @if ($errors->has('city'))
                        <span id="city-error" class="text-sm text-red-600 mt-1">{{ $errors->first('city') }}</span>
                    @endif
                </div>
                <div>
                    <label for="adresss" class="form-label">Alamat Lengkap</label>
                    <input id="adresss" class="form-control" value="{{ $outlet->address }}" type="text" name="adresss"
                        placeholder="Masukkan Alamat Lengkap" aria-describedby="adresss" />
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
            <div class="flex flex-col gap-6">
                @foreach ($outletForms as $form)
                    @if($form->type == 'bool')
                        <div class="flex justify-between items-center w-full">
                            <div class="flex justify-between items-center w-full">
                            <p class="text-white font-bold text-sm">{{$form->question}}</p>
                            <div class="relative inline-flex items-center">
                                <input type="checkbox" name="survey[{{$form->id}}]" id="gih-checkbox" checked value="{{$form->answers->where('outlet_id', $outlet->id)->first()?->answer ?? 'Sudah'}}"
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
                            </div>
                        </div>
                        </div>
                    @elseif($form->type == 'text')
                        <x-pages.routing.outlet-form>
                            <x-slot:title>{{$form->question}}</x-slot:title>
                            <x-slot:name>survey[{{$form->id}}]</x-slot:name>
                            <x-slot:value>{{ $form->answers->where('outlet_id', $outlet->id)->first()?->answer ?? '0' }}</x-slot:value>
                        </x-pages.routing.outlet-form>
                    @endif
                @endforeach
            </div>
            <x-button.info class="w-full mt-20 !text-xl" type="submit" id="submitBtn">
                <span id="submitBtnText">Simpan Perubahan</span>
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
            function handleCategoryChange() {
                // Sembunyikan dulu semua category fields
                $('.category-field').hide(); // Asumsikan semua field punya class 'category-field'

                // Ambil kategori yang dipilih
                var selectedCategories = $('#product_category').find(':selected');

                // Tampilkan field sesuai kategori yang dipilih
                selectedCategories.each(function () {
                    var categoryName = $(this).data('name');
                    $('#' + categoryName).show();
                });
            }
            handleCategoryChange();
            $('#product_category').on('change', handleCategoryChange);
            $('#product_category').on('select2:unselect', function (e) {
                var unselectedCategory = e.params.data.id;
                $('#' + unselectedCategory).hide();
            });
            $('#outlet-categories').select2({
                minimumResultsForSearch: Infinity
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
            const cycle = "{{ $outlet->cycle }}";
            if (cycle === '1x2' || cycle === '1x4') {
                $('#week-container').removeClass('hidden');
            }

            $('#cycle').on('change', function() {
                const selectedCycle = $(this).val();
                const weekContainer = $('#week-container');
                const weekSelect = $('#week');
                
                weekSelect.empty().append('<option value="" disabled selected>-- Pilih Week --</option>');
                
                if (selectedCycle === '1x2') {
                    weekContainer.removeClass('hidden');
                    weekSelect.append(`
                        <option value="13">Week 1 & 3</option>
                        <option value="24">Week 2 & 4</option>
                    `);
                } else if (selectedCycle === '1x4') {
                    weekContainer.removeClass('hidden');
                    for(let i = 1; i <= 4; i++) {
                        weekSelect.append(`<option value="${i}">Week ${i}</option>`);
                    }
                } else {
                    weekContainer.addClass('hidden');
                }
            });

            // Versi jQuery
            $('#cycle').change(function () {
                weekHandler($(this).val());
            });

            // Inisialisasi awal
            weekHandler($('#cycle').val());
            const gihCheckbox = document.querySelector('#gih-checkbox');
            const gihChecked = document.querySelector('#gih-checked');
            const gihUnChecked = document.querySelector('#gih-unchecked');
            
            if(gihCheckbox.value == 'Sudah') {
                $('#gih-checkbox').val('Sudah');
                gihChecked.classList.add("bg-blue-400", "!text-white");
                gihUnChecked.classList.remove("bg-blue-400", "!text-white");
            }else{
                $('#gih-checkbox').val('Belum');
                gihUnChecked.classList.add("bg-blue-400", "!text-white");
                gihChecked.classList.remove("bg-blue-400", "!text-white");
                gihChecked.classList.add("text-blue-400");
            }

            gihChecked.addEventListener('click', function () {
                $('#gih-checkbox').val('Sudah');
                gihChecked.classList.add("bg-blue-400", "!text-white");
                gihUnChecked.classList.remove("bg-blue-400", "!text-white");
            });
            gihUnChecked.addEventListener('click', function () {
                $('#gih-checkbox').val('Belum');
                gihUnChecked.classList.add("bg-blue-400", "!text-white");
                gihChecked.classList.remove("bg-blue-400", "!text-white");
                gihChecked.classList.add("text-blue-400");
            });

            // gihCheckbox.addEventListener('change', function () {
            //     if (this.checked) {
            //         gihChecked.classList.add("bg-blue-400", "!text-white");
            //         gihUnChecked.classList.remove("bg-blue-400", "!text-white");
            //     } else {
            //         gihUnChecked.classList.add("bg-blue-400", "!text-white");
            //         gihChecked.classList.remove("bg-blue-400", "!text-white");
            //         gihChecked.classList.add("text-blue-400");
            //     }
            // });
        });
    </script>
@endpush

@push('scripts')
<script>
$(document).ready(function() {
    // Initialize current product categories
    var currentCategories = $('#product_category').find(':selected');
    currentCategories.each(function() {
        var categoryName = $(this).data('name');
        $('#' + categoryName).show();
    });

    // Form submission handling
    $('form').on('submit', function(e) {
        e.preventDefault();
        
        // Reset any previous errors
        resetFormErrors();
        
        // Show loading state
        toggleLoading(true, 'submit');
        
        // Create FormData object
        const formData = new FormData(this);
        
        // Add PUT method for Laravel
        formData.append('_method', 'PUT');
        
        $.ajax({
            url: $(this).attr('action'),
            type: 'POST', // Always use POST for FormData
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

    // Handle product category changes
    $('#product_category').on('change', function() {
        var selectedCategories = $(this).find(':selected');
        
        // Hide all categories first
        $('[id^=category-]').hide();
        
        // Show selected categories
        selectedCategories.each(function() {
            var categoryName = $(this).data('name');
            $('#' + categoryName).show();
        });
    });
});
</script>
@endpush

