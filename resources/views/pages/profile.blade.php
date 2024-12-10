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
                                placeholder="Masukan nama pengguna" value="{{ $user->name }}" readonly aria-describedby="name" />
                        </div>
                        <div class="mb-4">
                            <label for="email" class="form-label">Email Pengguna</label>
                            <input id="email" class="form-control" type="text" name="email"
                                placeholder="Masukan email pengguna" value="{{ $user->email }}" readonly aria-describedby="email" />
                        </div>
                        <div class="mb-4">
                            <label for="phone" class="form-label">Nomor Telepon Pengguna</label>
                            <input id="phone" class="form-control" type="text" name="phone"
                                placeholder="Masukan nomor telepon pengguna" value="{{ $user->phone_number }}" readonly aria-describedby="phone" />
                        </div>
                        <div>
                            <label for="role" class="form-label">Jabatan Pengguna</label>
                            <input id="role" class="form-control" type="text" name="role"
                                placeholder="Masukkkan Jabatan Pengguna" value="{{ $user->roles->first()->name ?? 'No Role' }}" readonly aria-describedby="role" />
                        </div>
                    </div>
                    {{-- Profil Pengguna End --}}

                    {{-- Area Domisili --}}
                    <x-section-card :title="'Area Domisili Pengguna'">
                        <div class="grid grid-cols-2 gap-4">
                            <div class="mb-4">
                                <label for="longitude" class="form-label">Longitudes <span class="font-normal">(DD Coordinates)</span></label>
                                <input id="longitude" class="form-control" type="text" name="longitude"
                                    placeholder="Masukkan Koordinat Longitude" value="{{ $user->longitude }}" readonly aria-describedby="longitude" />
                            </div>
                            <div class="mb-4">
                                <label for="latitude" class="form-label">Latitudes <span class="font-normal">(DMS Coordinates)</span></label>
                                <input id="latitude" class="form-control" type="text" name="latitude"
                                    placeholder="Masukkan Koordinat Latitude" value="{{ $user->latitude }}" readonly aria-describedby="latitude" />
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
                                <form id="passwordChangeForm">
                                    @csrf
                                    <div>
                                        <x-input.password :title="'Kata Sandi Lama'" name="current_password" id="current_password" placeholder="Masukkan Kata Sandi Lama" />
                                        <span id="current_password-error" class="text-red-500 text-xs hidden"></span>
                                
                                        <x-input.password :title="'Kata Sandi Baru'" name="new_password" id="new_password" placeholder="Masukkan Kata Sandi Baru" />
                                        <span id="new_password-error" class="text-red-500 text-xs hidden"></span>
                                
                                        <x-input.password :title="'Konfirmasi Kata Sandi Baru'" name="new_password_confirmation" id="new_password_confirmation" placeholder="Konfirmasi Kata Sandi Baru" />
                                        <span id="new_password_confirmation-error" class="text-red-500 text-xs hidden"></span>
                                    </div>
                                    <x-button.primary type="submit" id="passwordSubmitBtn" class="w-full">
                                        <span id="passwordSubmitBtnText">Konfirmasi</span>
                                        <span id="passwordSubmitBtnLoading" class="hidden">
                                            <i class="fas fa-spinner fa-spin mr-2"></i>Menyimpan...
                                        </span>
                                    </x-button.primary>
                                </form>
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


@push('scripts')
<script>
    function submitPasswordForm() {
        const formData = new URLSearchParams();
        formData.append('current_password', $('#current_password').val());
        
        formData.append('new_password', $('#new_password').val());
        formData.append('new_password_confirmation', $('#new_password_confirmation').val());
        formData.append('_token', $('meta[name="csrf-token"]').attr('content'));
    
        $('#passwordSubmitBtn').prop('disabled', true);
        $('#passwordSubmitBtnText').addClass('hidden');
        $('#passwordSubmitBtnLoading').removeClass('hidden');
    
        $.ajax({
            url: '/profile/update-password',
            type: 'POST',
            data: formData.toString(),
            contentType: 'application/x-www-form-urlencoded',
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
            },
            success: function(response) {
                if (response.status === 'success') {
                    $('#passwordChangeForm')[0].reset();
                    closeModal('ubah-kata-sandi');
                    toast('success', response.message);
                }
            },
            error: function(xhr) {
                if (xhr.status === 422) {
                    const errors = xhr.responseJSON.errors;
                    Object.keys(errors).forEach(key => {
                        $(`#${key}-error`).text(errors[key][0]).removeClass('hidden');
                        $(`#${key}`).addClass('border-red-500');
                    });
                    toast('error', 'Silakan periksa kembali form isian');
                } else {
                    toast('error', xhr.responseJSON?.message || 'Terjadi kesalahan');
                }
            },
            complete: function() {
                $('#passwordSubmitBtn').prop('disabled', false);
                $('#passwordSubmitBtnText').removeClass('hidden');
                $('#passwordSubmitBtnLoading').addClass('hidden');
            }
        });
        return false;
    }
    
    $(document).ready(function() {
        $('#passwordChangeForm').on('submit', function(e) {
            e.preventDefault();
            submitPasswordForm();
        });
    });
    </script>
@endpush

