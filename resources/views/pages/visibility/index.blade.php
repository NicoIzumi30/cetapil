@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Visibility'" />
@endsection

@section('dashboard-content')
    <x-card>
        <x-slot:cardTitle>
            Daftar Visibility
        </x-slot:cardTitle>
        {{-- Visibility Action --}}
        <x-slot:cardAction>
            <x-input.search wire:model.live="search" type="text" class="border-0" name="search" id="search" placeholder="Cari data visibility" value="{{ request('search') }}"></x-input.search>
            <x-select.light :title="'Filter Jenis Visibility'" id="posm-filter" name="posm_type_id">
                <option value="">Semua Jenis</option>
                @foreach($posmTypes as $type)
                    <option value="{{ $type->id }}" {{ request('posm_type_id') == $type->id ? 'selected' : '' }}>
                        {{ $type->name }}
                    </option>
                @endforeach
            </x-select.light>
            <x-button.info onclick="openModal('update-photo')">Update Foto</x-button.info>
            <x-button.info href="/visibility/create">Tambah Visibility</x-button.info>
        </x-slot:cardAction>
        {{-- Visibility Action End --}}

        <x-modal id="update-photo">
            <x:slot:title>Update Foto Visibility Berdasarkan Jenis POSM</x:slot:title>
            <form id="posmImageForm" enctype="multipart/form-data">
                @csrf
                <div class="flex">
                    <x-input.image class="!text-primary" id="backwall" name="backwall" label="Backwall" :max-size="5" />
                    <x-input.image class="!text-primary" id="standee" name="standee" label="Standee" :max-size="5" />
                    <x-input.image class="!text-primary" id="glolifier" name="glolifier" label="Glolifier" :max-size="5" />
                    <x-input.image class="!text-primary" id="coc" name="coc" label="COC" :max-size="5" />
                </div>
                <x:slot:footer>
                    <!-- Ubah type menjadi "button" dan tambahkan id -->
                    <x-button.info class="w-full" type="button" id="submitPosmBtn">
                        <span id="submitBtnText">Konfirmasi</span>
                        <span id="submitBtnLoading" class="hidden">
                            <i class="fas fa-spinner fa-spin mr-2"></i>Menyimpan...
                        </span>
                    </x-button.info>
                </x:slot:footer>
            </form>
        </x-modal>



        {{-- Visibility Table --}}
       <table id="visibility-table" class="table">
    <thead>
        <tr>
            <th scope="col" class="text-center">
                <a class="table-head">
                    {{ __('Nama Outlet') }}
                    <x-icons.sort />
                </a>
            </th>
            <th scope="col" class="text-center">
                <a class="table-head">
                    {{ __('Nama Sales') }}
                    <x-icons.sort />
                </a>
            </th>
            <th scope="col" class="text-center">
                <a class="table-head">
                    {{ __('SKU') }}
                    <x-icons.sort />
                </a>
            </th>
            <th scope="col" class="text-center">
                <a class="table-head">
                    {{ __('Visual') }}
                    <x-icons.sort />
                </a>
            </th>
            <th scope="col" class="text-center">
                <a class="table-head">
                    {{ __('Status') }}
                    <x-icons.sort />
                </a>
            </th>
            <th scope="col" class="text-center">
                <a class="table-head">
                    {{ __('Jangka Waktu') }}
                    <x-icons.sort />
                </a>
            </th>
            <th scope="col" class="text-center">
                <a class="table-head">
                    Aksi
                </a>
            </th>
        </tr>
    </thead>
            <tbody>
                @foreach ($visibilities as $visibility)
            <tr>
                <td class="table-data">{{ $visibility->outlet->name }}</td>
                <td class="table-data">{{ $visibility->outlet->user->name }}</td>
                <td class="table-data">{{ $visibility->product->sku }}</td>
                <td class="table-data">{{ $visibility->visualType->name }}</td>
                <td class="table-data {{ $visibility->status === 'ACTIVE' ? '!text-[#3eff86]' : '!text-red-500' }}">
                    {{ $visibility->status }}
                </td>
                <td class="table-data">
                    @if($visibility->started_at && $visibility->ended_at)
                        {{ \Carbon\Carbon::parse($visibility->started_at)->format('d F Y') }} - {{ \Carbon\Carbon::parse($visibility->ended_at)->format('d F Y') }}
                    @else
                        -
                    @endif

                </td>
                <td class="table-data">
                    <x-action-table-dropdown>
                        <li>
                            <a href="{{ route('visibility.edit', $visibility->id) }}" class="dropdown-option">
                                Lihat Data
                            </a>
                        </li>
                        <li>
                            <button onclick="deleteVisibility('{{ $visibility->id }}', '{{ $visibility->outlet->name }}', '{{ $visibility->outlet->user->name }}', '{{ $visibility->product->sku }}')"
                                class="dropdown-option text-red-400">
                                Hapus Data
                            </button>
                        </li>
                    </x-action-table-dropdown>
                </td>
            </tr>
        @endforeach
            </tbody>
        </table>
        <x-modal id="delete-visibility">
            <x-slot:title>Hapus Visibility</x-slot:title>
            <p>Apakah kamu yakin Ingin Menghapus Data Pengguna ini?</p>
            <x-slot:footer>
                <x-button.light onclick="closeModal('delete-visibility')"
                    class="border-primary border">Batal</x-button.light>
                <x-button.light class="!bg-red-400 text-white border border-red-400">Hapus Data</x-button.light>
            </x-slot:footer>
        </x-modal>
        {{-- Visibility Table End --}}
    </x-card>

    <x-card>
        <x-slot:cardTitle>
            Visibility Activity
        </x-slot:cardTitle>
        <x-slot:cardAction>
            <x-input.search wire:model.live="search" class="border-0"
                placeholder="Cari data visibility activity"></x-input.search>
            <x-button.info>Download</x-button.info>
            <x-input.datepicker id="visibility-activity-daterange" />
        </x-slot:cardAction>

        <table id="visibility-activity-table" class="table">
            <thead>
                <tr>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Nama Outlet') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Nama Sales') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('SKU') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Visual') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            {{ __('Condition') }}
                            <x-icons.sort />
                        </a>
                    </th>
                    <th scope="col" class="text-center">
                        <a class="table-head">
                            Aksi
                        </a>
                    </th>
                </tr>
            </thead>
            <tbody>
        @foreach($visibilities as $visibility)
                <tr class="table-row">
                    <td class="table-data">{{ $visibility->outlet->name }}</td>
                    <td class="table-data">{{ $visibility->outlet->user->name }}</td>
                    <td class="table-data">{{ $visibility->product->sku }}</td>
                    <td class="table-data">{{ $visibility->visualType->name }}</td>
                    <td scope="row" class="table-data" style="color: #3eff86;">
                        GOOD
                    </td>
                    <td class="table-data">
                        <x-action-table-dropdown>
                            <li>
                                <a href="/visibility/edit" class="dropdown-option">Lihat
                                    Data</a>
                            </li>
                            <li>
                                <button onclick="openModal('delete-visibility-activity')"
                                    class="dropdown-option text-red-400">Hapus
                                    Data</button>
                            </li>
                        </x-action-table-dropdown>
                    </td>
                </tr>
        @endforeach
            </tbody>
        </table>
        <x-modal id="delete-visibility-activity">
            <x-slot:title>Hapus Visibility Activity</x-slot:title>
            <p>Apakah kamu yakin Ingin Menghapus Data Visibility Activity ini?</p>
            <x-slot:footer>
                <x-button.light onclick="closeModal('delete-visibility-activity')"
                    class="border-primary border">Batal</x-button.light>
                <x-button.light class="!bg-red-400 text-white border border-red-400">Hapus Data</x-button.light>
            </x-slot:footer>
        </x-modal>
        {{-- Visibility Table End --}}
    </x-card>
