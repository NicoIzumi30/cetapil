@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Download'" />
@endsection

@section('dashboard-content')
    {{-- Download --}}
    <div class="grid grid-cols-2 p-6 gap-6">
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
                        @foreach ($provinces as $province)
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

        <x-pages.download.download-card iconName="fluent_box_20_filled">
            <x-slot:cardTitle>
                Orders
            </x-slot:cardTitle>

            <div class="mb-6">
                <div>
                    <label for="orders-start-date">Tanggal Mulai:</label>
                    <input id="orders-start-date" class="form-control" type="text" name="orders-start-date"
                        placeholder="DD/MM/YYYY" aria-describedby="name" />
                </div>
                <div>
                    <label for="orders-end-date">Tanggal Selesai:</label>
                    <input id="orders-end-date" class="form-control" type="text" name="orders-end-date"
                        placeholder="DD/MM/YYYY" aria-describedby="name" />
                </div>
                <div>
                    <label for="orders-region">Filter By Regional: </label>
                    <select id="orders-region" name="orders-region" class="w-full">
                        <option value="" selected disabled>-- Pilih Regional --</option>
                        <option value="all">Semua Regional</option>
                        @foreach ($provinces as $province)
                            <option value="{{ $province->code }}">{{ $province->name }}</option>
                        @endforeach
                    </select>
                </div>
            </div>

            <x-button.info class="w-full" data-orders-download>
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
                        <option value="all">Semua Regional</option>
                        @foreach ($provinces as $province)
                            <option value="{{ $province->code }}">{{ $province->name }}</option>
                        @endforeach
                    </select>
                </div>
            </div>

            <x-button.info class="w-full" data-survey-download>
                <span id="downloadBtnText">Download</span>
                <span id="downloadBtnLoading" class="hidden">Downloading...</span>
            </x-button.info>
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
                        <option value="all">Semua Regional</option>
                        @foreach ($provinces as $province)
                            <option value="{{ $province->code }}">{{ $province->name }}</option>
                        @endforeach
                    </select>
                </div>
            </div>

            <x-button.info class="w-full" data-availability-download>
                <span id="downloadBtnText">Download</span>
                <span id="downloadBtnLoading" class="hidden">Downloading...</span>
            </x-button.info>
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

            <x-button.info class="w-full" data-av3m-download>
                <span id="downloadBtnText">Download</span>
                <span id="downloadBtnLoading" class="hidden">Downloading...</span>
            </x-button.info>
        </x-pages.download.download-card>


    <x-pages.download.download-card iconName="mingcute_target-fill">
        <x-slot:cardTitle>
            Program
        </x-slot:cardTitle>

        <x-button.info class="w-full" data-program-download>
            <span id="downloadBtnText">Download</span>
            <span id="downloadBtnLoading" class="hidden">Downloading...</span>
        </x-button.info>
    </x-pages.download.download-card>
	
    <x-pages.download.download-card iconName="fluent_box_20_filled">
        <x-slot:cardTitle>
            Kota
        </x-slot:cardTitle>

        <x-button.info class="w-full" data-kota-download>
            <span id="downloadBtnText">Download</span>
            <span id="downloadBtnLoading" class="hidden">Downloading...</span>
        </x-button.info>
    </x-pages.download.download-card>

</div>
@endsection


@push('scripts')
    <script>
        // Initialize Select and Datepicker Components
        const downloadMenus = ["routing", "visibility", "activity", "survey", "selling", "availability", "orders"];
        downloadMenus.forEach(menu => {
            $(`#${menu}-region`).select2();
            $(`#${menu}-start-date, #${menu}-end-date`).flatpickr({
                dateFormat: "Y-m-d"
            });
        });
    </script>
@endpush

@push('scripts')
    <script>
