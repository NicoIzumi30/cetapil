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
                    <x-button.info class="w-full" type="button" onclick="submitPosmImages()">Konfirmasi</x-button.info>
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
        @foreach($visibilities as $visibility)
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
// $(document).ready(function() {
//     $.ajaxSetup({
//         headers: {
//             'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
//         }
//     });

//     let table = $('#visibility-table').DataTable({
//     processing: true,
//     serverSide: true,
//     paging: true,
//     searching: false,
//     info: true,
//     pageLength: 10,
//     lengthMenu: [10, 20, 30, 40, 50],
//     dom: 'rt<"bottom-container"<"bottom-left"l><"bottom-right"p>>',
//     language: {
//         lengthMenu: "Menampilkan _MENU_ dari _TOTAL_ data",
//         processing: "Memuat data...",
//         paginate: {
//             previous: '<',
//             next: '>',
//             last: 'Terakhir',
//         },
//         info: "Menampilkan _START_ sampai _END_ dari _TOTAL_ data",
//         infoEmpty: "Menampilkan 0 sampai 0 dari 0 data",
//         emptyTable: "Tidak ada data yang tersedia"
//     },
//     ajax: {
//         url: "{{ route('visibility.data') }}",
//         data: function(d) {
//             d.search_term = $('#search').val();
//             d.posm_type_id = $('#posm-filter').val();
//         }
//     },
//     columns: [
//         { 
//             data: 'name',
//             name: 'outlet.name',
//             render: function(data, type, row) {
//                 return data || '-';
//             }
//         },
//         { 
//             data: 'name',
//             name: 'outlet.user.name',
//             render: function(data, type, row) {
//                 return data || '-';
//             }
//         },
//         { 
//             data: 'sku',
//             name: 'product.sku',
//             render: function(data, type, row) {
//                 return data || '-';
//             }
//         },
//         { 
//             data: 'name',
//             name: 'visualType.name',
//             render: function(data, type, row) {
//                 return data || '-';
//             }
//         },
//         { 
//             data: 'status',
//             name: 'status',
//             render: function(data, type, row) {
//                 return `<span class="table-data ${data === 'ACTIVE' ? 'text-[#3eff86]' : 'text-red-500'}">${data}</span>`;
//             }
//         },
//         { 
//             data: 'date_range',
//             name: 'started_at',
//             render: function(data, type, row) {
//                 if (row.started_at && row.ended_at) {
//                     return moment(row.started_at).format('D MMMM Y') + ' - ' + moment(row.ended_at).format('D MMMM Y');
//                 }
//                 return '-';
//             }
//         },
//         { 
//             data: 'action',
//             name: 'action',
//             orderable: false,
//             searchable: false,
//             render: function(data, type, row) {
//                 return `
//                     <x-action-table-dropdown>
//                         <li>
//                             <a href="/visibility/edit/${row.id}" class="dropdown-option">
//                                 Lihat Data
//                             </a>
//                         </li>
//                         <li>
//                             <button onclick="deleteVisibility('${row.id}', '${row.outlet_name}', '${row.sales_name}', '${row.product_sku}')" 
//                                 class="dropdown-option text-red-400">
//                                 Hapus Data
//                             </button>
//                         </li>
//                     </x-action-table-dropdown>
//                 `;
//             }
//         }
//     ]
// });

    // Handle search with debounce
    let searchTimer;
    $('#search').on('input', function() {
        clearTimeout(searchTimer);
        searchTimer = setTimeout(() => table.ajax.reload(null, false), 500);
    });

    // Handle POSM filter
    $('#posm-filter').change(function() {
        table.ajax.reload(null, false);
    });

    // Initialize Select2
    $('#posm-filter').select2({
        placeholder: 'Pilih Jenis Visibility',
        allowClear: true
    });
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
                }
            });
        }
    });
}
    </script>
@endpush

@push('scripts')
<script>
function submitPosmImages() {
    const formData = new FormData(document.getElementById('posmImageForm'));
    
    $.ajax({
        url: '{{ route("posm.update-image") }}',
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
                closeModal('update-photo');
                $('#posmImageForm')[0].reset();
            }
        },
        error: function(xhr) {
            const response = xhr.responseJSON;
            let message = 'Terjadi kesalahan saat mengupload foto';
            
            if (response && response.errors) {
                message = Object.values(response.errors)[0][0];
            } else if (response && response.message) {
                message = response.message;
            }
            
            toast('error', message);
        }
    });
}
    </script>
@endpush

