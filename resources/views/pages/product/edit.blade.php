@extends('layouts.main')

@section('banner-content')
<x-banner-content :title="'Product'" />
@endsection

@section('dashboard-content')
<main class="w-full">
    <div>
        <div class="form-edit">
            <x-card>
                <x-slot:cardTitle>
                    Ubah Daftar Produk
                </x-slot:cardTitle>
                {{-- Profil Pengguna --}}
                <form method="POST" id="editProductForm-{{ $product->id }}" class="grid grid-cols-2 gap-6">
                    @csrf
                    @method('PUT')
                    <div>
                        <label for="edit_categories_{{ $product->id }}" class="text-white font-sans">Kategori Produk</label>
                        <div>
                            <select id="edit_categories_{{ $product->id }}" name="category_id"
                                class="categories w-full form-control @error('category_id') is-invalid @enderror">
                                <option value="" disabled>-- Pilih Category Product --</option>
                                @foreach ($categories as $category)
                                    <option value="{{ $category->id }}" {{ $category->id == $product->category_id ? 'selected' : '' }}>
                                        {{ $category->name }}
                                    </option>
                                @endforeach
                            </select>
                            <span id="edit_category_id-error-{{ $product->id }}" class="text-red-500 text-xs hidden"></span>
                        </div>
                    </div>
                    <div>
                        <label for="edit_sku_{{ $product->id }}" class="text-white font-sans">Produk SKU</label>
                        <input id="edit_sku_{{ $product->id }}" class="form-control @error('sku') is-invalid @enderror" type="text"
                            name="sku" placeholder="Masukan produk SKU" value="{{ $product->sku }}">
                        <span id="edit_sku-error-{{ $product->id }}" class="text-red-500 text-xs hidden"></span>
                    </div>
                    <div>
                        <label for="edit_md_price_{{ $product->id }}" class="text-white font-sans">Harga MD</label>
                        <input id="edit_md_price_{{ $product->id }}" class="form-control @error('md_price') is-invalid @enderror"
                            type="number" name="md_price" placeholder="Masukan Harga MD" value="{{ $product->md_price }}">
                        <span id="edit_md_price-error-{{ $product->id }}" class="text-red-500 text-xs hidden"></span>
                    </div>
                    <div>
                        <label for="edit_sales_price_{{ $product->id }}" class="text-white font-sans">Harga Sales</label>
                        <input id="edit_sales_price_{{ $product->id }}" class="form-control @error('sales_price') is-invalid @enderror"
                            type="number" name="sales_price" placeholder="Masukan Harga Sales" value="{{ $product->sales_price }}">
                        <span id="edit_sales_price-error-{{ $product->id }}" class="text-red-500 text-xs hidden"></span>
                    </div>
                    <div class="col-span-2 flex justify-end gap-4">
                        <a class="px-3 py-1.5 text-sm bg-white border border-gray-500 rounded hover:bg-gray-50 text-primary" 
                            href="{{ route('products.index') }}">
                            Kembali
                        </a>
                        <x-button.info class="px-3 py-1.5 text-sm bg-blue-500 text-white rounded hover:bg-blue-600 update-product-btn" 
                            data-id="{{ $product->id }}">
                            <span id="updateBtnText-{{ $product->id }}">Simpan Perubahan</span>
                            <span id="updateBtnLoading-{{ $product->id }}" class="hidden">
                                Menyimpan...
                            </span>
                        </x-button.info>
                    </div>
                </form>
            </x-card>
        </div>
    </div>
</main>
@endsection

