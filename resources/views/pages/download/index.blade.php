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
                    <option value="all" selected>
                       Semua Regional
                    </option>
                    @foreach($provinces as $province)
                        <option value="{{ $province->code }}">{{ $province->name }}</option>
                    @endforeach
                </select>
            </div>
        </div>

        <x-button.info class="w-full" data-visibility-download>
            <span id="downloadBtnText">Download</span>
            <span id="downloadBtnLoading" class="hidden">Downloading...</span>
        </x-button.info>
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

    <x-pages.download.download-card iconName="mingcute_to-do-fill">
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
                    @foreach($provinces as $province)
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

    <x-pages.download.download-card iconName="fluent_shifts-availability-20-filled">
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
                    @foreach($provinces as $province)
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

    <x-pages.download.download-card iconName="uis_chart">
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
        const downloadMenus = ["routing", "visibility", "activity", "survey", "selling", "availability"]
        downloadMenus.forEach(menu => {
            $(`#${menu}-region`).select2();
            $(`#${menu}-start-date, #${menu}-end-date`).flatpickr();
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

                // Ambil queryParams jika berupa fungsi
                const queryParams = typeof options.getQueryParams === 'function'
                    ? options.getQueryParams()
                    : options.queryParams || {};

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
                                toast('success', "Download Berhasil", 1000);
                            }
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
                            document.body.removeChild(form);
                        }, 1000);
                    });
            });
        }

        // Download untuk Product
        setupDownloadButton('[data-product-download]', {
            fetchUrl: '{{ route('download.product') }}',
        });
        setupDownloadButton('[data-program-download]', {
            fetchUrl: '{{ route('download.program') }}',
        });
        // Download untuk AV3M
        setupDownloadButton('[data-av3m-download]', {
            fetchUrl: '{{ route('download.av3m') }}',
        });
        setupDownloadButton('[data-kota-download]', {
            fetchUrl: '{{ route('download.city') }}',
        });
        // Download untuk Pengguna
        setupDownloadButton('[data-pengguna-download]', {
            fetchUrl: '{{ route('download.pengguna') }}',
        });

        // Download untuk Activity
        setupDownloadButton('[data-activity-download]', {
            fetchUrl: '{{ route('download.activity') }}',
            getQueryParams: function () {
                const startDate = $('#activity-start-date').val();
                const endDate = $('#activity-end-date').val();
                const activityDate = startDate && endDate ? `${startDate} to ${endDate}` : '';
                const activityRegion = $('#activity-region').val();

                return {
                    activity_date: activityDate,
                    activity_region: activityRegion,
                };
            },
            useForm: false,
        });
        setupDownloadButton('[data-visibility-download]', {
            fetchUrl: '{{ route('download.visibility') }}',
            getQueryParams: function () {
                const startDate = $('#visibility-start-date').val();
                const endDate = $('#visibility-end-date').val();
                const visibilityDate = startDate && endDate ? `${startDate} to ${endDate}` : '';
                const visibilityRegion = $('#visibility-region').val();

                return {
                    visibility_date: visibilityDate,
                    visibility_region: visibilityRegion,
                };
            },
            useForm: false,
        });
        setupDownloadButton('[data-survey-download]', {
            fetchUrl: '{{ route('download.survey') }}',
            getQueryParams: function () {
                const startDate = $('#survey-start-date').val();
                const endDate = $('#survey-end-date').val();
                const surveyDate = startDate && endDate ? `${startDate} to ${endDate}` : '';
                const surveyRegion = $('#survey-region').val();

                return {
                    survey_date: surveyDate,
                    survey_region: surveyRegion,
                };
            },
            useForm: false,
        });
        setupDownloadButton('[data-availability-download]', {
            fetchUrl: '{{ route('download.availability') }}',
            getQueryParams: function () {
                const startDate = $('#availability-start-date').val();
                const endDate = $('#availability-end-date').val();
                const availabilityDate = startDate && endDate ? `${startDate} to ${endDate}` : '';
                const availabilityRegion = $('#availability-region').val();

                return {
                    availability_date: availabilityDate,
                    availability_region: availabilityRegion,
                };
            },
            useForm: false,
        });
        // Download untuk Routing
        setupDownloadButton('[data-routing-download]', {
            fetchUrl: '{{ route('download.routing') }}',
            getQueryParams: function () {
                const routingWeek = $('#routing-week').val() || 'all';
                const routingRegion = $('#routing-region').val();

                return {
                    routing_week: routingWeek,
                    routing_region: routingRegion,
                };
            },
        });

        // Download untuk Selling
        setupDownloadButton('[data-selling-download]', {
            fetchUrl: '{{ route('download.selling') }}',
            getQueryParams: function () {
                const startDate = $('#selling-start-date').val();
                const endDate = $('#selling-end-date').val();
                const sellingDate = startDate && endDate ? `${startDate} to ${endDate}` : '';
                const sellingRegion = $('#selling-region').val() || 'all';

                return {
                    selling_date: sellingDate,
                    selling_region: sellingRegion,
                };
            },
        });
    });
</script>

@endpush

@push('scripts')
    <script>
        $(document).ready(function () {
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
            $('.flatpickr-input').on('change', function () {
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
            $(document).ajaxError(function (event, jqXHR, settings, error) {
                handleError({
                    message: jqXHR.responseJSON?.message || 'Terjadi kesalahan pada server'
                });
            });
        });
        // END routing download


    </script>
@endpush