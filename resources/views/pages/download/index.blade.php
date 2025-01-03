@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Download'" />
@endsection

@section('dashboard-content')
    {{-- Download --}}
    <div class="grid grid-cols-2 p-6 gap-6">
        <x-pages.download.download-card iconName="solar_routing_2_bold">
            <x-slot:cardTitle>
                Routing
            </x-slot:cardTitle>
            <div class="mb-6">
                <div>
                    <label for="routing-week">Filter By Week : </label>
                    <select id="routing-week" name="routing-week" class="w-full">
                        <option value="" selected disabled>-- Pilih Week --</option>
                        <option value="all">Semua Week</option>
                        <option value="1">Week 1</option>
                        <option value="2">Week 2</option>
                        <option value="3">Week 3</option>
                        <option value="4">Week 4</option>
                        <option value="1&3">Week 1 & 3</option>
                        <option value="2&4">Week 2 & 4</option>
                    </select>
                </div>
                <div>
                    <label for="routing-region">Filter By Regional: </label>
                    <select id="routing-region" name="routing-region" class="w-full">
                        <option value="" selected disabled>-- Pilih Regional --</option>
                        <option value="all">Semua Regional</option>
                        @foreach ($provinces as $province)
                            <option value="{{ $province->id }}">{{ $province->name }}</option>
                        @endforeach
                    </select>
                </div>
            </div>

            <x-button.info class="w-full" data-routing-download>
                <span id="downloadBtnText">Download</span>
                <span id="downloadBtnLoading" class="hidden">Downloading...</span>
            </x-button.info>
        </x-pages.download.download-card>

        <x-pages.download.download-card iconName="material-symbols_map_search_rounded">
            <x-slot:cardTitle>
                Visibility
            </x-slot:cardTitle>

            <div class="mb-6">
                <div>
                    <label for="visibility-start-date">Tanggal Mulai:</label>
                    <input id="visibility-start-date" class="form-control" type="text" name="visibility-end-date"
                        placeholder="DD/MM/YYYY" aria-describedby="name" />
                </div>
                <div>
                    <label for="visibility-end-date">Tanggal Selesai:</label>
                    <input id="visibility-end-date" class="form-control" type="text" name="visibility-end-date"
                        placeholder="DD/MM/YYYY" aria-describedby="name" />
                </div>
                <div>
                    <label for="visibility-region">Filter By Region : </label>
                    <select id="visibility-region" name="visibility-region" class="w-full">
                        <option value="" selected disabled>
                            -- Pilih Region --
                        </option>
                        <option value="MT">
                            MT
                        </option>
                        <option value="GT">
                            GT
                        </option>
                    </select>
                </div>
            </div>

            <x-button.info class="w-full">Download</x-button.info>
        </x-pages.download.download-card>

        <x-pages.download.download-card iconName="fluent_box_20_filled">
            <x-slot:cardTitle>
                Penjualan
            </x-slot:cardTitle>
        
            <div class="mb-6">
                <div>
                    <label for="selling-start-date">Tanggal Mulai:</label>
                    <input id="selling-start-date" class="form-control" type="text" name="selling-start-date"
                        placeholder="DD/MM/YYYY" aria-describedby="name" />
                </div>
                <div>
                    <label for="selling-end-date">Tanggal Selesai:</label>
                    <input id="selling-end-date" class="form-control" type="text" name="selling-end-date"
                        placeholder="DD/MM/YYYY" aria-describedby="name" />
                </div>
                <div>
                    <label for="selling-region">Filter By Regional: </label>
                    <select id="selling-region" name="selling-region" class="w-full">
                        <option value="" selected disabled>-- Pilih Regional --</option>
                        <option value="all">Semua Regional</option>
                        @foreach($provinces as $province)
                            <option value="{{ $province->code }}">{{ $province->name }}</option>
                        @endforeach
                    </select>
                </div>
            </div>
        
            <x-button.info class="w-full" data-selling-download>
                <span id="downloadBtnText">Download</span>
                <span id="downloadBtnLoading" class="hidden">Downloading...</span>
            </x-button.info>
        </x-pages.download.download-card>

        <x-pages.download.download-card iconName="fluent_clipboard">
            <x-slot:cardTitle>
                Survey
            </x-slot:cardTitle>

            <div class="mb-6">
                <div>
                    <label for="survey-start-date">Tanggal Mulai:</label>
                    <input id="survey-start-date" class="form-control" type="text" name="survey-end-date"
                        placeholder="DD/MM/YYYY" aria-describedby="name" />
                </div>
                <div>
                    <label for="survey-end-date">Tanggal Selesai:</label>
                    <input id="survey-end-date" class="form-control" type="text" name="survey-end-date"
                        placeholder="DD/MM/YYYY" aria-describedby="name" />
                </div>
                <div>
                    <label for="survey-region">Filter By Region : </label>
                    <select id="survey-region" name="survey-region" class="w-full">
                        <option value="" selected disabled>
                            -- Pilih Region --
                        </option>
                        <option value="MT">
                            MT
                        </option>
                        <option value="GT">
                            GT
                        </option>
                    </select>
                </div>
            </div>

            <x-button.info class="w-full">Download</x-button.info>
        </x-pages.download.download-card>

        <x-pages.download.download-card iconName="material-symbols_map_search_rounded">
            <x-slot:cardTitle>
                Availability
            </x-slot:cardTitle>

            <div class="mb-6">
                <div>
                    <label for="availability-start-date">Tanggal Mulai:</label>
                    <input id="availability-start-date" class="form-control" type="text" name="availability-end-date"
                        placeholder="DD/MM/YYYY" aria-describedby="name" />
                </div>
                <div>
                    <label for="availability-end-date">Tanggal Selesai:</label>
                    <input id="availability-end-date" class="form-control" type="text" name="availability-end-date"
                        placeholder="DD/MM/YYYY" aria-describedby="name" />
                </div>
                <div>
                    <label for="availability-region">Filter By Region : </label>
                    <select id="availability-region" name="availability-region" class="w-full">
                        <option value="" selected disabled>
                            -- Pilih Region --
                        </option>
                        <option value="MT">
                            MT
                        </option>
                        <option value="GT">
                            GT
                        </option>
                    </select>
                </div>
            </div>

            <x-button.info class="w-full">Download</x-button.info>
        </x-pages.download.download-card>

        <x-pages.download.download-card iconName="fluent_clipboard">
            <x-slot:cardTitle>
                Activity
            </x-slot:cardTitle>

            <div class="mb-6">
                <div>
                    <label for="activity-start-date">Tanggal Mulai:</label>
                    <input id="activity-start-date" class="form-control" type="text" name="activity-start-date"
                        placeholder="DD/MM/YYYY" aria-describedby="name" />
                </div>
                <div>
                    <label for="activity-end-date">Tanggal Selesai:</label>
                    <input id="activity-end-date" class="form-control" type="text" name="activity-end-date"
                        placeholder="DD/MM/YYYY" aria-describedby="name" />
                </div>
                <div>
                    <label for="activity-region">Filter By Region : </label>
                    <select id="activity-region" name="activity-region" class="w-full">
                        <option value="all" selected>
                            Semua
                        </option>
                        @foreach ($provinces as $province)
                            <option value="{{ $province->code }}">{{ $province->name }}</option>
                        @endforeach
                    </select>
                </div>
            </div>

            <x-button.info class="w-full" data-activity-download>
                <span id="downloadBtnText">Download</span>
                <span id="downloadBtnLoading" class="hidden">Downloading...</span>
            </x-button.info>
        </x-pages.download.download-card>

        <x-pages.download.download-card iconName="fluent_box_20_filled">
            <x-slot:cardTitle>
                Produk
            </x-slot:cardTitle>

            <x-button.info class="w-full" data-product-download>
                <span id="downloadBtnText">Download</span>
                <span id="downloadBtnLoading" class="hidden">Downloading...</span>
            </x-button.info>
        </x-pages.download.download-card>

        <x-pages.download.download-card iconName="mdi_account_group">
            <x-slot:cardTitle>
                Pengguna
            </x-slot:cardTitle>

            <x-button.info class="w-full" data-pengguna-download>
                <span id="downloadBtnText">Download</span>
                <span id="downloadBtnLoading" class="hidden">Downloading...</span>
            </x-button.info>
        </x-pages.download.download-card>

        <x-pages.download.download-card iconName="fluent_box_20_filled">
            <x-slot:cardTitle>
                AV3M
            </x-slot:cardTitle>

            <x-button.info class="w-full">Download</x-button.info>
        </x-pages.download.download-card>
    </div>