@endsection

@push('scripts')
    <script>
$(document).ready(function() {
    // Handle POSM type filter change
    $('#posm-filter').on('change', function() {
        const selectedPosmType = $(this).val();
        const currentUrl = new URL(window.location.href);
        
        if (selectedPosmType) {
            currentUrl.searchParams.set('posm_type_id', selectedPosmType);
        } else {
            currentUrl.searchParams.delete('posm_type_id');
        }
        
        window.location.href = currentUrl.toString();
    });

    // Set selected value on page load if filter is active
    const urlParams = new URLSearchParams(window.location.search);
    const activePosmType = urlParams.get('posm_type_id');
    if (activePosmType) {
        $('#posm-filter').val(activePosmType);
    }
});


function toast(type, message) {
    const Toast = Swal.mixin({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true
    });

    Toast.fire({
        icon: type,
        title: message
    });
}

// Delete function
function deleteVisibility(id, outletName, salesName, sku) {
    Swal.fire({
        title: 'Hapus Visibility?',
        html: `
            <div class="text-center">
                <p class="mb-2"><strong>Detail data yang akan dihapus:</strong></p>
                <ul class="list-none">
                    <li class="mb-1"><strong>Outlet:</strong> ${outletName}</li>
                    <li class="mb-1"><strong>Sales:</strong> ${salesName}</li>
                    <li class="mb-1"><strong>SKU:</strong> ${sku}</li>
                </ul>
                <p class="mt-4 text-red-500">Data yang dihapus tidak dapat dikembalikan!</p>
            </div>
        `,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Ya, Hapus!',
        cancelButtonText: 'Batal'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: `/visibility/${id}`,
                type: 'DELETE',
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                },
                success: function(response) {
                    if (response.status === 'success') {
                        // Tampilkan toast notification
                        toast('success', 'Data berhasil dihapus');
                        
                        // Refresh halaman setelah notifikasi selesai (3 detik)
                        setTimeout(() => {
                            window.location.reload();
                        }, 3000);
                    }
                },
                error: function(xhr) {
                    // Tampilkan toast error jika gagal
                    toast('error', 'Terjadi kesalahan saat menghapus data');
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Ya, Hapus!',
                cancelButtonText: 'Batal'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        url: `/visibility/${id}`,
                        type: 'DELETE',
                        headers: {
                            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                        },
                        success: function(response) {
                            if (response.status === 'success') {
                                Swal.fire('Berhasil!', 'Data berhasil dihapus', 'success')
                                    .then(() => {
                                        visibilityTable.ajax.reload();
                                    });
                            }
                        },
                        error: function(xhr) {
                            Swal.fire('Error!', 'Terjadi kesalahan saat menghapus data', 'error');
                        }
                    });
                }
            });
        }
    </script>
