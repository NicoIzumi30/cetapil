@extends('layouts.main')

@section('banner-content')
    <x-banner-content :title="'Pengaturan Akun'" />
@endsection

@section('dashboard-content')
    <main class="w-full">
        <div>
            <div class="form-edit">
                <x-card>
                    <x-slot:cardTitle>
                        Profil Pengguna
                    </x-slot:cardTitle>
                    {{-- Profil Pengguna --}}
                    <div class="grid grid-cols-2 gap-4">
                        <div class="mb-4">
                            <label for="name" class="form-label">Nama Pengguna</label>
                            <input id="name" class="form-control" type="text" name="name"
                                placeholder="Masukan nama pengguna" readonly aria-describedby="name" />
                        </div>
                        <div class="mb-4">
                            <label for="email" class="form-label">Email Pengguna</label>
                            <input id="email" class="form-control" type="text" name="email"
                                placeholder="Masukan email pengguna" readonly aria-describedby="email" />
                        </div>
                        <div class="mb-4">
                            <label for="phone" class="form-label">Nomor Telepon Pengguna</label>
                            <input id="phone" class="form-control" type="text" name="phone"
                                placeholder="Masukan nomor telepon pengguna" readonly aria-describedby="phone" />
                        </div>
                        <div>
                            <label for="role" class="form-label">Jabatan Pengguna</label>
                            <div>
								<select id="role" class="form-select-search">
									<option value="" disabled>
										-- Pilih Jabatan Pengguna --
									</option>
									<option value="superadmin" selected>
										Superadmin
									</option>
									<option value="admin">
										Admin
									</option>
									<option value="sales">
										Sales
									</option>
								</select>
							</div>
                        </div>
                    </div>
                    {{-- Profil Pengguna End --}}

                    {{-- Area Domisili --}}
                    <x-section-card :title="'Area Domisili Pengguna'">
                        <div class="grid grid-cols-2 gap-4">
                            <div class="mb-4">
                                <label for="longitude" class="form-label">Longitudes <span class="font-normal">(DD
                                        Coordinates)</span></label>
                                <input id="longitude" class="form-control" type="text" name="longitude"
                                    placeholder="Masukkan Koordinat Longitude" readonly aria-describedby="longitude" />
                            </div>
                            <div class="mb-4">
                                <label for="latitude" class="form-label">Latitudes <span class="font-normal">(DMS
                                        Coordinates)</span></label>
                                <input id="latitude" class="form-control" type="text" name="latitude"
                                    placeholder="Masukkan Koordinat Latitude" readonly aria-describedby="latitude" />
                            </div>
                        </div>
                    </x-section-card>
                    {{-- Area Domisili End --}}

                    {{-- Keamanan Akun --}}
                    <x-section-card :title="'Keamanan Akun'">
                        <div class="mt-3">
                            <x-button.primary onclick="openModal('ubah-kata-sandi')">
                                Ubah Kata Sandi
                            </x-button.primary>
                            {{-- Change Password Modal --}}
                            <x-modal id="ubah-kata-sandi">
                                <x-slot name="title">
                                    Ubah Kata Sandi
                                </x-slot>
                                <form>
                                    <div>
                                        <x-input.password :title="'Kata Sandi Lama'" placeholder="Masukkan Kata Sandi Lama" />
                                        <x-input.password :title="'Kata Sandi Baru'" placeholder="Masukkan Kata Sandi baru" />
                                    </div>
                                    <x-input.password :title="'Konfirmasi Kata Sandi Baru'" placeholder="Konfirmasi Kata Sandi Baru" />
                                </form>
                                <x-slot:footer>
                                    <x-button.primary class="w-full">Konfirmasi</x-button.primary>
                                </x-slot:footer>
                            </x-modal>
                            {{-- Change Password Modal End --}}
                        </div>
                    </x-section-card>
                    {{-- Keamanan Akun End --}}
            </div>
            </x-card>
        </div>
        </div>
    </main>
@endsection

@push('addon-toast')
    <x-toast>
        <x-slot:title>
            Perubahan Berhasil Disimpan
        </x-slot:title>
        <x-slot:subTitle>
            Anda baru saja melakukan perubahan pada aplikasi. Silahkan periksa perubahan pada menu yang Anda lakukan
            perubahan.
        </x-slot:subTitle>
    </x-toast>
@endpush