$(document).ready(function () {
    function setupDownloadButton(selector, options) {
    $(selector).off('click').on('click', function (e) {
        e.preventDefault();

        const $btn = $(this);
        const $btnText = $btn.find('#downloadBtnText');
        const $btnLoading = $btn.find('#downloadBtnLoading');

        // Get queryParams if it's a function
        const queryParams = typeof options.getQueryParams === 'function'
            ? options.getQueryParams()
            : options.queryParams || {};

        // Handle region validation if required, but allow 'all' as valid value
        if (options.requireRegion) {
            const regionValue = queryParams.region || queryParams[options.regionParam];
            if (!regionValue) {  // Hanya check jika region kosong/null/undefined
                toast('error', 'Silakan pilih regional terlebih dahulu');
                return;
            }
        }

        // Toggle button state
        $btnText.addClass('hidden');
        $btnLoading.removeClass('hidden');
        $btn.prop('disabled', true);

        const params = new URLSearchParams(queryParams);
        const fullUrl = `${options.fetchUrl}?${params.toString()}`;

        // Create and append hidden form
        const form = document.createElement('form');
        form.method = 'GET';
        form.action = options.formAction ? `${options.formAction}?${params.toString()}` : options.fetchUrl;
        document.body.appendChild(form);

        fetch(fullUrl)
            .then(response => {
                if (response.ok) {
                    if (options.useForm) {
                        form.submit();
                    } else {
                        window.location.href = fullUrl;
                    }
                    toast('success', "File sedang diunduh", 1000);
                } else {
                    return response.json().then(data => {
                        throw new Error(data.message || "Gagal mengunduh file");
                    });
                }
            })
            .catch(error => {
                console.error('Download error:', error);
                toast('error', error.message || "Gagal mengunduh file", 1000);
            })
            .finally(() => {
                setTimeout(() => {
                    $btnText.removeClass('hidden');
                    $btnLoading.addClass('hidden');
                    $btn.prop('disabled', false);
                    if (form && form.parentNode) {
                        document.body.removeChild(form);
                    }
                }, 1000);
            });
    });
}

    // Function to create date range params
    function createDateRangeParams(prefix) {
        const startDate = $(`#${prefix}-start-date`).val();
        const endDate = $(`#${prefix}-end-date`).val();
        const dateParam = startDate && endDate ? `${startDate} to ${endDate}` : '';
        const region = $(`#${prefix}-region`).val() || 'all';
        
        return {
            [`${prefix}_date`]: dateParam,
            [`${prefix}_region`]: region
        };
    }

    // Helper functions
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

    // Simple downloads (no filters)
    const simpleDownloads = [
        { selector: '[data-product-download]', url: '{{ route("download.product") }}' },
        { selector: '[data-program-download]', url: '{{ route("download.program") }}' },
        { selector: '[data-av3m-download]', url: '{{ route("download.av3m") }}' },
        { selector: '[data-pengguna-download]', url: '{{ route("download.pengguna") }}' }
    ];

    simpleDownloads.forEach(download => {
        setupDownloadButton(download.selector, {
            fetchUrl: download.url,
            useForm: true
        });
    });

    // Date range downloads
    const dateRangeDownloads = [
        { selector: '[data-activity-download]', prefix: 'activity', url: '{{ route("download.activity") }}' },
        { selector: '[data-visibility-download]', prefix: 'visibility', url: '{{ route("download.visibility") }}' },
        { selector: '[data-survey-download]', prefix: 'survey', url: '{{ route("download.survey") }}' },
        { selector: '[data-availability-download]', prefix: 'availability', url: '{{ route("download.availability") }}' },
        { selector: '[data-orders-download]', prefix: 'orders', url: '{{ route("download.orders") }}', requireRegion: true, regionParam: 'orders_region' },
        { selector: '[data-selling-download]', prefix: 'selling', url: '{{ route("download.selling") }}', requireRegion: true, regionParam: 'selling_region' }
    ];

    dateRangeDownloads.forEach(download => {
        setupDownloadButton(download.selector, {
            fetchUrl: download.url,
            getQueryParams: () => createDateRangeParams(download.prefix),
            useForm: false,
            requireRegion: download.requireRegion,
            regionParam: download.regionParam
        });
    });

    // Routing download (special case with week parameter)
    setupDownloadButton('[data-routing-download]', {
        fetchUrl: '{{ route("download.routing") }}',
        getQueryParams: function () {
            return {
                routing_week: $('#routing-week').val() || 'all',
                routing_region: $('#routing-region').val()
            };
        },
        requireRegion: true,
        regionParam: 'routing_region'
    });

    // Initialize selects and datepickers
    const downloadMenus = ["routing", "visibility", "activity", "survey", "selling", "availability"];
    downloadMenus.forEach(menu => {
        $(`#${menu}-region`).select2();
        $(`#${menu}-start-date, #${menu}-end-date`).flatpickr({
            dateFormat: "Y-m-d"
        });
    });
    $('#routing-week').select2();

    // Handle datepicker changes
    $('.flatpickr-input').on('change', function () {
        const value = $(this).val();
        $(this).toggleClass('has-value', Boolean(value));
    });

    // Global AJAX error handler
    $(document).ajaxError(function (event, jqXHR, settings, error) {
        console.error('Error:', error);
        toast('error', jqXHR.responseJSON?.message || 'Terjadi kesalahan pada server');
    });
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
                toast('error', error.message || 'Terjadi kesalahan');
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

            if (!region) {
                showToast('error', 'Silakan pilih regional terlebih dahulu');
                return;
            }

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
            form.action = '{{ route('download.pengguna') }}';
            document.body.appendChild(form);

            fetch('{{ route('download.pengguna') }}')
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

        //ORDERS DOOWNLAOD
        $('[data-orders-download]').click(function(e) {
            e.preventDefault();

            const startDate = $('#orders-start-date').val();
            const endDate = $('#orders-end-date').val();
            const region = $('#orders-region').val();

            if (!region) {
                toast('error', 'Silakan pilih regional terlebih dahulu');
                return;
            }

            const $btn = $(this);
            const $btnText = $btn.find('#downloadBtnText');
            const $btnLoading = $btn.find('#downloadBtnLoading');

            $btnText.addClass('hidden');
            $btnLoading.removeClass('hidden');
            $btn.prop('disabled', true);

            const params = new URLSearchParams();
            if (startDate && endDate) {
                params.append('orders_date', `${startDate} to ${endDate}`);
            }
            params.append('orders_region', region || 'all');

            window.location.href = `{{ route('download.orders') }}?${params.toString()}`;
            toast('success', 'File sedang diunduh');

            setTimeout(() => {
                $btnText.removeClass('hidden');
                $btnLoading.addClass('hidden');
                $btn.prop('disabled', false);
            }, 1000);
        });
        //END ORDERS DOWNLOAD
    </script>
@endpush
