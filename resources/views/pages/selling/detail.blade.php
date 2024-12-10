@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Selling'" />
@endsection

@section('dashboard-content')
    <x-card>
        <x-slot:cardTitle>
            Detai Selling
        </x-slot:cardTitle>

	
			<div class="grid grid-cols-2 gap-4">
				<div>
					<label for="sales-name">Nama Sales</label>
					<input id="sales" class="form-control disabled"type="text" value="{{ $response['user']['name'] }}" name="sales" disabled aria-describedby="sales" />
				</div>
				<div>
					<label for="outlet-name">Nama Outlet</label>
					<input id="outlet" class="form-control"type="text" value="{{ $response['outlet_name'] }}" name="outlet" disabled aria-describedby="outlet" />
				</div>
			</div>

			@foreach ($response['products_by_category'] as $productsByCategory)
			<div class="border-b-2 border-dashed py-6">
				<h3 class="font-bold text-2xl text-white py-2 mb-6">
					{{ $productsByCategory['category_name'] }}
				</h3>
				@foreach ($productsByCategory['products'] as $product)
				<div class="grid grid-cols-2 items-center my-2">
					<p class="text-white">{{ $product['product_name'] }}</p>
					<div class="flex items-center gap-4">
						<div>
							<label for="stock" class="form-label">Stock</label>
							<input id="stock" class="form-control" value="{{ $product['stock'] }}" disabled type="text" aria-describedby="stock" />
						</div>
						<div>
							<label for="selling" class="form-label">Selling</label>
							<input id="selling" class="form-control" value="{{ $product['selling'] }}" disabled type="text" aria-describedby="selling" />
						</div>
						<div>
							<label for="balance" class="form-label">Balance</label>
							<input id="balance" class="form-control" value="{{ $product['balance'] }}" disabled type="text" aria-describedby="balance-500" />
						</div>
					</div>
				</div>
				@endforeach

			</div>
			@endforeach
	
	
			<x-section-card :title="'Area Domisili Outlet'">
				<div class="grid grid-cols-2 gap-6">
					<div>
						<label for="longitude" class="form-label">Longitudes <span class="font-normal">(DD
								Coordinates)</span></label>
						<input id="longitude" class="form-control" type="text" name="longitude" value="{{ $response['longitude'] }}" disabled aria-describedby="longitude" />
					</div>
					<div>
						<label for="latitude" class="form-label">Latitudes <span class="font-normal">(DMS
								Coordinates)</span></label>
						<input id="latitude" class="form-control" type="text" name="latitude" value="{{ $response['latitude'] }}" disabled aria-describedby="latitude" />
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
	
			<x-section-card :title="'Foto Outlet'">
				<div class="flex flex-col items-center w-full">
					<div class="relative w-full mx-3 border-red">
						<div class="flex justify-center items-center flex-col py-1 h-[450px]">\
							<img src="https://asset.kompas.com/crops/-fgwA_-9Kc_utIpIQ2krARwyIfg=/2x0:508x337/1200x800/data/photo/2021/01/06/5ff598a54774b.jpg" class="w-full h-full rounded-md object-cover" alt="">
						</div>
					</div>
				</div>
			</x-section-card>


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