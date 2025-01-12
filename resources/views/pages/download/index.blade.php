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
                <select id="selling-region" name="selling_region" class="w-full">
                    <option value="all" selected>Semua Regional</option>
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
                    <option value="all" selected>Semua Regional</option>
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
                <input id="survey-start-date" class="form-control" type="text" 
                    placeholder="DD/MM/YYYY" aria-describedby="name" />
            </div>
            <div>
                <label for="survey-end-date">Tanggal Selesai:</label>
                <input id="survey-end-date" class="form-control" type="text" 
                    placeholder="DD/MM/YYYY" aria-describedby="name" />
            </div>
            <div>
                <label for="survey-region">Filter By Region : </label>
                <select id="survey-region" name="survey_region" class="w-full">
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
            Routing
        </x-slot:cardTitle>
        <div class="mb-6">
            <div>
                <label for="routing-week">Filter By Week: </label>
                <select id="routing-week" name="routing-week" class="w-full">
                    <option value="" selected disabled>-- Pilih Week --</option>
                    <option value="all">Semua</option>
                    <option value="1">Week 1</option>
                    <option value="2">Week 2</option>
                    <option value="3">Week 3</option>
                    <option value="4">Week 4</option>
                </select>
            </div>
            <div>
                <label for="routing-region">Filter By Regional: </label>
                <select id="routing-region" name="routing-region" class="w-full">
                    <option value="" selected disabled>-- Pilih Regional --</option>
                    <option value="all">Semua Regional</option>
                    @foreach ($provinces as $province)
                        <option value="{{ $province->code }}">{{ $province->name }}</option>
                    @endforeach
                </select>
            </div>
        </div>

        <x-button.info class="w-full" data-routing-download>
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
        $(`#routing-week`).select2();
    </script>
@endpush

@push('scripts')
<script>
$(document).ready(function() {
    // Download configurations
    const downloadConfig = {
        dateRangeMenus: [
            {
                id: 'selling',
                route: '{{ route("download.selling") }}',
                requireRegion: true,
                regionParam: 'selling_region'
            },
            {
                id: 'orders',
                route: '{{ route("download.orders") }}',
                requireRegion: true,
                regionParam: 'orders_region'
            },
            {
                id: 'survey',
                route: '{{ route("download.survey") }}',
                requireRegion: true,
                regionParam: 'survey_region',
                dateParam: 'survey_date'
            },
            {
                id: 'activity',
                route: '{{ route("download.activity") }}',
                requireDateRange: true,  // Add this flag
                dateParam: 'activity_date' 
            },
            {
                id: 'visibility',
                route: '{{ route("download.visibility") }}'
            },
            {
                id: 'availability',
                route: '{{ route("download.availability") }}'
            }
        ],
        simpleDownloads: [
            {
                id: 'product',
                route: '{{ route("download.product") }}'
            },
            {
                id: 'program',
                route: '{{ route("download.program") }}'
            },
            {
                id: 'pengguna',
                route: '{{ route("download.pengguna") }}'
            },
            {
                id: 'av3m',
                route: '{{ route("download.av3m") }}'
            },
            {
                id: 'kota',
                route: '{{ route("download.city") }}'
            }
        ],
        routing: {
            id: 'routing',
            route: '{{ route("download.routing") }}',
            requireRegion: true
        }
    };

    /**
     * Initialize all form components
     */
     function initializeComponents() {
    downloadMenus.forEach(menu => {
        $(`#${menu}-region`).select2();
        $(`#${menu}-start-date, #${menu}-end-date`).flatpickr({
            dateFormat: "Y-m-d"
        });
    });
}
    /**
     * Setup download event handlers
     */
    function setupDownloadHandlers() {
        // Setup date range downloads
        downloadConfig.dateRangeMenus.forEach(menu => {
            setupDateRangeDownload(menu);
        });

        // Setup simple downloads
        downloadConfig.simpleDownloads.forEach(menu => {
            setupSimpleDownload(menu);
        });

        // Setup routing download
        setupRoutingDownload();
    }

    /**
     * Setup handler for date range based downloads
     */
    function setupDateRangeDownload(config) {
        $(`[data-${config.id}-download]`).on('click', function(e) {
            e.preventDefault();

            const params = buildDateRangeParams(config);
            
            if (config.requireRegion && !params[config.regionParam]) {
                showToast('error', 'Silakan pilih regional terlebih dahulu');
                return;
            }

            handleDownload(this, config.route, params);
        });
    }

    /**
     * Setup handler for simple downloads
     */
    function setupSimpleDownload(config) {
        $(`[data-${config.id}-download]`).on('click', function(e) {
            e.preventDefault();
            handleDownload(this, config.route);
        });
    }

    /**
     * Setup handler for routing download
     */
    function setupRoutingDownload() {
        $('[data-routing-download]').on('click', function(e) {
            e.preventDefault();

            const region = $('#routing-region').val();
            if (!region) {
                showToast('error', 'Silakan pilih regional terlebih dahulu');
                return;
            }

            const params = {
                routing_week: $('#routing-week').val() || 'all',
                routing_region: region
            };

            handleDownload(this, downloadConfig.routing.route, params);
        });
    }

    /**
     * Build parameters for date range downloads
     */
     function buildDateRangeParams(config) {
        const startDate = $(`#${config.id}-start-date`).val();
        const endDate = $(`#${config.id}-end-date`).val();
        const region = $(`#${config.id}-region`).val();
        
        const params = {
            [`${config.id}_region`]: region || 'all'
        };

        if (startDate && endDate) {
            params[`${config.id}_date`] = `${startDate} to ${endDate}`;
        }

        return params;
    }
    /**
     * Handle download process
     */
    function handleDownload(button, url, params = {}) {
        const $btn = $(button);
        const $btnText = $btn.find('#downloadBtnText');
        const $btnLoading = $btn.find('#downloadBtnLoading');

        toggleButtonState($btn, $btnText, $btnLoading, true);

        const queryString = new URLSearchParams(params).toString();
        const downloadUrl = queryString ? `${url}?${queryString}` : url;

        fetch(downloadUrl)
            .then(response => {
                if (response.ok) {
                    window.location.href = downloadUrl;
                    showToast('success', "File sedang diunduh");
                } else {
                    return response.json().then(data => {
                        throw new Error(data.message || "Gagal mengunduh file");
                    });
                }
            })
            .catch(error => {
                console.error('Download error:', error);
                showToast('error', error.message || "Gagal mengunduh file");
            })
            .finally(() => {
                setTimeout(() => {
                    toggleButtonState($btn, $btnText, $btnLoading, false);
                }, 1000);
            });
    }

    /**
     * Toggle button loading state
     */
    function toggleButtonState($btn, $btnText, $btnLoading, isLoading) {
        $btnText.toggleClass('hidden', isLoading);
        $btnLoading.toggleClass('hidden', !isLoading);
        $btn.prop('disabled', isLoading);
    }

    /**
     * Show toast notification
     */
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

    // Global error handler
    $(document).ajaxError(function(event, jqXHR, settings, error) {
        console.error('AJAX Error:', error);
        showToast('error', jqXHR.responseJSON?.message || 'Terjadi kesalahan pada server');
    });

    // Initialize everything
    initializeComponents();
    setupDownloadHandlers();
});
</script>
@endpush