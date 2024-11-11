@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Routing'" />
@endsection

@section('dashboard-content')
<div class="w-full">
    <form>
        <x-card>
            <x-slot:cardTitle>
                Tambah Daftar Outlet
            </x-slot:cardTitle>

            <x-slot:cardAction>
                <x-button.primary type="button" data-bs-toggle="modal" data-bs-target="#modalUpload" class="col-3">
                    Unggah Secara Bulk
                </x-button.primary>
            </x-slot:cardAction>

            @error('img_front')
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @enderror

            @error('img_banner')
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @enderror

            @error('img_main_road')
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @enderror

            @error('err')
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @enderror

            {{-- @if (session('success'))
                <div class="alert alert-info alert-dismissible fade show" role="alert">
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            @endif --}}

            <div class="grid grid-cols-2 gap-6 items-center">
                <div class="col-6">
                    <div class="mb-4">
                        <label for="name" class="form-label">Nama Outlet</label>
                        <input id="name" class="form-control @error('formData.name') is-invalid @enderror"
                            type="text" name="name" wire:model="formData.name"
                            placeholder="Masukan nama outlet" />
                        		@error('formData.name')
                            <div class="invalid-feedback">
                            </div>
                        @enderror
                    </div>
                </div>
                <div class="col-6" >
                    <label for="sales" class="form-label">Nama Sales</label>
                    <select id="sales" name="sales"
                        class="form-select-search @error('formData.sales') is-invalid @enderror">
                        <option value="" selected>
                            -- Pilih nama sales yang ditugaskan --
                        </option>
                        {{-- @foreach ($this->sales as $option)
                            <option value="{{ $option['id'] }}">
                                {{ $option['name'] }}
                            </option>
                        @endforeach --}}
                    </select>
                    {{-- @error('formData.sales')
                        <div class="invalid-feedback">
                            {{ $message }}
                        </div>
                    @enderror --}}
                </div>
                <div class="col-6" wire:ignore>
                    <label for="outlet_category" class="form-label">Kategori Outlet</label>
                    <select id="outlet_category" name="outlet_category" 
                        class="form-select-search">
                        <option value="" selected>
                            -- Pilih Kategori Outlet --
                        </option>
                        <option value="MT">MT</option>
                        <option value="GT">GT</option>
                    </select>
                    {{-- @error('formData.outlet_category')
                        <div class="invalid-feedback">
                            {{ $message }}
                        </div>
                    @enderror --}}
                </div>
                <div class="col-6" >
                    <label for="visit_day" class="form-label">Waktu Kunjungan</label>
                    <select id="visit_day" name="visit_day"
                        class="form-select-search @error('formData.visit_day') is-invalid @enderror">
                        <option value="" selected>
                            -- Pilih waktu kunjungan --
                        </option>
                        {{-- @foreach ($days as $key => $day)
                            <option value="{{ $key }}">{{ $day }}</option>
                        @endforeach --}}
                    </select>
                    {{-- @error('formData.visit_day')
                        <div class="invalid-feedback">
                            {{ $message }}
                        </div>
                    @enderror --}}
                </div>
                <div class="col-6 mt-4">
                    <label for="cycle" class="form-label">Cycle</label>
                    <select id="cycle" name="cycle" 
                        class="form-select">
                        <option value="" selected>
                            -- Pilih Cycle --
                        </option>
                        <option value="1x1">1x1</option>
                        <option value="1x2">1x2</option>
                    </select>
                    {{-- @error('cycle')
                        <div class="invalid-feedback">
                            {{ $message }}
                        </div>
                    @enderror --}}
                </div>
                {{-- @if ($showWeek)
                    <div class="col-6 mt-4">
                        <label for="week" class="form-label">Week</label>
                        <select id="week" name="week" wire:model="week"
                            class="form-select @error('week') is-invalid @enderror">
                            <option value="" selected>
                                -- Pilih Week --
                            </option>
                            <option value="EVEN">Genap</option>
                            <option value="ODD">Ganjil</option>
                        </select>
                        @error('week')
                            <div class="invalid-feedback">
                                {{ $message }}
                            </div>
                        @enderror
                    </div>
                @endif --}}
            </div>

            <x-section-card :title="'Produk'">

                    <div class="flex " >
                        <label for="category_product" class="form-label">Kategori Produk</label>
                        <select id="category_product" name="category_product"
                            class="form-select-search" multiple>
                            <option value="" data-placeholder="true">
                                -- Pilih Kategori Produk --
                            </option>
                            {{-- @foreach ($this->productCategories as $category)
                                <option value="{{ $category['id'] }}">{{ $category['name'] }}</option>
                            @endforeach --}}
                        </select>
                        {{-- @error('category_product')
                            <div class="invalid-feedback">
                                {{ $message }}
                            </div>
                        @enderror --}}
                    </div>
			</x-section-card>

                    {{-- @forelse ($master_products as $key => $products)
                        <h6 class="text-info fst-normal mb-3 mt-4">{{ $key }}</h6>
                        @foreach ($products as $product)
                            <div class="row d-flex align-items-center">
                                <div class="col-6 mb-3">
                                    <span class="d-block">{{ $product['sku'] }}</span>
                                </div>
                                <div class="col-6 mb-3">
                                    <div class="row">
                                        <div class="col-6 text-start">
                                            <label for="av3m_{{ $product['id'] }}" class="form-label">AV3M</label>
                                            <input id="av3m_{{ $product['id'] }}" class="form-control text-center" type="number" name="av3m-{{ $product['id'] }}"
                                                value="0" min="0" wire:model="formMasterProducts.{{ $product['id'] }}" placeholder="0" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        @endforeach --}}

                        {{-- @if (!$loop->last)
                            <div class="row d-flex justify-content-center border-bottom-dashed"></div>
                        @endif
                    @empty
                        
                    @endforelse --}}
                <x-section-card :title="'Area Domisili Outlet'" class="mt-3">
						<div class="row">
							<div class="col-6">
								<div class="mb-4">
									<label for="longitude" class="form-label">Longtitudes (DD Coordinates)</label>
									<input id="longitude"
										class="form-control"
										type="text" name="longitude"
										placeholder="Masukan longtitude area outlet" />
									{{-- @error('formData.longitude')
										<div class="invalid-feedback">
											{{ $message }}
										</div>
									@enderror --}}
								</div>
							</div>
							<div class="col-6">
								<div class="mb-4">
									<label for="latitude" class="form-label">Latitudes (DMS Coordinates)</label>
									<input id="latitude"
										class="form-control val_latitude @error('formData.latitude') is-invalid @enderror"
										type="text" wire:model="formData.latitude" name="latitude"
										placeholder="Masukan latitude area outlet" />
									{{-- @error('formData.latitude')
										<div class="invalid-feedback">
											{{ $message }}
										</div>
									@enderror --}}
								</div>
							</div>
	
							<div class="col-6" wire:ignore>
								<div class="mb-4">
									<label for="city" class="form-label">Kabupaten/Kota</label>
									<select id="city" name="city"
										class="form-select-search @error('formData.city') is-invalid @enderror">
										<option value="" selected>
											-- Pilih Kabupaten/kota --
										</option>
										{{-- @foreach ($this->city as $option)
											<option value="{{ $option['name'] }}">
												{{ $option['name'] }}
											</option>
										@endforeach --}}
									</select>
									{{-- @error('formData.city')
										<div class="invalid-feedback">
											{{ $message }}
										</div>
									@enderror --}}
								</div>
							</div>
	
							<div class="col-6">
								<div class="mb-4">
									<label for="address" class="form-label">Alamat Lengkap</label>
									<input id="address"
										class="form-control val_address @error('formData.address') is-invalid @enderror"
										type="text" wire:model="formData.address" name="address"
										placeholder="Masukan alamat lengkap" />
									{{-- @error('formData.address')
										<div class="invalid-feedback">
											{{ $message }}
										</div>
									@enderror --}}
								</div>
							</div>
						</div>
	
						{{-- <div class="row">
							<div class="col-12" id="map">
								<div class="card w-100 border-primary" style="height: 18rem;" id="geomap" wire:ignore>
								</div>
								<div id="mapsTextbox" wire:ignore>
									<p class="text_province">-</p>
								</div>
							</div>
						</div> --}}
                </x-section-card>

                <x-section-card :title="'Tambahkan Foto Outlet'" class="mt-3">
                    <x-slot:cardTitle>
                    </x-slot:cardTitle>
                </x-section-card>

                {{-- <x-card-body>
                    <div class="row">
                        <div class="col-2 text-center d-flex flex-column align-items-center">
                            <div class="upload-mini mx-3 w-100 position-relative">
                                <div class="d-flex justify-content-center align-items-center flex-column py-2">
                                    <div class="upload {{ $img_front ? 'd-none' : '' }}" data-id="img_front">
                                        <svg width="30" height="63" viewBox="0 0 64 63" fill="none"
                                            xmlns="http://www.w3.org/2000/svg">
                                            <path
                                                d="M28 43.2577C28 45.4323 29.7909 47.1952 32 47.1952C34.2091 47.1952 36 45.4323 36 43.2577V15.074L48.971 27.8423L54.6279 22.2739L32.0005 0L9.37305 22.2739L15.0299 27.8423L28 15.0749V43.2577Z"
                                                fill="#39B5FF" />
                                            <path
                                                d="M0 39.375H8V55.125H56V39.375H64V55.125C64 59.4742 60.4183 63 56 63H8C3.58172 63 0 59.4742 0 55.125V39.375Z"
                                                fill="#39B5FF" />
                                        </svg>
                                        <h5 class="text-info fw-medium">Klik disini untuk unggah foto</h5>
                                        <p class="text-info fw-light">Ukuran maksimal foto <strong>2MB</strong></p>
                                    </div>
                                    @if ($img_front)
                                        <img src="{{ $img_front->temporaryUrl() }}" alt="image-routing"
                                            class="w-75" />
                                        <button class="btn p-0 position-absolute bottom-0 end-0 delete-icon"
                                            wire:click.prevent="remove('img_front')">
                                            <img src="{{ asset('images/icons/delete.svg') }}" alt="as"
                                                class="" />
                                        </button>
                                    @endif
                                </div>
                                <input type="file" name="file" wire:model="img_front" id="img_front"
                                    class="visually-hidden" accept="image/png, image/jpeg">
                            </div>
                            <label class="text-center mt-3" for="img_banner" style="font-size: 10px;">Foto tampak
                                depan outlet</label>
                        </div>
                        <div class="col-2 text-center d-flex flex-column align-items-center">
                            <div class="upload-mini mx-3 w-100 position-relative">
                                <div class="d-flex justify-content-center align-items-center flex-column py-2">
                                    <div class="upload {{ $img_banner ? 'd-none' : '' }}" data-id="img_banner">
                                        <svg width="30" height="63" viewBox="0 0 64 63" fill="none"
                                            xmlns="http://www.w3.org/2000/svg">
                                            <path
                                                d="M28 43.2577C28 45.4323 29.7909 47.1952 32 47.1952C34.2091 47.1952 36 45.4323 36 43.2577V15.074L48.971 27.8423L54.6279 22.2739L32.0005 0L9.37305 22.2739L15.0299 27.8423L28 15.0749V43.2577Z"
                                                fill="#39B5FF" />
                                            <path
                                                d="M0 39.375H8V55.125H56V39.375H64V55.125C64 59.4742 60.4183 63 56 63H8C3.58172 63 0 59.4742 0 55.125V39.375Z"
                                                fill="#39B5FF" />
                                        </svg>
                                        <h5 class="text-info fw-medium">Klik disini untuk unggah foto</h5>
                                        <p class="text-info fw-light">Ukuran maksimal foto <strong>2MB</strong></p>
                                    </div>
                                    @if ($img_banner)
                                        <img src="{{ $img_banner->temporaryUrl() }}" alt="image-routing"
                                            class="w-75" />
                                        <button class="btn p-0 position-absolute bottom-0 end-0 delete-icon"
                                            wire:click.prevent="remove('img_banner')">
                                            <img src="{{ asset('images/icons/delete.svg') }}" alt="as"
                                                class="" />
                                        </button>
                                    @endif
                                </div>
                                <input type="file" name="file" wire:model="img_banner" id="img_banner"
                                    class="visually-hidden" accept="image/png, image/jpeg">
                            </div>
                            <label class="text-center mt-3" for="img_banner" style="font-size: 10px;">Foto
                                Spanduk/Banner/Neon Box</label>
                        </div>
                        <div class="col-2 text-center d-flex flex-column align-items-center">
                            <div class="upload-mini mx-3 w-100 position-relative">
                                <div class="d-flex justify-content-center align-items-center flex-column py-2">
                                    <div class="upload {{ $img_main_road ? 'd-none' : '' }}" data-id="img_main_road">
                                        <svg width="30" height="63" viewBox="0 0 64 63" fill="none"
                                            xmlns="http://www.w3.org/2000/svg">
                                            <path
                                                d="M28 43.2577C28 45.4323 29.7909 47.1952 32 47.1952C34.2091 47.1952 36 45.4323 36 43.2577V15.074L48.971 27.8423L54.6279 22.2739L32.0005 0L9.37305 22.2739L15.0299 27.8423L28 15.0749V43.2577Z"
                                                fill="#39B5FF" />
                                            <path
                                                d="M0 39.375H8V55.125H56V39.375H64V55.125C64 59.4742 60.4183 63 56 63H8C3.58172 63 0 59.4742 0 55.125V39.375Z"
                                                fill="#39B5FF" />
                                        </svg>
                                        <h5 class="text-info fw-medium">Klik disini untuk unggah foto</h5>
                                        <p class="text-info fw-light">Ukuran maksimal foto <strong>2MB</strong></p>
                                    </div>
                                    @if ($img_main_road)
                                        <img src="{{ $img_main_road->temporaryUrl() }}" alt="image-routing"
                                            class="w-75" />
                                        <button class="btn p-0 position-absolute bottom-0 end-0 delete-icon"
                                            wire:click.prevent="remove('img_main_road')">
                                            <img src="{{ asset('images/icons/delete.svg') }}" alt="as"
                                                class="" />
                                        </button>
                                    @endif
                                </div>
                                <input type="file" name="file" wire:model="img_main_road" id="img_main_road"
                                    class="visually-hidden" accept="image/png, image/jpeg">
                            </div>
                            <label class="text-center mt-3" for="img_main_road" style="font-size: 10px;">Foto jalan
                                utama outlet</label>
                        </div>
                    </div>
                </x-card-body>

                <x-card-header class="mt-3">
                    <x-slot:cardTitle>
                        Formulir Survey Outlet
                    </x-slot:cardTitle>
                </x-card-header>

                <x-card-body>
                    <div class="row">
                        <div class="col-12">
                            <table class="table table-striped align-middle w-100">
                                <tbody>
                                    @foreach ($this->formSurvey as $input)
                                        <tr>
                                            <th scope="row">{{ $input['question'] }}</th>
                                            <td class="col-2">
                                                @if ($input['type'] === 'bool')
                                                    <div class="btn-group w-100 shadow-sm border-0" role="group"
                                                        aria-label="Basic radio toggle button group">
                                                        <input type="radio"
                                                            class="btn-check @error('formData.forms.' . $input['id']) is-invalid @enderror"
                                                            value="1"
                                                            wire:model="formData.forms.{{ $input['id'] }}"
                                                            name="btnradio" id="btnradio1">
                                                        <label
                                                            class="btn btn-sm p-2 btn-outline-light shadow-sm text-info"
                                                            for="btnradio1">Sudah</label>

                                                        <input type="radio"
                                                            class="btn-check @error('formData.forms.' . $input['id']) is-invalid @enderror"
                                                            value="0"
                                                            wire:model="formData.forms.{{ $input['id'] }}"
                                                            name="btnradio" id="btnradio3" autocomplete="off">
                                                        <label
                                                            class="btn btn-sm p-2 btn-outline-light shadow-sm text-info"
                                                            for="btnradio3">Belum</label>
                                                    </div>
                                                @else
                                                    <input
                                                        class="form-control border-0 shadow-md text-primary @error('formData.forms.' . $input['id']) is-invalid @enderror"
                                                        type="text"
                                                        wire:model="formData.forms.{{ $input['id'] }}"
                                                        name="{{ $input['id'] }}" placeholder="Masukan jumlah" />
                                                @endif
                                                @error('formData.forms.' . $input['id'])
                                                    <div class="invalid-feedback">
                                                        {{ $message }}
                                                    </div>
                                                @enderror
                                            </td>
                                        </tr>
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                    </div>
                </x-card-body> --}}
            <x-slot:cardFooter>
                <x-button.primary class="w-100 py-3" >Konfirmasi</x-button.primary>
            </x-slot:cardFooter>
        </x-card>
    </form>