@endsection


@push('scripts')
    <script>
        // Initialize Select and Datepicker Components
        const downloadMenus = ["routing", "visibility", "activity", "survey", "selling", "availability"]
        downloadMenus.forEach(menu => {
            $(`#${menu}-region`).select2();
            $(`#${menu}-start-date, #${menu}-end-date`).flatpickr();
        });
    </script>
@endpush

@push('scripts')
    <script>
        $(document).ready(function() {
            // Handle product download button click
            $('[data-product-download]').click(function(e) {
                e.preventDefault();

                // Show loading state
                const $btn = $(this);
                const $btnText = $btn.find('#downloadBtnText');
                const $btnLoading = $btn.find('#downloadBtnLoading');

                $btnText.addClass('hidden');
                $btnLoading.removeClass('hidden');
                $btn.prop('disabled', true);

                // Create a hidden form for download
                const form = document.createElement('form');
                form.method = 'GET';
                form.action = '{{ route('download.product') }}';
                document.body.appendChild(form);

                fetch('{{ route('download.product') }}')
                    .then(response => {
                        if (response.ok) {
                            form.submit();
                            toast('success', 'File berhasil diunduh', 1000);
                        } else {
                            return response.json().then(data => {
                                throw new Error(data.message || 'Gagal mengunduh file');
                            });
                        }
                    })
                    .catch(error => {
                        console.error('Download error:', error);
                        toast('error', error.message || 'Gagal mengunduh file', 1000);
                    })
                    .finally(() => {
                        setTimeout(() => {
                            $btnText.removeClass('hidden');
                            $btnLoading.addClass('hidden');
                            $btn.prop('disabled', false);
                            document.body.removeChild(form);
                        }, 1000);
                    });
            });

            // Toast notification function
            function toast(type, message, duration = 3000) {
                Swal.fire({
                    icon: type,
                    title: message,
                    toast: true,
                    position: 'top-end',
                    showConfirmButton: false,
                    timer: duration,
                    timerProgressBar: true
                });
            }
        });
    </script>
