@extends('layouts.main')

@section('banner-content')
<x-banner-content :title="'Visibility'" />
@endsection

@section('dashboard-content')
<x-card>
    <x-slot:cardTitle>
        Visibility Activity
    </x-slot:cardTitle>
    <x-slot:cardAction>
        <x-input.search wire:model.live="search" id="global-search-activity" class="border-0"
            placeholder="Cari data visibility activity"></x-input.search>
        <x-button.light id="downloadActivityBtn">
            <span id="downloadBtnText">Download</span>
            <span id="downloadBtnLoading" class="hidden">Downloading...</span>
        </x-button.light>
        <x-input.datepicker id="activity-date-range" value=""></x-input.datepicker>
        <x-button.info onclick="openModal('upload-planogram')">Upload Planogram</x-button.info>
        <x-button.info onclick="openModal('upload-program')">Upload Program</x-button.info>
    </x-slot:cardAction>


    <x-modal id="upload-planogram">
        <x-slot:title>
            Upload Planogram
        </x-slot:title>
        <div class="grid grid-cols-2 text-black gap-4 w-full">
            <div class="w-full">
                <label for="planogram_file" class="!text-black">
                    Unggah Planogram
                    <div id="planogramFileUpload" class="flex mt-2">
                        <input type="text" id="planogramFileNameDisplay" readonly disabled
                            class="form-control mt-0 border-r-none"
                            placeholder="Unggah Planogram berupa file .png, .jpg , jpeg"
                            aria-describedby="planogram file name display">
                        <div class="bg-primary text-white align-middle p-3 rounded-r-md cursor-pointer -translate-x-2">
                            Browse</div>
                    </div>
                    <input type="file" id="planogram_file" name="planogram_file" class="form-control hidden"
                        accept="image/png, image/jpeg" aria-label="Unggah Planogram berupa file .png, .jpg , jpeg">
                </label>
            </div>
            <div>
                <label for="channel" class="!text-black">Channel</label>
                <select id="channel" name="channel" class=" w-full">
                    <option value="" selected disabled>
                        -- Pilih Channel --
                    </option>
                    @foreach ($channels as $channel)
                        <option value="{{$channel->id}}">{{$channel->name}}</option>
                    @endforeach
                </select>
            </div>
        </div>
        <x-slot:footer>
            <x-button.info class="w-full text-xl" id="updateBtnPlanogram">Konfirmasi</x-button.info>
        </x-slot:footer>
    </x-modal>

    <x-modal id="upload-program">
        <x-slot:title>
            Upload Program
        </x-slot:title>

        <div class="grid grid-cols-2 gap-4 w-full">
            <div class="w-full">
                <label for="program_file" class="!text-black">
                    Unggah Banner Program
                    <div id="bannerProgramFileUpload" class="flex mt-2">
                        <input type="text" id="bannerProgramFileNameDisplay" readonly disabled
                            class="form-control mt-0 border-r-none"
                            placeholder="Unggah Banner Program berupa file .png, .jpg , jpeg"
                            aria-describedby="bannerProgram file name display">
                        <div class="bg-primary text-white align-middle p-3 rounded-r-md cursor-pointer -translate-x-2">
                            Browse</div>
                    </div>`
                    <input type="file" id="program_file" name="program_file" class="form-control hidden"
                        accept="image/png, image/jpeg" aria-label="Unggah Banner Program berupa file .png, .jpg , jpeg">
                </label>
            </div>
            <div>
                <label for="region" class="!text-black">Region</label>
                <select id="region" name="region" class=" w-full">
                    <option value="" selected disabled>
                        -- Pilih Region --
                    </option>
                    @foreach ($provinces as $province)
                        <option value="{{ $province->code }}">{{ $province->name }}</option>
                    @endforeach
                </select>
            </div>
        </div>

        <x-slot:footer>
            <x-button.info class="w-full text-xl" id="updateBtnProgram">Konfirmasi</x-button.info>
        </x-slot:footer>
    </x-modal>

    <table id="activity-table" class="table">
        <thead>
            <tr>
                <th scope="col">
                    <a class="table-head">
                        {{ __('Nama Outlet') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col">
                    <a class="table-head">
                        {{ __('Nama Sales') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col">
                    <a class="table-head">
                        {{ __('Kode Outlet') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col">
                    <a class="table-head">
                        {{ __('Tipe Outlet') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col">
                    <a class="table-head">
                        {{ __('Channel') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col">
                    <a class="table-head">
                        Aksi
                    </a>
                </th>
            </tr>
        </thead>
    </table>
    {{-- Visibility Table End --}}
</x-card>
@endsection

@push('scripts')
    <script>
        $(document).ready(function () {
            $("#activity-date-range").flatpickr({
                mode: "range"
            });

            let tableActivity = $('#activity-table').DataTable({
                processing: true,
                serverSide: true,
                paging: true,
                searching: false,
                info: true,
                pageLength: 10,
                lengthMenu: [10, 20, 30, 40, 50],
                dom: 'rt<"bottom-container"<"bottom-left"l><"bottom-right"p>>',
                language: {
                    lengthMenu: "Menampilkan _MENU_ dari _TOTAL_ data",
                    paginate: {
                        previous: '<',
                        next: '>',
                        last: 'Terakhir',
                    },
                    info: "Menampilkan _START_ sampai _END_ dari _TOTAL_ data",
                    infoEmpty: "Menampilkan 0 sampai 0 dari 0 data",
                    emptyTable: "Tidak ada data yang tersedia"
                },
                ajax: {
                    url: "{{ route('visibility.activity.data') }}",
                    type: 'GET',
                    data: function (d) {
                        d.search_term = $('#global-search-activity').val();
                        d.date = $('#activity-date-range').val() == 'Date Range' ? '' : $('#activity-date-range').val();
                    }
                },
                columns: [
                    {
                        data: 'outlet',
                        name: 'outlet',
                        class: 'table-data'
                    },
                    {
                        data: 'sales',
                        name: 'sales',
                        class: 'table-data'
                    },

                    {
                        data: 'code',
                        name: 'code',
                        class: 'table-data'
                    },
                    {
                        data: 'type',
                        name: 'type',
                        class: 'table-data'
                    },
                    {
                        data: 'channel',
                        name: 'channel',
                        class: 'table-data'
                    },
                    {
                        data: 'actions',
                        name: 'actions',
                        class: 'table-data',
                        orderable: false,
                        searchable: false
                    }
                ],
                order: [[0, 'asc']]
            });
            // Event Handlers for Sales Table
            $(document).on('change', '#dt-length-activity', function () {
                var length = $(this).val();
                tableActivity.page.len(length).draw();
            });

            let searchTimerSales;
            $('#global-search-activity').on('input', function () {
                clearTimeout(searchTimerSales);
                searchTimerSales = setTimeout(() => tableActivity.ajax.reload(null, false), 500);
            });
            $('#activity-date-range').on('change', function () {
                tableActivity.ajax.reload(null, false);
            });
       // Handle file input change for preview
            $('input[type="file"]').on('change', function () {
                const file = this.files[0];
                if (file) {
                    if (file.size > 5 * 1024 * 1024) {
                        toast('error', 'Ukuran file tidak boleh lebih dari 5MB');
                        this.value = '';
                        return;
                    }

                    const reader = new FileReader();
                    const inputContainer = $(this).closest('.image-input-container');

                    reader.onload = function (e) {
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



        $('#downloadActivityBtn').click(function (e) {
            e.preventDefault();
            // Get the current date filter
            const dateFilter = $('#activity-date-range').val();
            // Show loading state
            const $btn = $(this);
            const $btnText = $btn.find('#downloadBtnText');
            const $btnLoading = $btn.find('#downloadBtnLoading');

            $btnText.addClass('hidden');
            $btnLoading.removeClass('hidden');
            $btn.prop('disabled', true);

            // Create URL with date filter
            const url = "{{ route('visibility.download-activity') }}?" + new URLSearchParams({
                date: dateFilter === 'Date Range' ? '' : dateFilter
            }).toString();

            // Start download
            fetch(url)
                .then(response => {
                    if (!response.ok) {
                        return response.json().then(data => {
                            throw new Error(data.message || 'Gagal mengunduh file');
                        });
                    }
                    return response.blob();
                })
                .then(blob => {
                    const url = window.URL.createObjectURL(blob);
                    const a = document.createElement('a');
                    a.href = url;
                    a.download = 'visibility_activity_' + new Date().toISOString().slice(0, 19).replace(/[:]/g, '-') + '.xlsx';
                    document.body.appendChild(a);
                    a.click();
                    window.URL.revokeObjectURL(url);
                    document.body.removeChild(a);
                    toast('success', 'File berhasil diunduh', 500);
                })
                .catch(error => {
                    console.error('Download error:', error);
                    toast('error', error.message || 'Gagal mengunduh file', 300);
                })
                .finally(() => {
                    $btnText.removeClass('hidden');
                    $btnLoading.addClass('hidden');
                    $btn.prop('disabled', false);
                });
        });
    </script>
@endpush

@push('scripts')
    <script>
        $('#channel, #region').select2()
        $('#updateBtnPlanogram').click(function (e) {
            e.preventDefault();
            const max_planogram_size = 2 * 1024 * 1024; 
            const formData = new FormData();
            const planogramFile = $('#planogram_file')[0].files[0];

            // Fungsi untuk menampilkan toast
            function showToast(type, message) {
                toast(type, message, 200);
            }

            // Validasi PDF
            if (planogramFile) {
                if (planogramFile.size > max_planogram_size) {
                    showToast('error', 'Ukuran file planogram tidak boleh lebih dari 2MB');
                    return;
                }
                const channel = $('#channel').val();
                formData.append('channel', channel);
                formData.append('planogram_file', planogramFile);
            }else {
                showToast('error', 'File planogram tidak boleh kosong');
                return;
            }

        proceedWithUpload();


            function proceedWithUpload() {
                formData.append('_method', 'PUT');
                $.ajax({
                    url: '{{ route('upload-planogram') }}',
                    type: 'POST',
                    data: formData,
                    contentType: false,
                    processData: false,
                    cache: false,
                    beforeSend: function () {
                        $('#updateBtnPlanogram').prop('disabled', true);
                        $('#updateBtnPlanogram').html('Uploading...');
                    },
                    success: function (response) {
                        if (response.status === 'success') {
                            closeModal('upload-planogram');
                            showToast('success', response.message);
                            setTimeout(() => {
                                window.location.reload();
                            }, 2000);
                        }
                    },
                    error: function (xhr) {
                        showToast('error', 'Terjadi kesalahan saat upload');
                        console.error(xhr.responseText);
                    },
                    complete: function () {
                        $('#updateBtnPlanogram').prop('disabled', false);
                        $('#updateBtnPlanogram').html('Update');
                    }
                });
            }
        });

        $('#updateBtnProgram').click(function (e) {
            e.preventDefault();
            const max_program_size = 2 * 1024 * 1024; 
            const formData = new FormData();
            const programFile = $('#program_file')[0].files[0];

            // Fungsi untuk menampilkan toast
            function showToast(type, message) {
                toast(type, message, 200);
            }

            // Validasi PDF
            if (programFile) {
                if (programFile.size > max_program_size) {
                    showToast('error', 'Ukuran file program tidak boleh lebih dari 2MB');
                    return;
                }
                const region = $('#region').val();
                formData.append('province_code', region);
                formData.append('program_file', programFile);
            }else {
                showToast('error', 'File planogram tidak boleh kosong');
                return;
            }

        proceedWithUpload();


            function proceedWithUpload() {
                formData.append('_method', 'PUT');
                $.ajax({
                    url: '{{ route('upload-program') }}',
                    type: 'POST',
                    data: formData,
                    contentType: false,
                    processData: false,
                    cache: false,
                    beforeSend: function () {
                        $('#updateBtnPlanogram').prop('disabled', true);
                        $('#updateBtnPlanogram').html('Uploading...');
                    },
                    success: function (response) {
                        if (response.status === 'success') {
                            closeModal('upload-planogram');
                            showToast('success', response.message);
                            setTimeout(() => {
                                window.location.reload();
                            }, 2000);
                        }
                    },
                    error: function (xhr) {
                        showToast('error', 'Terjadi kesalahan saat upload');
                        console.error(xhr.responseText);
                    },
                    complete: function () {
                        $('#updateBtnPlanogram').prop('disabled', false);
                        $('#updateBtnPlanogram').html('Update');
                    }
                });
            }
        });

         </script>
@endpush

@push('scripts')
    <script>
        document.getElementById('program_file').addEventListener('change', function(e) {
            const fileName = e.target.files[0] ? e.target.files[0].name : 'No file selected';
            document.getElementById('bannerProgramFileNameDisplay').value = fileName;
        });
        document.getElementById('planogram_file').addEventListener('change', function(e) {
            const fileName = e.target.files[0] ? e.target.files[0].name : 'No file selected';
            document.getElementById('planogramFileNameDisplay').value = fileName;
        });
    </script>
@endpush
