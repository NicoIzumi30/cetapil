@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Selling'" />
@endsection

@section('dashboard-content')
    <x-card>
        <x-slot:cardTitle>
            Edit Daftar Selling
        </x-slot:cardTitle>

	
			<div class="grid grid-cols-2 gap-4">
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
					<label for="outlet-name">Nama Outlet</label>
					<select id="outlet-name" name="outlet-name" class=" w-full">
						<option value="" selected disabled>
							-- Pilih Nama outlet --
						</option>
						<option value="cleanser">
							SunProtect
						</option>
					</select>
				</div>
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

	
			<div class="border-b-2 border-dashed py-6">
				<h3 class="font-bold text-2xl text-white py-2 mb-6">
					Cleanser
				</h3>
				<div class="grid grid-cols-2 items-center my-2">
					<p class="text-white">Cetaphil Baby Daily Lotion with Organic Calendula 500ml</p>
					<div class="flex items-center gap-4">
						<div>
							<label for="stock-500" class="form-label">Stock</label>
							<input id="stock-500" class="form-control" type="text" name="stock-500" placeholder="Masukan Jumlah Stock"
								aria-describedby="stock-500" />
						</div>
						<div>
							<label for="selling-500" class="form-label">Selling</label>
							<input id="selling-500" class="form-control" type="text" name="selling-500" placeholder="Masukan Jumlah Selling"
								aria-describedby="selling-500" />
						</div>
						<div>
							<label for="balance-500" class="form-label">Balance</label>
							<input id="balance-500" class="form-control" type="text" name="balance-500" placeholder="Masukan Jumlah Balance"
								aria-describedby="balance-500" />
						</div>
					</div>
				</div>
			</div>
	
			<div class="border-b-2 border-dashed py-6">
				<h3 class="font-bold text-2xl text-white py-2 mb-6">
					Baby Treatment
				</h3>
				<div class="grid grid-cols-2 items-center my-2">
					<p class="text-white">Cetaphil Baby Daily Lotion with Organic Calendula 400ml</p>
					<div class="flex items-center gap-4">
						<div>
							<label for="stock-400" class="form-label">Stock</label>
							<input id="stock-400" class="form-control" type="text" name="stock-400" placeholder="Masukan Jumlah Stock"
								aria-describedby="stock-400" />
						</div>
						<div>
							<label for="selling-400" class="form-label">Selling</label>
							<input id="selling-400" class="form-control" type="text" name="selling-400" placeholder="Masukan Jumlah Selling"
								aria-describedby="selling-400" />
						</div>
						<div>
							<label for="balance-400" class="form-label">Balance</label>
							<input id="balance-400" class="form-control" type="text" name="balance-400" placeholder="Masukan Jumlah Balance"
								aria-describedby="balance-400" />
						</div>
					</div>
				</div>
			</div>
	
			<div class="grid grid-cols-2 items-center my-6">
				<p class="text-white">Cetaphil Baby Daily Lotion with Organic Calendula 200ml</p>
				<div class="flex items-center gap-4">
					<div>
						<label for="stock-200" class="form-label">Stock</label>
						<input id="stock-200" class="form-control" type="text" name="stock-200" placeholder="Masukan Jumlah Stock"
							aria-describedby="stock-200" />
					</div>
					<div>
						<label for="selling-200" class="form-label">Selling</label>
						<input id="selling-200" class="form-control" type="text" name="selling-200" placeholder="Masukan Jumlah Selling"
							aria-describedby="selling-200" />
					</div>
					<div>
						<label for="balance-200" class="form-label">Balance</label>
						<input id="balance-200" class="form-control" type="text" name="balance-200" placeholder="Masukan Jumlah Balance"
							aria-describedby="balance-200" />
					</div>
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
				<div class="flex flex-col items-center w-full">
					<div class="relative w-full mx-3 border-red">
						<div class="flex justify-center items-center flex-col py-2 h-[260px]">
							{{-- Upload Area --}}
							<div class="cursor-pointer text-center hidden place-items-center border-2 border-dashed border-blue-400 rounded-lg p-4 w-full h-full"
								id="upload-area-outlet">
								<div class="text-center grid place-items-center">
									<svg width="30" height="63" viewBox="0 0 64 63" fill="none" xmlns="http://www.w3.org/2000/svg">
										<path
											d="M28 43.2577C28 45.4323 29.7909 47.1952 32 47.1952C34.2091 47.1952 36 45.4323 36 43.2577V15.074L48.971 27.8423L54.6279 22.2739L32.0005 0L9.37305 22.2739L15.0299 27.8423L28 15.0749V43.2577Z"
											fill="#fff" />
										<path
											d="M0 39.375H8V55.125H56V39.375H64V55.125C64 59.4742 60.4183 63 56 63H8C3.58172 63 0 59.4742 0 55.125V39.375Z"
											fill="#fff" />
									</svg>
									<h5 class="text-white font-bold text-xl mt-2">Klik disini untuk mulai mengunggah gambar</h5>
									<p class="text-white font-light text-sm">
										Ukuran maksimal foto <strong class="font-bold"> 5 MB</strong>
									</p>
								</div>
							</div>
				
							{{-- Preview Container --}}
							<div id="preview-container-outlet" class="w-full relative border-2 border-dashed border-blue-400 rounded-lg">
								<img id="preview-image-outlet" src="{{ asset('assets/images/banner-placeholder.png') }}" alt="Preview" 
									class="w-full h-[260px] mx-auto rounded-lg object-contain" />
								<button type="button"
									class="absolute bottom-2 right-2 bg-white p-2 rounded-full shadow-md hover:bg-gray-100 transition-colors"
									onclick="removeImage('outlet')">
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
						<input type="file" name="outlet" id="img_outlet" class="hidden"
							accept="image/png, image/jpeg" onchange="previewImage(this, 'outlet', 5)">
					</div>
				</div>
			</x-section-card>

			<x-button.info class="w-full mt-20 !text-xl">Konfirmasi</x-button.info>

		</x-card>
	@endsection
	
	@push('scripts')
		<script>
			$(document).ready(function() {
				$('#sales-names').select2();
				$('#outlet-name').select2();
				$('#product-categories').select2();
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