@endpush

@push('scripts')
    <script>
        $(document).ready(function() {
            // Initialize select2 untuk semua select di halaman download
            const downloadMenus = ["routing", "visibility", "activity", "survey", "selling", "availability"];
            downloadMenus.forEach(menu => {
                $(`#${menu}-region`).select2();
                $(`#${menu}-start-date, #${menu}-end-date`).flatpickr({
                    dateFormat: "Y-m-d"
                });
            });
            $('#routing-week').select2();
            $('[data-activity-download]').click(function(e) {

                e.preventDefault();
                // Ambil nilai filter
                const startDate = $('#activity-start-date').val();
                const endDate = $('#activity-end-date').val();
                const region = $('#activity-region').val();

                // Show loading state
                const $btn = $(this);
                const $btnText = $btn.find('#downloadBtnText');
                const $btnLoading = $btn.find('#downloadBtnLoading');

                $btnText.addClass('hidden');
                $btnLoading.removeClass('hidden');
                $btn.prop('disabled', true);

                // Build query parameters
                const params = new URLSearchParams({
                    activity_date: startDate && endDate ? `${startDate} to ${endDate}` : '',
                    activity_region: region
                });
                // Create temporary form for download
                const form = document.createElement('form');
                form.method = 'GET';
                form.action = `{{ route('download.activity') }}?${params.toString()}`;
                document.body.appendChild(form);
                const url = `{{ route('download.activity') }}?${params.toString()}`;
                fetch(url) // Gunakan URL lengkap
                    .then(response => {
                        console.log('Response:', response);
                        if (response.ok) {
                            window.location.href =
                                `{{ route('download.activity') }}?${params.toString()}`;
                            showToast('success', 'File berhasil diunduh');
                        } else {
                            return response.json().then(data => {
                                throw new Error(data.message || 'Gagal mengunduh file');
                            });
                        }
                    })
                    .catch(error => {
                        console.error('Download error:', error);
                        showToast('error', error.message || 'Gagal mengunduh file');
                    })
                    .finally(() => {
                        setTimeout(() => {
                            $btnText.removeClass('hidden');
                            $btnLoading.addClass('hidden');
                            $btn.prop('disabled', false);
                            document.body.removeChild(form);
                        }, 1000);
                    });

            });
            // Handle routing download

            $('[data-routing-download]').click(function(e) {
                e.preventDefault();
                
                const region = $('#routing-region').val();
                if (!region) {
                    showToast('error', 'Silakan pilih regional terlebih dahulu');
                    return;
                }

                const week = $('#routing-week').val() || 'all';
                const $btn = $(this);
                const $btnText = $btn.find('#downloadBtnText');
                const $btnLoading = $btn.find('#downloadBtnLoading');

                $btnText.addClass('hidden');
                $btnLoading.removeClass('hidden');
                $btn.prop('disabled', true);

                const params = new URLSearchParams({ routing_week: week, routing_region: region });
                window.location.href = `{{ route('download.routing') }}?${params.toString()}`;
                showToast('success', 'File sedang diunduh');

                setTimeout(() => {
                    $btnText.removeClass('hidden');
                    $btnLoading.addClass('hidden');
                    $btn.prop('disabled', false);
                }, 1000);
            });

            // Handle file upload area
            function setupFileUpload(prefix) {
                const uploadArea = document.getElementById(`upload-area-${prefix}`);
                const fileInput = document.getElementById(`file_upload-${prefix}`);
                const displayFileName = document.getElementById(`filename-display-${prefix}`);
                const uploadHelptext = document.getElementById(`upload-helptext-${prefix}`);
                const maxFileSize = 5 * 1024 * 1024; // 5MB

                if (!uploadArea) return;

                uploadArea.addEventListener('click', () => fileInput.click());

                ['dragover', 'dragleave', 'drop'].forEach(eventName => {
                    uploadArea.addEventListener(eventName, (e) => {
                        e.preventDefault();
                        uploadArea.classList.toggle('drag-over', eventName === 'dragover');
                        if (eventName === 'drop') handleFiles(e.dataTransfer.files);
                    });
                });

                fileInput.addEventListener('change', (e) => handleFiles(e.target.files));

                function handleFiles(files) {
                    if (!files.length) return;

                    const file = files[0];
                    const validTypes = [
                        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                        'application/wps-office.xlsx',
                        'application/vnd.ms-excel',
                        'text/csv'
                    ];

                    if (!validTypes.includes(file.type)) {
                        showToast('error', 'Format file tidak didukung. Gunakan format .xlsx atau .csv');
                        fileInput.value = '';
                        return;
                    }

                    if (file.size > maxFileSize) {
                        showToast('error', 'Ukuran file melebihi batas maksimal 5MB');
                        fileInput.value = '';
                        return;
                    }

                    displayFileName.classList.remove('hidden');
                    uploadHelptext.classList.add('hidden');
                    displayFileName.innerText = file.name;
                }
            }

            // Initialize file upload for each relevant section
            ['av3m'].forEach(prefix => setupFileUpload(prefix));

            // Utility functions
            function showToast(type, message, duration = 3000) {
                Swal.fire({
                    icon: type,
                    title: message,
                    toast: true,
                    position: 'top-end',
                    showConfirmButton: false,
                    timer: duration,
                    timerProgressBar: true
                });
            }

            function formatDate(date) {
                return date.toISOString().split('T')[0];
            }

            // Handle datepicker changes
            $('.flatpickr-input').on('change', function() {
                const id = $(this).attr('id');
                const value = $(this).val();

                if (value) {
                    $(this).addClass('has-value');
                } else {
                    $(this).removeClass('has-value');
                }
            });

            // Error handler
            function handleError(error) {
                console.error('Error:', error);
                showToast('error', error.message || 'Terjadi kesalahan');
            }

            // Global AJAX error handler
            $(document).ajaxError(function(event, jqXHR, settings, error) {
                handleError({
                    message: jqXHR.responseJSON?.message || 'Terjadi kesalahan pada server'
                });
            });
        });
        // END routing download


        //SELLING DOWNLOAD

        $('[data-selling-download]').click(function(e) {
    e.preventDefault();

    const startDate = $('#selling-start-date').val();
    const endDate = $('#selling-end-date').val();
    const region = $('#selling-region').val();

    // Remove date validation to allow region-only downloads
    const $btn = $(this);
    const $btnText = $btn.find('#downloadBtnText');
    const $btnLoading = $btn.find('#downloadBtnLoading');

    $btnText.addClass('hidden');
    $btnLoading.removeClass('hidden');
    $btn.prop('disabled', true);

    const params = new URLSearchParams();
    if (startDate && endDate) {
        params.append('selling_date', `${startDate} to ${endDate}`);
    }
    params.append('selling_region', region || 'all');

    window.location.href = `{{ route('download.selling') }}?${params.toString()}`;
    showToast('success', 'File sedang diunduh');

    // Reset button state after delay
    setTimeout(() => {
        $btnText.removeClass('hidden');
        $btnLoading.addClass('hidden');
        $btn.prop('disabled', false);
    }, 1000);
});
//END SELLING DOWNLOAD