</div>
@endsection

@push('addon-script')
    <script type="text/javascript"
        src="https://maps.googleapis.com/maps/api/js?key={{ config('services.api.maps.api_key') }}&callback=Function.prototype">
    </script>
    <script>
        //MAPS
        document.addEventListener('livewire:initialized', () => {
            var geocoder;
            var map;
            var marker;

            function initialize() {
                var initialLat = $('.val_latitude').val();
                var initialLong = $('.val_longitude').val();

                function updateMap(lat, long) {
                    var latlng = new google.maps.LatLng(lat, long);
                    map.setCenter(latlng);
                    marker.setPosition(latlng);

                    geocoder.geocode({
                        'location': latlng
                    }, function(results, status) {
                        if (status === 'OK') {
                            if (results[0]) {
                                console.log(results)
                                var addressComponents = results[0].address_components;
                                var province;

                                for (var i = 0; i < addressComponents.length; i++) {
                                    var types = addressComponents[i].types;
                                    if (types.includes('administrative_area_level_1')) {
                                        province = addressComponents[i].long_name;
                                    }

                                }

                                $('.text_province').text(province);

                                @this.set('formData.latitude', lat);
                                @this.set('formData.longitude', long);
                                @this.set('formData.address', results[0].formatted_address);

                            } else {
                                console.error('No results found');
                            }
                        } else {
                            console.error('Geocoder failed due to: ' + status);
                        }
                    });
                }

                var latlng = new google.maps.LatLng(initialLat, initialLong);
                var options = {
                    zoom: 17,
                    center: latlng,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                };

                map = new google.maps.Map(document.getElementById("geomap"), options);

                geocoder = new google.maps.Geocoder();

                marker = new google.maps.Marker({
                    map: map,
                    draggable: true,
                    position: latlng
                });

                // Update on input events
                $('.val_latitude, .val_longitude').on('input', function() {

                    var lat = document.getElementById('latitude').value;
                    var long = document.getElementById('longitude').value;

                    updateMap(lat, long);
                });

                $('#address').on('keyup', function(event) {
                    if (event.key === 'Enter') {
                        var address = $('#address').val();
                        geocoder.geocode({
                            'address': address
                        }, function(results, status) {
                            if (status === 'OK') {
                                var result = results[0];
                                map.setCenter(result.geometry.location);
                                marker.setPosition(result.geometry.location);

                                var lat = result.geometry.location.lat();
                                var long = result.geometry.location.lng();
                                updateMap(lat, long);
                            } else {
                                console.error(
                                    'Geocode was not successful for the following reason: ' +
                                    status);
                            }
                        });
                    }
                });

                // Geolocation
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(function(position) {

                        var currentLat = document.getElementById('latitude').value;
                        var currentLong = document.getElementById('longitude').value;

                        if (currentLat === '' && currentLong === '') {
                            currentLat = position.coords.latitude;
                            currentLong = position.coords.longitude;
                        }

                        console.log(currentLat, currentLong);

                        updateMap(currentLat, currentLong);
                    }, function(error) {
                        console.error("Error getting geolocation: " + error.message);
                    });
                } else {
                    console.error("Geolocation is not supported by this browser.");
                }
            }

            $(document).ready(function() {

                google.maps.event.addListener(marker, 'drag', function() {
                    geocoder.geocode({
                        'latLng': marker.getPosition()
                    }, function(results, status) {
                        if (status === google.maps.GeocoderStatus.OK) {
                            if (results[0]) {
                                @this.set('formData.latitude', marker.getPosition().lat());
                                @this.set('formData.longitude', marker.getPosition().lng());
                                @this.set('formData.address', results[0].formatted_address);

                                let arrLoc = results[0].address_components;

                                for (let i = 0; i < arrLoc.length; i++) {
                                    if (arrLoc[i].types[0] ===
                                        'administrative_area_level_1') {
                                        let getProv = arrLoc[i].long_name;
                                        $('.text_province').text(getProv);
                                    }
                                }
                            }
                        }
                    });
                });
            });

            initialize();

        });
    </script>
@endpush

<script type="module">
    $('.upload').on('click', function() {
        $(`#${$(this).data('id')}`).click()
    })
</script>

@push('addon-toast')
    <x-toast>
        <x-slot:title>
            Data Berhasil Disimpan
        </x-slot:title>
        <x-slot:subTitle>
            Anda baru saja menambahkan data pada aplikasi. Silahkan periksa perubahan pada menu yang Anda tambahkan
        </x-slot:subTitle>
    </x-toast>
@endpush

@push('addon-style')
    {{-- <link href="{{ asset('assets/slim-select/slimselect.css') }}" rel="stylesheet"> --}}
@endpush

@push('addon-script')
    {{-- <script src="{{ asset('assets/slim-select/slimselect.min.js') }}"></script> --}}

    <script>
        var dataSelect = ['sales', 'outlet_category', 'visit_day', 'category_product', 'city'];

        dataSelect.forEach(function(data) {
            new SlimSelect({
                select: '#' + data,
                settings: {
                    searchText: 'Tidak ditemukan.',
                    searchPlaceholder: 'Cari data',
                    openPosition: 'down',
                }
            });
        });
    </script>
@endpush