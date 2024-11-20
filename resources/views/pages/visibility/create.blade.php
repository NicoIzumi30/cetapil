@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Visibility'" />
@endsection

@section('dashboard-content')
    <x-card>
        <x-slot:cardTitle>
            Tambah Daftar Visibility
        </x-slot:cardTitle>

        <x-slot:cardAction>
            <x-button.info onclick="openModal('add-visual')">Tambah Jenis Visual</x-button.info>
			<x-modal id="add-visual">
				<x:slot:title>Tambah Jenis Visual</x:slot:title>
				<form class="w-full">
					<div>
						<label for="visual" class="!text-black">Jenis Visual</label>
						<input id="visual" class="form-control" wire:model="visual" name="visual"
							placeholder="Masukan Nama Jenis Visual" aria-describedby="visual" value="">
						@error('visual')
							<div class="invalid-feedback">
								{{ $message }}
							</div>
						@enderror
					</div>
				</form>
				<x:slot:footer>
					<x-button.info class="w-full">Konfirmasi</x-button.info>
				</x:slot:footer>
			</x-modal>
            {{-- <x-button.info onclick="openModal('add-posm')">Tambah Jenis POSM</x-button.info>
			<x-modal id="add-posm">
				<x:slot:title>Tambah Jenis POSM</x:slot:title>
				<form class="w-full">
					<div>
						<label for="posm" class="!text-black">Jenis POSM</label>
						<input id="posm" class="form-control" wire:model="posm" name="posm"
							placeholder="Masukan Nama Jenis POSM" aria-describedby="posm" value="">
						@error('posm')
							<div class="invalid-feedback">
								{{ $message }}
							</div>
						@enderror
					</div>
				</form>
				<x:slot:footer>
					<x-button.info class="w-full">Konfirmasi</x-button.info>
				</x:slot:footer>
			</x-modal> --}}
            <x-button.info>Unggah Secara Bulk</x-button.info>
        </x-slot:cardAction>

        <div class="grid grid-cols-2 gap-6">
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
                <label for="outlet-name">Nama Outlet</label>
                <select id="outlet-name" name="outlet-name" class=" w-full">
                    <option value="" selected disabled>
                        -- Pilih Nama Outlet --
                    </option>
                    <option value="cleanser">
                        Sumaju
                    </option>
                </select>
            </div>
            <div>
                <label for="category">Kategori Produk</label>
                <select id="category" name="category" class=" w-full">
                    <option value="" selected disabled>
                        -- Pilih Kategori Produk--
                    </option>
                    <option value="cleanser">
                        Sumaju
                    </option>
                </select>
            </div>
            <div>
                <label for="sku">Produk SKU</label>
                <select id="sku" name="sku" class=" w-full">
                    <option value="" selected disabled>
                        -- Pilih Produk SKU --
                    </option>
                    <option value="cleanser">
                        Sumaju
                    </option>
                </select>
            </div>
            <div class="relative">
                <label for="program-date">Jangka Waktu Program</label>
                <input id="program-date" type="text" value="-- Pilih Tanggal dan Waktu Kunjungan" name="program-date"
                    class="form-control w-full appearance-none" />
                <i class="absolute top-10 right-6">
                    <svg width="19" height="25" viewBox="0 0 19 25" fill="none"
                        xmlns="http://www.w3.org/2000/svg">
                        <path
                            d="M16.5732 24.513H2.54503C1.43825 24.513 0.541016 23.4532 0.541016 22.1458V5.57507C0.541016 4.26768 1.43825 3.20782 2.54503 3.20782H4.54905V0.840576H6.55307V3.20782H12.5651V0.840576H14.5691V3.20782H16.5732C17.68 3.20782 18.5772 4.26768 18.5772 5.57507V22.1458C18.5772 23.4532 17.68 24.513 16.5732 24.513ZM2.54503 10.3096V22.1458H16.5732V10.3096H2.54503ZM2.54503 5.57507V7.94232H16.5732V5.57507H2.54503ZM14.5691 19.7786H12.5651V17.4113H14.5691V19.7786ZM10.5611 19.7786H8.55709V17.4113H10.5611V19.7786ZM6.55307 19.7786H4.54905V17.4113H6.55307V19.7786ZM14.5691 15.0441H12.5651V12.6768H14.5691V15.0441ZM10.5611 15.0441H8.55709V12.6768H10.5611V15.0441ZM6.55307 15.0441H4.54905V12.6768H6.55307V15.0441Z"
                            fill="url(#paint0_linear_492_5030)" />
                        <defs>
                            <linearGradient id="paint0_linear_492_5030" x1="4.028" y1="20.4098" x2="17.8986"
                                y2="15.5685" gradientUnits="userSpaceOnUse">
                                <stop stop-color="#0077BD" />
                                <stop offset="1" stop-color="#02659F" />
                            </linearGradient>
                        </defs>
                    </svg>

                </i>
            </div>
            <div>
                <label for="visual-campaign">Kategori Produk</label>
                <select id="visual-campaign" name="visual-campaign" class="w-full">
                    <option value="" selected disabled>
                        -- Pilih Kategori Produk --
                    </option>
                    <option value="cleanser">
                        Sumaju
                    </option>
                </select>
            </div>
            <div>
                <label for="posm">Jenis POSM</label>
                <select id="posm" name="posm" class="w-full">
                    <option value="" selected disabled>
                        -- Pilih Jenis POSM --
                    </option>
                    <option value="cleanser">
                        Sumaju
                    </option>
                </select>
            </div>
        </div>
        <x-section-card>
            <x-slot:title>Unggah Banner Program</x-slot:title>
			<div class="flex flex-col items-center w-full">
				<div class="relative w-full mx-3 border-red">
					<div class="flex justify-center items-center flex-col py-2 h-[260px]">
						{{-- Upload Area --}}
						<div class="cursor-pointer text-center grid place-items-center border-2 border-dashed border-blue-400 rounded-lg p-4 w-full h-full"
							id="upload-area-banner">
							<div class="text-center grid place-items-center">
								<svg width="30" height="63" viewBox="0 0 64 63" fill="none" xmlns="http://www.w3.org/2000/svg">
									<path
										d="M28 43.2577C28 45.4323 29.7909 47.1952 32 47.1952C34.2091 47.1952 36 45.4323 36 43.2577V15.074L48.971 27.8423L54.6279 22.2739L32.0005 0L9.37305 22.2739L15.0299 27.8423L28 15.0749V43.2577Z"
										fill="#fff" />
									<path
										d="M0 39.375H8V55.125H56V39.375H64V55.125C64 59.4742 60.4183 63 56 63H8C3.58172 63 0 59.4742 0 55.125V39.375Z"
										fill="#fff" />
								</svg>
								<h5 class="text-white font-bold text-xl mt-2">Tarik atau klik disini untuk mulai mengunggah gambar banner program</h5>
								<p class="text-white font-light text-sm">
									Ukuran maksimal foto <strong class="font-bold"> 5 MB</strong>
									dengan dimensi <strong class="font-bold">728 x 90 </strong> Pixel 
								</p>
							</div>
						</div>
			
						{{-- Preview Container --}}
						<div id="preview-container-banner" class="hidden w-full relative">
							<img id="preview-image-banner" src="/" alt="Preview" 
								class="w-full h-[260px] mx-auto rounded-lg object-cover" />
							<button type="button"
								class="absolute bottom-2 right-2 bg-white p-2 rounded-full shadow-md hover:bg-gray-100 transition-colors"
								onclick="removeImage('banner')">
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
					<input type="file" name="banner" id="img_banner" class="hidden"
						accept="image/png, image/jpeg" onchange="previewImage(this, 'banner', 5)">
				</div>
			</div>
        </x-section-card>
		<x-button.info class="w-full mt-20 !text-xl">Konfirmasi</x-button.info>

    </x-card>
@endsection

@push('scripts')
    <script>
        $(document).ready(function() {
            $("#program-date").flatpickr();
            $('#states-option').select2();
            $('#category').select2();
            $('#outlet-name').select2();
            $('#sku').select2();
            $('#visual-campaign').select2();
            $('#posm').select2();
        });
    </script>
@endpush