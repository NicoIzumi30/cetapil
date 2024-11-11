@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Produk'" />
@endsection

@section('dashboard-content')
    <main class="w-full">
        {{-- Daftar Produk --}}
        <x-card>
            <x-slot:cardTitle>
                Daftar Produk
            </x-slot:cardTitle>
            <x-slot:cardAction>
                <x-input.search class="border-0" placeholder="Cari data produk"></x-input.search>
                <x-button.light >Download</x-button.light>
                <x-button.light onclick="openModal('tambah-produk')">
                    Tambah Daftar Produk
                </x-button.light>
                {{-- Tambah Produk Modal --}}
                <x-modal id="tambah-produk">
                    <x-slot:title>
                        Tambah Produk
                    </x-slot:title>
                    <x-slot:modalAction>
                        <x-button.info>Unggah Secara Bulk</x-button.info>
                    </x-slot:modalAction>
                    <form class="grid grid-cols-2 gap-6">
                        <div>
                            <label for="categories" class="form-label">Kategori Produk</label>
                            <div>
                                <select id="categories" name="category" class="categories w-full">
                                    <option value="" selected disabled>
                                        -- Pilih Category Product --
                                    </option>
                                    <option value="cleanser">
                                        cleanser
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div>
                            <label for="sku" class="form-label">Produk SKU</label>
                            <input id="sku" class="form-control @error('sku') is-invalid @enderror" type="text"
                                wire:model="sku" name="sku" placeholder="Masukan produk SKU" aria-describedby="sku"
                                value="">
                            @error('sku')
                                <div class="invalid-feedback">
                                    {{ $message }}
                                </div>
                            @enderror
                        </div>
                        <div>
                            <label for="type-account" class="form-label">Pilih Type Account</label>
                            <div>
                                <select id="type-account" name="type-account" class="type-account">
                                    <option value="" selected>
                                        -- Pilih Type Account --
                                    </option>
                                    <option value="cleanser">
                                        Superadmin
                                    </option>
                                    <option value="cleanser">
                                        Admin
                                    </option>
                                    <option value="cleanser">
                                        Sales
                                    </option>
                                </select>
                            </div>
                        </div>
                        <div>
                            <label for="knowledge_file">
                                Unggah product knowledge berupa file pdf
                                <div id="fileUpload" class="flex mt-2">
                                    <input type="text" readonly disabled class="form-control mt-0 border-r-none"
                                        {{-- if ($knowledge_file) value="{{ pathinfo($knowledge_file->getClientOriginalName(), PATHINFO_FILENAME) . '.pdf' }}" @endif --}} placeholder="Unggah product knowledge berupa file pdf"
                                        aria-describedby="button-addon2">
                                    <div
                                        class="bg-primary text-white align-middle p-3 rounded-r-md cursor-pointer -translate-x-2">
                                        Browse</div>
                                </div>
                                <input type="file" id="knowledge_file" name="knowledge_file" class="form-control hidden"
                                    accept="application/pdf" aria-label="Unggah product knowledge berupa file pdf">
                            </label>
                        </div>
                    </form>
                    <x-slot:footer>
                        <x-button.primary class="w-full">Tambah Produk</x-button.primary>
                    </x-slot:footer>
                </x-modal>
                {{-- Tambah Produk Modal End --}}
            </x-slot:cardAction>
            {{-- Tabel Daftar Produk --}}
            <table class="table">
                <thead>
                    <tr>
                        <th scope="col" class="text-center">
                            <a class="table-head">
                                {{ __('Kategori Produk') }}
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
                                Aksi
                            </a>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    @forelse ($items as $item)
                        <tr class="table-row">
                            <td scope="row" class="table-data">
                                {{ $item['name'] }}
                            </td>
                            <td class="px-6 py-4">
                                {{ $item['price'] }}
                            </td>
                            <td class="px-6 py-4">
                                <x-action-table-dropdown :items="$item"></x-action-table-dropdown>
                            </td>
                        </tr>
                    @empty
                        <p>data not found</p>
                    @endforelse
                </tbody>
            </table>
            {{ $items->links() }}
            {{-- Tabel Daftar Produk End --}}
        </x-card>
        {{-- Daftar Produk End --}}
        <x-card>
            <x-slot:cardTitle>
                Stock-On-Hand
            </x-slot:cardTitle>
            <x-slot:cardAction>
                <x-button.light>Download
                </x-button.light>
				<x-select.light :title="'Filter Produk'">
					<option value="apalah">apalah</option>
				</x-select.light>
				<x-select.light :title="'Filter Area'">
					<option value="maa">mamah</option>
				</x-select.light>
				<x-button.light>Datepicker
                </x-button.light>
            </x-slot:cardAction>
            {{-- Tabel Stock-on-Hand --}}
            <table class="table">
                <thead>
                    <tr>
                        <th scope="col" class="text-center">
                            <a class="table-head">
                                {{ __('Outlet') }}
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
                                {{ __('Stock-on-Hand(pcs)') }}
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
                                AV3M
                            </a>
                        </th>
                        <th scope="col" class="text-center">
                            <a class="table-head">
                                Rekomendasi
                            </a>
                        </th>
                        <th scope="col" class="text-center">
                            <a class="table-head">
                                Keterangan
                            </a>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    @forelse ($items as $item)
                        <tr class="table-row">
                            <td scope="row" class="table-data">
                                {{ $item['name'] }}
                            </td>
                            <td class="px-6 py-4">
                                {{ $item['price'] }}
                            </td>
                            <td class="px-6 py-4">
                                100
                            </td>
                            <td class="px-6 py-4 {{ $item['status'] == 'Yes' ? 'text-green-400' : 'text-red-400' }}">
                                {{ $item['status'] }}
                            </td>
                            <td class="px-6 py-4">
                                80
                            </td>
                            <td class="px-6 py-4 {{ $item['recommendation'] > 0 ? 'text-green-400' : 'text-red-400' }}">
                                {{ $item['recommendation'] }}
                            </td>
                            <td class="px-6 py-4 {{ $item['ket'] == 'Ideal' ? 'text-green-400' : 'text-red-400' }}">
                                {{ $item['ket'] }}
                            </td>
                        </tr>
                    @empty
                        <p>data not found</p>
                    @endforelse
                </tbody>
            </table>
            {{ $items->links() }}
            {{-- Tabel Stock-on-Hand End --}}
        </x-card>
    </main>
@endsection

@push('scripts')
    <script>
        $(document).ready(function() {
            $('.categories').select2();
            $('.type-account').select2({
                minimumResultsForSearch: Infinity
            });
        });
    </script>
@endpush