@push('scripts')
    <script>
        const roleConfig = {
            "admin": {
                showElement: 'admin-access',
                hideElements: ['sales-access', 'superadmin-access']
            },
            "sales": {
                showElement: 'sales-access',
                hideElements: ['admin-access', 'superadmin-access']
            },
            "superadmin": {
                showElement: 'superadmin-access',
                hideElements: ['admin-access', 'sales-access']
            }
        };

        const roleSelect = document.getElementById('role');
        function clearAllPermissions() {
                const allSwitches = document.querySelectorAll('input[type="checkbox"][name="permissions[]"]');
                allSwitches.forEach(switchElement => {
                    switchElement.checked = false;
                });
        }
        function toggleElementVisibility(elementId, show) {
            const element = document.getElementById(elementId);
            if (!element) return;

            element.classList.toggle('hidden', !show);
            element.classList.toggle('grid', show);
        }

        function handleRoleChange(event) {
            const selectedOption = event.target.options[event.target.selectedIndex];
            const selectedRoleId = selectedOption.value;
            const selectedRoleName = selectedOption.getAttribute('data-name');

            const config = roleConfig[selectedRoleName];

            if (!config) return;
            clearAllPermissions();
            toggleElementVisibility(config.showElement, true);

            config.hideElements.forEach(elementId => {
                toggleElementVisibility(elementId, false);
            });
        }


        roleSelect.addEventListener('change', handleRoleChange);
    </script>
@endpush

@push('scripts')
    <script>
        $(document).ready(function () {
            $('#states-option').select2();
        });
    </script>
@endpush

@push('scripts')
<script>
$(document).ready(function() {
    $('.categories').select2();
    
    // Setup AJAX CSRF
    $.ajaxSetup({
        headers: {
            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
        }
    });

    function toggleUpdateLoading(id, show) {
        if (show) {
            $(`#updateBtnText-${id}`).addClass('hidden');
            $(`#updateBtnLoading-${id}`).removeClass('hidden');
            $(`.update-product-btn[data-id="${id}"]`).prop('disabled', true);
        } else {
            $(`#updateBtnText-${id}`).removeClass('hidden');
            $(`#updateBtnLoading-${id}`).addClass('hidden');
            $(`.update-product-btn[data-id="${id}"]`).prop('disabled', false);
        }
    }

    // Handle update button click
    $(document).ready(function() {
    $('.update-product-btn').click(function() {
        const id = $(this).data('id');
        
        // Reset error states
        $('.text-red-500').addClass('hidden');
        $('input').removeClass('border-red-500');

        toggleUpdateLoading(id, true);

        const formData = new FormData($(`#editProductForm-${id}`)[0]);
        formData.set('md_price', formData.get('md_price').replace(/[^\d]/g, ''));
        formData.set('sales_price', formData.get('sales_price').replace(/[^\d]/g, ''));

        $.ajax({
            type: 'POST', // Changed from PUT to POST
            url: `/products/${id}`, // Use the update route
            data: formData,
            processData: false,
            contentType: false,
            success: function(response) {
                toggleUpdateLoading(id, false);
                if (response.status === 'success') {
                    new Notify({
                        status: 'success',
                        title: 'Success',
                        text: response.message,
                        effect: 'fade',
                        speed: 300,
                        showIcon: true,
                        showCloseButton: true,
                        autoclose: true,
                        autotimeout: 1000,
                        type: 'outline',
                        position: 'right top'
                    });
                    setTimeout(() => {
                        window.location.href = '{{ route("products.index") }}';
                    }, 1500);
                }
            },
            error: function(xhr) {
                toggleUpdateLoading(id, false);
                if (xhr.status === 422) {
                    const errors = xhr.responseJSON.errors;
                    $.each(errors, function(key, value) {
                        $(`#edit_${key}-error-${id}`)
                            .text(value[0])
                            .removeClass('hidden');
                        $(`#edit_${key}_${id}`).addClass('border-red-500');
                    });
                }
            }
        });
    });
});

    // Format number inputs with thousand separator
    // $('input[type="number"]').on('input', function() {
    //     const value = $(this).val().replace(/[^\d]/g, '');
    //     if (value) {
    //         $(this).val(parseInt(value).toLocaleString('id-ID'));
    //     }
    // });

    // // Format initial number values
    // $('input[type="number"]').each(function() {
    //     const value = $(this).val();
    //     if (value) {
    //         $(this).val(parseInt(value).toLocaleString('id-ID'));
    //     }
    // });
});
</script>
@endpush