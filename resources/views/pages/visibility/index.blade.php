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
            <x-input.search wire:model.live="search" class="border-0" placeholder="Cari data visibility"></x-input.search>
            <x-select.light :title="'Filter Jenis Visibility'" id="sales-filter" name="sales_id">
                @foreach($salesUsers as $sales)
                    <option value="{{ $sales->id }}" {{ request('sales_id') == $sales->id ? 'selected' : '' }}>
                        {{ $sales->name }}
                    </option>
                @endforeach

            </x-select.light> 
            <x-button.info onclick="openModal('update-photo')">Update Foto</x-button.info>
            <x-button.info href="/visibility/create">Tambah Visibility</x-button.info>
        </x-slot:cardAction>
        {{-- Visibility Action End --}}

        <x-modal id="update-photo">
            <x:slot:title>Update Foto Visibility Berdasarkan Jenis POSM</x:slot:title>
            <div class="flex">
                <x-input.image class="!text-primary" id="backwall" name="backwall" label="Backwall" :max-size="5" />
                <x-input.image class="!text-primary" id="standee" name="standee" label="Standee" :max-size="5" />
                <x-input.image class="!text-primary" id="Glolifier" name="Glolifier" label="Glolifier" :max-size="5" />
                <x-input.image class="!text-primary" id="COC" name="COC" label="COC" :max-size="5" />
            </div>
            <x:slot:footer>
                <x-button.info class="w-full">Konfirmasi</x-button.info>
            </x:slot:footer>
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
                <td class="table-data {{ $visibility->status === 'ACTIVE' ? '!text-[#70FFE2]' : '!text-red-500' }}">
                    {{ $visibility->status }}
                </td>
                <td class="table-data"> 
                    {{ \Carbon\Carbon::parse($visibility->program_date)->format('d F Y') }}
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
                <tr class="table-row">
                    <td class="table-data">{{ $visibility->outlet->name }}</td>
                    <td class="table-data">{{ $visibility->outlet->user->name }}</td>
                    <td class="table-data">{{ $visibility->product->sku }}</td>
                    <td class="table-data">{{ $visibility->visualType->name }}</td>
                    <td scope="row" class="table-data">
                        halo
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
            $("#visibility-activity-daterange").flatpickr({
                mode: "range"
            });

            const visibilityTable = $('#visibility-table').DataTable({
        processing: false,
        pageLength: 10,
        lengthMenu: [10, 20, 30, 40, 50],
        data: {!! $visibilities->toJson() !!}, // Passing data langsung dari controller
        columns: [
            { 
                data: 'outlet.name',
                render: function(data, type, row) {
                    return data || '-';
                }
            },
            { 
                data: 'outlet.user.name',
                render: function(data, type, row) {
                    return data || '-';
                }
            },
            { 
                data: 'product.sku',
                render: function(data, type, row) {
                    return data || '-';
                }
            },
            { 
                data: 'visual_type.name',
                render: function(data, type, row) {
                    return data || '-';
                }
            },
            { 
                data: 'status',
                render: function(data, type, row) {
                    return `<span class="${data === 'ACTIVE' ? 'text-green-500' : 'text-red-500'}">${data}</span>`;
                }
            },
            { 
                data: 'program_date',
                render: function(data, type, row) {
                    return moment(data).format('DD MMMM YYYY');
                }
            },
            {
                data: null,
                orderable: false,
                render: function(data, type, row) {
                    return `
                        <div class="flex justify-center space-x-2">
                            <a href="/visibility/${row.id}/edit" 
                               class="btn btn-sm btn-primary">
                                Lihat Data
                            </a>
                            <button onclick="deleteVisibility('${row.id}', '${row.outlet.name}', '${row.outlet.user.name}', '${row.product.sku}')"
                                    class="btn btn-sm btn-danger">
                                Hapus
                            </button>
                        </div>
                    `;
                }
            }
        ],
        language: {
            emptyTable: "Tidak ada data visibility",
            info: "Menampilkan _START_ sampai _END_ dari _TOTAL_ data",
            infoEmpty: "Menampilkan 0 sampai 0 dari 0 data",
            infoFiltered: "(difilter dari _MAX_ total data)",
            lengthMenu: "Menampilkan _MENU_ data",
            search: "Cari:",
            zeroRecords: "Tidak ditemukan data yang sesuai",
            paginate: {
                first: "Pertama",
                last: "Terakhir",
                next: ">",
                previous: "<"
            }
        },
        dom: 'rt<"bottom-container"<"bottom-left"l><"bottom-right"p>>'
    });

    // Search functionality
    $('#search').on('keyup', function() {
        visibilityTable.search(this.value).draw();
    });
});

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
    // Initialize select2
    $('#sales-filter').select2({
        placeholder: 'Select Sales',
        allowClear: true
    });

    // Handle filter change
    $('#sales-filter').change(function() {
        const salesId = $(this).val();
        let url = new URL(window.location.href);
        
        if (salesId) {
            url.searchParams.set('sales_id', salesId);
        } else {
            url.searchParams.delete('sales_id');
        }
        
        window.location.href = url.toString();
    });

    // Handle reset button
    $('#reset-filter').click(function() {
        let url = new URL(window.location.href);
        url.searchParams.delete('sales_id');
        window.location.href = url.toString();
    });
});
</script>
@endpush
