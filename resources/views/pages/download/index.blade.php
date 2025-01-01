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
                    <label for="routing-start-date">Tanggal Mulai:</label>
                    <input id="routing-start-date" class="form-control" type="text" name="routing-end-date" placeholder="DD/MM/YYYY"
                        aria-describedby="name" />
                </div>
                <div>
                    <label for="routing-end-date">Tanggal Selesai:</label>
                    <input id="routing-end-date" class="form-control" type="text" name="routing-end-date" placeholder="DD/MM/YYYY"
                        aria-describedby="name" />
                </div>
                <div>
                    <label for="routing-region">Filter By Region : </label>
                    <select id="routing-region" name="routing-region" class="w-full">
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
                Visibility
            </x-slot:cardTitle>

			<div class="mb-6">
                <div>
                    <label for="visibility-start-date">Tanggal Mulai:</label>
                    <input id="visibility-start-date" class="form-control" type="text" name="visibility-end-date" placeholder="DD/MM/YYYY"
                        aria-describedby="name" />
                </div>
                <div>
                    <label for="visibility-end-date">Tanggal Selesai:</label>
                    <input id="visibility-end-date" class="form-control" type="text" name="visibility-end-date" placeholder="DD/MM/YYYY"
                        aria-describedby="name" />
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
                    <input id="selling-start-date" class="form-control" type="text" name="selling-end-date" placeholder="DD/MM/YYYY"
                        aria-describedby="name" />
                </div>
                <div>
                    <label for="selling-end-date">Tanggal Selesai:</label>
                    <input id="selling-end-date" class="form-control" type="text" name="selling-end-date" placeholder="DD/MM/YYYY"
                        aria-describedby="name" />
                </div>
                <div>
                    <label for="selling-region">Filter By Region : </label>
                    <select id="selling-region" name="selling-region" class="w-full">
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
                Survey
            </x-slot:cardTitle>

			<div class="mb-6">
                <div>
                    <label for="survey-start-date">Tanggal Mulai:</label>
                    <input id="survey-start-date" class="form-control" type="text" name="survey-end-date" placeholder="DD/MM/YYYY"
                        aria-describedby="name" />
                </div>
                <div>
                    <label for="survey-end-date">Tanggal Selesai:</label>
                    <input id="survey-end-date" class="form-control" type="text" name="survey-end-date" placeholder="DD/MM/YYYY"
                        aria-describedby="name" />
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
                    <input id="availability-start-date" class="form-control" type="text" name="availability-end-date" placeholder="DD/MM/YYYY"
                        aria-describedby="name" />
                </div>
                <div>
                    <label for="availability-end-date">Tanggal Selesai:</label>
                    <input id="availability-end-date" class="form-control" type="text" name="availability-end-date" placeholder="DD/MM/YYYY"
                        aria-describedby="name" />
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
                    <input id="activity-start-date" class="form-control" type="text" name="activity-end-date" placeholder="DD/MM/YYYY"
                        aria-describedby="name" />
                </div>
                <div>
                    <label for="activity-end-date">Tanggal Selesai:</label>
                    <input id="activity-end-date" class="form-control" type="text" name="activity-end-date" placeholder="DD/MM/YYYY"
                        aria-describedby="name" />
                </div>
                <div>
                    <label for="activity-region">Filter By Region : </label>
                    <select id="activity-region" name="activity-region" class="w-full">
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
                Produk
            </x-slot:cardTitle>

            <x-button.info class="w-full">Download</x-button.info>
        </x-pages.download.download-card>

		<x-pages.download.download-card iconName="mdi_account_group">
            <x-slot:cardTitle>
                Pengguna
            </x-slot:cardTitle>

            <x-button.info class="w-full">Download</x-button.info>
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