//PENGGUNA DOWNLOAD
$('[data-pengguna-download]').click(function(e) {
   e.preventDefault();
   
   const $btn = $(this);
   const $btnText = $btn.find('#downloadBtnText');
   const $btnLoading = $btn.find('#downloadBtnLoading');

   $btnText.addClass('hidden');
   $btnLoading.removeClass('hidden');
   $btn.prop('disabled', true);

   const form = document.createElement('form');
   form.method = 'GET'; 
   form.action = '{{ route("download.pengguna") }}';
   document.body.appendChild(form);

   fetch('{{ route("download.pengguna") }}')
       .then(response => {
           if (response.ok) {
               form.submit();
               Swal.fire({
                   icon: 'success',
                   title: 'File berhasil diunduh',
                   toast: true,
                   position: 'top-end',
                   showConfirmButton: false,
                   timer: 3000,
                   timerProgressBar: true
               });
           } else {
               return response.json().then(data => {
                   throw new Error(data.message || 'Gagal mengunduh file');
               });
           }
       })
       .catch(error => {
           console.error('Download error:', error);
           Swal.fire({
               icon: 'error', 
               title: error.message || 'Gagal mengunduh file',
               toast: true,
               position: 'top-end',
               showConfirmButton: false,
               timer: 3000,
               timerProgressBar: true
           });
       })
       .finally(() => {
           setTimeout(() => {
               $btnText.removeClass('hidden');
               $btnLoading.addClass('hidden');
               $btn.prop('disabled', false);
               document.body.removeChild(form);
           }, 1000);
       });
});
//END PENGGUNA DOWNLOAD
    </script>
@endpush
