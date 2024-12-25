@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Visibility'" />
@endsection

@section('dashboard-content')
    <x-card>
        <x-slot:cardTitle>
            Edit Daftar Visibility
        </x-slot:cardTitle>

        <form id="editVisibilityForm" enctype="multipart/form-data">
            @csrf
            @method('PUT')
        <div class="grid grid-cols-2 gap-6">
            <div>
                <label for="states-option">Kabupaten/Kota</label>
                <select id="states-option" name="city_id" class="w-full">
                    <option value="" disabled>-- Pilih Kabupaten/Kota--</option>
                    @foreach($cities as $city)
                        <option value="{{ $city->id }}" {{ $city->id === $visibility->city_id ? 'selected' : '' }}>
                            {{ $city->name }}
                        </option>
                    @endforeach
                </select>
                <span id="city_id-error" class="text-red-500 text-xs hidden"></span>
            </div>
            <div>
                <label for="outlet-name">Nama Outlet</label>
                <select id="outlet-name" name="outlet_id" class="w-full">
                    <option value="" disabled>-- Pilih Nama Outlet --</option>
                    @foreach($outlets as $outlet)
                        <option value="{{ $outlet->id }}" {{ $outlet->id === $visibility->outlet_id ? 'selected' : '' }}>
                            {{ $outlet->code }} - {{ $outlet->name }}
                        </option>
                    @endforeach
                </select>
                <span id="outlet_id-error" class="text-red-500 text-xs hidden"></span>
            </div>
            <div>
                <label for="category">Kategori Produk</label>
                <select id="category" name="category_id" class="w-full">
                    <option value="" disabled>-- Pilih Kategori Produk--</option>
                    @foreach($categories as $category)
                        <option value="{{ $category->id }}" {{ $category->id === $visibility->product->category_id ? 'selected' : '' }}>
                            {{ $category->name }}
                        </option>
                    @endforeach
                </select>
                <span id="category_id-error" class="text-red-500 text-xs hidden"></span>
            </div>
            <div>
                <label for="sku">Produk SKU</label>
                <select id="sku" name="product_id" class="w-full">
                    <option value="" disabled>-- Pilih Produk SKU --</option>
                    @foreach($products as $product)
                        <option value="{{ $product->id }}" 
                            {{ $product->id === $visibility->product_id ? 'selected' : '' }}
                            data-md-price="{{ $product->md_price }}"
                            data-sales-price="{{ $product->sales_price }}">
                            {{ $product->sku }}
                        </option>
                    @endforeach
                </select>
                <span id="sku-error" class="text-red-500 text-xs hidden"></span>
            </div>
            <div class="relative">
                <label for="program-date">Jangka Waktu Program</label>
                <input id="program-date" 
                        type="text" 
                        name="program_date"
                        value="{{ $visibility->program_date }}"
                        class="form-control w-full appearance-none" />
                <i class="absolute top-[45px] right-6 pointer-events-none">
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
                <span id="started_at-error" class="text-red-500 text-xs hidden"></span>
                <span id="ended_at-error" class="text-red-500 text-xs hidden"></span>
            </div>
            <div>
                <label for="visual-campaign">Visual/Campaign</label>
                <select id="visual-campaign" name="visual_type_id" class="w-full">
                    <option value="" disabled>-- Pilih Visual/Campaign --</option>
                    @foreach($visualTypes as $type)
                        <option value="{{ $type->id }}" {{ $type->id === $visibility->visual_type_id ? 'selected' : '' }}>
                            {{ $type->name }}
                        </option>
                    @endforeach
                </select>
                <span id="category_id-error" class="text-red-500 text-xs hidden"></span>
            </div>
            <div>
                <label for="posm">Jenis POSM</label>
                <select id="posm" name="posm_type_id" class="w-full">
                    <option value="" disabled>-- Pilih Jenis POSM --</option>
                    @foreach($posmTypes as $type)
                        <option value="{{ $type->id }}" {{ $type->id === $visibility->posm_type_id ? 'selected' : '' }}>
                            {{ $type->name }}
                        </option>
                    @endforeach
                </select>
                <span id="posm_type_id-error" class="text-red-500 text-xs hidden"></span>

            </div>
        </div>
        <x-section-card>
            <x-slot:title>Unggah Planogram</x-slot:title>
			<div class="flex flex-col items-center w-full">
				<div class="relative w-full mx-3 border-red">
					<div class="flex justify-center items-center flex-col py-2 h-[260px]">
						{{-- Upload Area --}}
						<div class="cursor-pointer text-center {{ $visibility->filename ? 'hidden' : '' }} place-items-center border-2 border-dashed border-blue-400 rounded-lg p-4 w-full h-full"
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
						<div id="preview-container-banner" class="w-full relative">
							<img id="preview-image-banner" 
                                    src="{{ $visibility->path ? asset($visibility->path) : asset('assets/images/banner-placeholder.png') }}" 
                                    alt="Preview"
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
					<input type="file" name="filename" id="img_banner" class="hidden"
						accept="image/png, image/jpeg" onchange="previewImage(this, 'banner', 5)">
				</div>
			</div>
        </x-section-card>
        </form>
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
@push('scripts')
<script>
$(document).ready(function() {
    $('#program-date').after(`
        <input type="hidden" name="started_at" id="started_at">
        <input type="hidden" name="ended_at" id="ended_at">
    `);

    // Initialize Flatpickr with range mode
    const dateRangePicker = $("#program-date").flatpickr({
        mode: "range",
        dateFormat: "Y-m-d",
        altInput: true,
        altFormat: "d F Y",
        showMonths: 2,
        defaultDate: [
            '{{ $visibility->started_at }}', 
            '{{ $visibility->ended_at }}'
        ],
        allowInput: false,
        disableMobile: true,
        locale: {
            rangeSeparator: " sampai ",
            firstDayOfWeek: 1,
            weekdays: {
                shorthand: ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'],
                longhand: ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu']
            },
            months: {
                shorthand: ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'],
                longhand: ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember']
            }
        },
        onChange: function(selectedDates, dateStr, instance) {
            if (selectedDates.length === 2) {
                const startDate = selectedDates[0];
                const endDate = selectedDates[1];
                
                // Format dates for MySQL datetime
                const formatDate = (date) => {
                    return date.toISOString().slice(0, 19).replace('T', ' ');
                };
                
                // Set start date to beginning of day
                startDate.setHours(0, 0, 0, 0);
                // Set end date to end of day
                endDate.setHours(23, 59, 59, 999);
                
                // Update hidden inputs
                $('#started_at').val(formatDate(startDate));
                $('#ended_at').val(formatDate(endDate));
                
                // Clear error message if exists
                $('#program-date-error').addClass('hidden');
                $('#program-date').removeClass('border-red-500');
            }
        }
    });

    $('#states-option').select2();
    $('#category').select2();
    $('#outlet-name').select2();
    $('#sku').select2();
    $('#visual-campaign').select2();
    $('#posm').select2();

    function submitForm() {
    // Reset error states
    $('.text-red-500').addClass('hidden');
    $('select, input').removeClass('border-red-500');
    
    // Validate date range
    if (!$('#started_at').val() || !$('#ended_at').val()) {
        $('#program-date-error')
            .text('Pilih tanggal mulai dan selesai program')
            .removeClass('hidden');
        $('#program-date').addClass('border-red-500');
        return false;
    }
    
    // Create FormData
    const form = document.getElementById('editVisibilityForm');
    const formData = new FormData(form);
    
    // Show loading state
    $('#submitBtn').prop('disabled', true);
    $('#submitBtnText').addClass('hidden');
    $('#submitBtnLoading').removeClass('hidden');
    
    $.ajax({
        url: '{{ route("visibility.update", $visibility->id) }}',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function(response) {
            if (response.status === 'success') {
                toast('success', response.message);
                setTimeout(() => {
                    window.location.href = '{{ route("visibility.index") }}';
                }, 1500);
            }
        },
        error: function(xhr) {
            if (xhr.status === 422) {
                const errors = xhr.responseJSON.errors;
                Object.keys(errors).forEach(key => {
                    const fieldMap = {
                        'outlet_id': 'outlet-name',
                        'product_id': 'sku',
                        'started_at': 'program-date',
                        'ended_at': 'program-date',
                        'visual_type_id': 'visual-campaign',
                        'posm_type_id': 'posm',
                        'filename': 'img_banner'
                    };
                    
                    const field = fieldMap[key] || key;
                    const errorElement = $(`#${field}-error`);
                    if (errorElement.length) {
                        errorElement
                            .text(errors[key][0])
                            .removeClass('hidden');
                        $(`[name="${key}"]`).addClass('border-red-500');
                    }
                });
                
                toast('error', 'Silakan periksa kembali form isian');
            } else {
                toast('error', xhr.responseJSON?.message || 'Terjadi kesalahan saat menyimpan data');
            }
        },
        complete: function() {
            $('#submitBtn').prop('disabled', false);
            $('#submitBtnText').removeClass('hidden');
            $('#submitBtnLoading').addClass('hidden');
        }
    });
}

// Binding form submit ke fungsi submitForm
$('#editVisibilityForm').on('submit', function(e) {
    e.preventDefault();
    submitForm();
});

    // Handle category change
    $('#category').on('change', function() {
        const categoryId = $(this).val();
        if (categoryId) {
            $.get(`/visibility/products/${categoryId}`, function(data) {
                $('#sku').empty()
                    .append('<option value="" disabled selected>-- Pilih Produk SKU --</option>');
                data.forEach(product => {
                    const option = new Option(product.sku, product.id);
                    option.dataset.mdPrice = product.md_price;
                    option.dataset.salesPrice = product.sales_price;
                    $('#sku').append(option);
                });
            }).fail(function() {
                toast('error', 'Gagal memuat data produk', 200);
            });
        }
    });

    // Handle file preview
    function previewImage(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                $('#preview-image-banner').attr('src', e.target.result);
                $('#preview-container-banner').removeClass('hidden');
                $('#upload-area-banner').addClass('hidden');
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    $('#img_banner').change(function() {
        previewImage(this);
    });
});
</script>
@endpush