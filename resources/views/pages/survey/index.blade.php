@extends('layouts.main')

@section('banner-content')
<x-banner-content :title="'Survey'" />
@endsection

@section('dashboard-content')
{{-- Users --}}
<x-card>
    <x-slot:cardTitle>
        Sales Activity
    </x-slot:cardTitle>
    {{-- Users Action --}}
    <x-slot:cardAction>
        <x-input.search id="global-survey-search" class="border-0"
            placeholder="Cari data survey"></x-input.search>
			<x-button.info>Download</x-button.info>
    </x-slot:cardAction>
    {{-- Users Action End --}}

    <table class="table" id="table_survey">
        <thead>
            <tr>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="name">
                        {{ __('Nama Sales') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="email">
                        {{ __('Nama Outlet') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="position">
                        {{ __(key: 'Hari Kunjungan') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="outlet_area">
                        {{ __(key: 'Check-In') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="status">
                        {{ __('Check-Out') }}
                        <x-icons.sort />
                    </a>
                </th>
                <th scope="col" class="text-center">
                    <a href="#" class="table-head sort-link" data-column="status">
                        {{ __('Views') }}
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
				<td scope="row">
					halo
				</td>
				<td scope="row">
					halo
				</td>
				<td scope="row">
					halo
				</td>
				<td scope="row">
					halo
				</td>
				<td scope="row">
					halo
				</td>
				<td scope="row">
					halo
				</td>
				<td>
					<x-action-table-dropdown>
						<li>
							<a href="/survey/detail" class="dropdown-option">Lihat
								Data</a>
						</li>
					</x-action-table-dropdown>
				</td>
			</tr>
		</tbody>
    </table>
</x-card>

@endsection