@endpush
@push('scripts')
<script>
$(document).ready(function() {
    const form = $('#posmImageForm');
    const submitBtn = $('#submitPosmBtn');
    const btnText = $('#submitBtnText');
    const loadingText = $('#submitBtnLoading');

    // Function untuk memuat gambar yang ada
    function loadExistingImages() {
        $.ajax({
            url: "{{ route('posm.get-images') }}",
            type: 'GET',
            success: function(response) {
                if (response.status === 'success' && response.data) {
                    response.data.forEach(function(item) {
                        const input = $(`#${item.input_name}`);
                        const inputContainer = input.closest('.image-input-container');
                        
                        // Update preview container
                        inputContainer.find('.preview-container').html(`
                            <div class="relative">
                                <img src="${item.image_url}" class="h-20 w-20 object-cover rounded" />
                                <button type="button" 
                                        onclick="removeImage(this)"
                                        class="absolute -top-2 -right-2 bg-white rounded-full p-1 shadow-md">
                                    <svg xmlns="http://www.w3.org/2000/svg" 
                                         class="h-4 w-4 text-red-500" 
                                         viewBox="0 0 20 20" 
                                         fill="currentColor">
                                        <path fill-rule="evenodd" 
                                              d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" 
                                              clip-rule="evenodd" />
                                    </svg>
                                </button>
                            </div>
                        `);
                    });
                }
            }
        });
    }

    // Load gambar saat modal dibuka
    $(document).on('click', '[onclick="openModal(\'update-photo\')"]', function() {
        loadExistingImages();
    });

    // Handle form submission
    submitBtn.on('click', function(e) {
        e.preventDefault();
        
        btnText.addClass('hidden');
        loadingText.removeClass('hidden');
        submitBtn.prop('disabled', true);

        const formData = new FormData(form[0]);

        $.ajax({
            url: "{{ route('posm.update-image') }}",
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
            },
            success: function(response) {
                if (response.status === 'success') {
                    toast('success', response.message);
                    setTimeout(() => {
                        closeModal('update-photo');
                        window.location.reload();
                    }, 1500);
                }
            },
            error: function(xhr) {
                toast('error', xhr.responseJSON?.message || 'Terjadi kesalahan saat mengupload gambar');
            },
            complete: function() {
                btnText.removeClass('hidden');
                loadingText.addClass('hidden');
                submitBtn.prop('disabled', false);
            }
        });
    });

    // Handle file input change for preview
    $('input[type="file"]').on('change', function() {
        const file = this.files[0];
        if (file) {
            if (file.size > 5 * 1024 * 1024) {
                toast('error', 'Ukuran file tidak boleh lebih dari 5MB');
                this.value = '';
                return;
            }

            const reader = new FileReader();
            const inputContainer = $(this).closest('.image-input-container');
            
            reader.onload = function(e) {
                inputContainer.find('.preview-container').html(`
                    <div class="relative">
                        <img src="${e.target.result}" class="h-20 w-20 object-cover rounded" />
                        <button type="button" 
                                onclick="removeImage(this)"
                                class="absolute -top-2 -right-2 bg-white rounded-full p-1 shadow-md">
                            <svg xmlns="http://www.w3.org/2000/svg" 
                                 class="h-4 w-4 text-red-500" 
                                 viewBox="0 0 20 20" 
                                 fill="currentColor">
                                <path fill-rule="evenodd" 
                                      d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" 
                                      clip-rule="evenodd" />
                            </svg>
                        </button>
                    </div>
                `);
            };
            reader.readAsDataURL(file);
        }
    });
});

// Function to remove image preview
function removeImage(button) {
    const container = $(button).closest('.image-input-container');
    container.find('input[type="file"]').val('');
    container.find('.preview-container').empty();
}
</script>
@endpush