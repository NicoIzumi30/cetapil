@extends('layouts.main')

@section('banner-content')
<x-banner-content :title="'Routing'" />
@endsection

@section('dashboard-content')
<x-card>
    <x-slot:cardTitle>
        Detail Request NOO
    </x-slot:cardTitle>
    <hr class="w-full border-dashed border">
    <table class="w-full">
        <tbody>
            <tr>
                <td class="detail-title">Nama Outlet</td>
                <td class="colon">:</td>
                <td class="detail">{{ $outlet->name }}</td>
                <td class="detail-title">Email Sales</td>
                <td class="colon">:</td>
                <td class="detail">{{ $outlet->user->email }}</td>
            </tr>
            <tr>
                <td class="detail-title">PIC Sales</td>
                <td class="colon">:</td>
                <td class="detail">{{ $outlet->user->name }}</td>
                <td class="detail-title">Nomor Telepon</td>
                <td class="colon">:</td>
                <td class="detail">{{ $outlet->user->phone_number }}</td>
            </tr>
            <tr>
                <td class="detail-title">Alamat Outlet</td>
                <td class="colon">:</td>
                <td class="detail">{{ $outlet->address }}</td>
                <td class="detail-title">Hari Kunjungan</td>
                <td class="colon">:</td>
                <td class="detail">{{getVisitDays($outlet->id)}}</td>
            </tr>
            <tr>
                <td class="detail-title">Longtitude</td>
                <td class="colon">:</td>
                <td class="detail" id="longitude">{{ $outlet->longitude }}</td>
                <td class="detail-title">Latitude</td>
                <td class="colon">:</td>
                <td class="detail" id="latitude">{{ $outlet->latitude }}</td>
            </tr>
        </tbody>
    </table>
    <div class="relative mt-6">
        <div class="h-[450px] z-10" id="noo-map-location"></div>
        <button id="fullscreen-button"
            class="absolute top-3 right-3 rounded-sm w-10 h-10 grid place-items-center bg-white z-50 hover:bg-slate-200">
            <svg width="32" height="32" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path
                    d="M6 14C5.45 14 5 14.45 5 15V18C5 18.55 5.45 19 6 19H9C9.55 19 10 18.55 10 18C10 17.45 9.55 17 9 17H7V15C7 14.45 6.55 14 6 14ZM6 10C6.55 10 7 9.55 7 9V7H9C9.55 7 10 6.55 10 6C10 5.45 9.55 5 9 5H6C5.45 5 5 5.45 5 6V9C5 9.55 5.45 10 6 10ZM17 17H15C14.45 17 14 17.45 14 18C14 18.55 14.45 19 15 19H18C18.55 19 19 18.55 19 18V15C19 14.45 18.55 14 18 14C17.45 14 17 14.45 17 15V17ZM14 6C14 6.55 14.45 7 15 7H17V9C17 9.55 17.45 10 18 10C18.55 10 19 9.55 19 9V6C19 5.45 18.55 5 18 5H15C14.45 5 14 5.45 14 6Z"
                    fill="#000" />
            </svg>
        </button>
    </div>
    <x-section-card>
        <x-slot:title>Formulir Outlet</x-slot:title>
        <div class="grid gap-6 items-start">
            @foreach ($outletForms as $form)
                <x-pages.routing.outlet-detail>
                    <x-slot:title>{{ $form->question }}</x-slot:title>
                    <x-slot:value>{{ $form->answers[0]->answer ?? 'Data Tidak Tersedia' }}</x-slot:value>
                </x-pages.routing.outlet-detail>
            @endforeach

        </div>
    </x-section-card>
    @if ($outlet->status == 'PENDING')
        <div class="w-full flex gap-6 mt-16">
            <x-button.light class="w-full" id="rejectBtn">Reject</x-button.light>
            <x-button.info class="w-full" onclick="openModal('approve-modal')">Approve</x-button.info>
        </div>
    @elseif($outlet->status == 'REJECTED')
        <div class="w-full flex gap-6 mt-16"></div>
        <x-button.light class="w-full" id="rejected" disabled>Rejected</x-button.light>
    @endif

    <x-modal id="approve-modal">
        <x-slot:title>Approve Request NOO</x-slot:title>

        <form action="{{ route('routing.request.approve', ['id' => $outlet->id]) }}" method="POST">
            @csrf
            @method('PUT')
            <div class="gap-4">
                <label for="outlet-code" class="!text-black">Kode Outlet</label>
                <input id="outlet-code" class="form-control @error('outlet-code') is-invalid @enderror"
                    value="{{ old('outlet-code', $outlet->outlet_code) }}" type="text" name="outlet-code"
                    placeholder="Masukan kode outlet" aria-describedby="name" />
                @if ($errors->has('outlet-code'))
                    <span id="outlet-code-error"
                        class="text-sm text-red-600 mt-1">{{ $errors->first('outlet-code') }}</span>
                @endif
            </div>
            <div class="grid grid-cols-2 gap-4">

                <div>
                    <label for="outlet-type" class="!text-black">Tipe Outlet</label>
                    <input id="outlet-type" class="form-control @error('outlet-type') is-invalid @enderror"
                        value="{{ old('outlet-type', $outlet->outlet_type) }}" type="text" name="outlet-type"
                        placeholder="Masukan tipe outlet" aria-describedby="name" />
                    @if ($errors->has('outlet-type'))
                        <span id="outlet-type-error"
                            class="text-sm text-red-600 mt-1">{{ $errors->first('outlet-type') }}</span>
                    @endif
                </div>
                <div>
                    <label for="account-type" class="!text-black">Tipe Akun</label>
                    <input id="account-type" class="form-control @error('account-type') is-invalid @enderror"
                        value="{{ old('account-type', $outlet->account_type) }}" type="text" name="account-type"
                        placeholder="Masukan tipe akun" aria-describedby="name" />
                    @if ($errors->has('account-type'))
                        <span id="account-type-error"
                            class="text-sm text-red-600 mt-1">{{ $errors->first('account-type') }}</span>
                    @endif
                </div>
               
            </div>
            <div id="cycles-wrapper" class="w-full">
                <div class="flex items-end gap-4">
                            <div class="flex-1">
                                <label for="visit_day">Waktu Kunjungan</label>
                                <select id="visit_day" name="visit_day[]" class="w-full">
                                    <option value="" selected disabled>
                                        -- Pilih waktu kunjungan --
                                    </option>
                                    @foreach ($waktuKunjungan as $hari)
                                        <option value="{{ $hari['value'] }}">{{ $hari['name'] }}</option>
                                    @endforeach
                                </select>
                                @if ($errors->has('visit_day'))
                                    <span id="visit_day-error"
                                        class="text-sm text-red-600 mt-1">{{ $errors->first('visit_day') }}</span>
                                @endif
                            </div>
                            <div class="flex-1">
                                <label for="week" class="form-label">Week</label>
                                <select id="week" name="week[]" class="w-full">
                                    <option value="" selected disabled>-- Pilih Week --</option>
                                    <option value="1">Week 1</option>
                                    <option value="2">Week 2</option>
                                    <option value="3">Week 3</option>
                                    <option value="4">Week 4</option>
                                </select>
                                @error('week')
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $message }}</strong>
                                    </span>
                                @enderror
                            </div>
                            <button type="button"
                                class="px-6 py-4 bg-primary rounded-md hover:bg-blue-500 transition-all"
                                onclick="addCycle()">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <path
                                        d="M13 6C13 5.73478 12.8946 5.48043 12.7071 5.29289C12.5196 5.10536 12.2652 5 12 5C11.7348 5 11.4804 5.10536 11.2929 5.29289C11.1054 5.48043 11 5.73478 11 6V11H6C5.73478 11 5.48043 11.1054 5.29289 11.2929C5.10536 11.4804 5 11.7348 5 12C5 12.2652 5.10536 12.5196 5.29289 12.7071C5.48043 12.8946 5.73478 13 6 13H11V18C11 18.2652 11.1054 18.5196 11.2929 18.7071C11.4804 18.8946 11.7348 19 12 19C12.2652 19 12.5196 18.8946 12.7071 18.7071C12.8946 18.5196 13 18.2652 13 18V13H18C18.2652 13 18.5196 12.8946 18.7071 12.7071C18.8946 12.5196 19 12.2652 19 12C19 11.7348 18.8946 11.4804 18.7071 11.2929C18.5196 11.1054 18.2652 11 18 11H13V6Z"
                                        fill="white" />
                                </svg>
                            </button>
                        </div>
                    </div>
        </form>
        <x-slot:footer>
            <x-button.info class="w-full" id="approveBtn">Approve</x-button.info>
        </x-slot:footer>

    </x-modal>
</x-card>
@endsection

@push('scripts')
    <script>

        $(document).ready(function () {




            // Form validation
            $('form').on('submit', function (e) {
                const cycle = $('#cycle').val();
                const week = $('#week').val();

                if ((cycle === '1x2' || cycle === '1x4') && !week) {
                    e.preventDefault();
                    alert('Mohon pilih Week terlebih dahulu');
                    return false;
                }
            });
        });
        $(document).ready(function () {
            const lat = parseFloat($('#latitude').text());
            const lng = parseFloat($('#longitude').text());

            const latlng = L.latLng(lat, lng);

            var map = L.map('noo-map-location').setView(latlng,
                13);

            L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 20,
                attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
            }).addTo(map);

            var marker = L.marker(latlng).addTo(map);
            map.setView(latlng, map.getZoom());

            // Handle fullscreen toggle
            const fullScreenButton = document.querySelector('#fullscreen-button');
            const mapResize = document.querySelector('#noo-map-location');

            fullScreenButton.addEventListener("click", () => {
                mapResize.classList.toggle("!h-[600px]");
                // Invalidate map size after resize
                setTimeout(() => {
                    map.invalidateSize();
                }, 100);
            });


            $('#approveBtn').click(function (e) {
                e.preventDefault();
                const outletId = "{{ $outlet->id }}";
                const outletCode = $('#outlet-code').val();
                const outletType = $('#outlet-type').val();
                const accountType = $('#account-type').val();
                const week = $('#week').val();
                const visitDay = $('#visit_day').val();
                let visitDays = [];
                $('select[name="visit_day[]"]').each(function () {
                    visitDays.push($(this).val());
                });
                let weeks = [];
                $('select[name="week[]"]').each(function () {
                    weeks.push($(this).val());
                });
                const $approveBtn = $(this);
                const originalText = $approveBtn.text();
                // Clear previous error messages
                $('.error-message').remove();
                $('.form-control').removeClass('border-red-500');

                // Validate form
                let hasError = false;
                if (!outletCode) {
                    $('#outlet-code').addClass('border-red-500');
                    $('#outlet-code').after('<span class="error-message text-sm text-red-600">Kode outlet harus diisi</span>');
                    hasError = true;
                }
                if (!outletType) {
                    $('#outlet-type').addClass('border-red-500');
                    $('#outlet-type').after('<span class="error-message text-sm text-red-600">Tipe outlet harus diisi</span>');
                    hasError = true;
                }
                if (!week) {
                    $('#week').addClass('border-red-500');
                    $('#week').after('<span class="error-message text-sm text-red-600">Week harus diisi</span>');
                    hasError = true;
                }
                if (!visitDay) {
                    $('#visit_day').addClass('border-red-500');
                    $('#visit_day').after('<span class="error-message text-sm text-red-600">Waktu kunjungan harus diisi</span>');
                    hasError = true;
                }
                if (hasError) {
                    return;
                }

                // Show loading state
                $approveBtn.prop('disabled', true);
                $approveBtn.html('<i class="fas fa-spinner fa-spin me-2"></i>Approving...');

                $.ajax({
                    url: `/routing/request/${outletId}/approve`,
                    type: 'PUT',
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                    },
                    contentType: 'application/json',
                    dataType: 'json',
                    data: JSON.stringify({
                        outlet_code: outletCode,
                        outlet_type: outletType,
                        account_type: accountType,
                        visit_days: visitDays,
                        weeks: weeks
                    }),
                    success: function (response) {
                        if (response.status === 'success') {
                            closeModal('approve-modal');
                            toast('success', response.message, 200);
                            setTimeout(() => {
                                window.location.href = '/routing/request';
                            }, 2000);
                        } else {
                            toast('error', response.message || 'An error occurred', 200);
                        }
                    },
                    error: function (xhr) {
                        if (xhr.status === 422) {
                            const errors = xhr.responseJSON.errors;
                            Object.keys(errors).forEach(field => {
                                $(`#${field.replace('_', '-')}`).addClass('border-red-500');
                                $(`#${field.replace('_', '-')}`).after(
                                    `<span class="error-message text-sm text-red-600">${errors[field][0]}</span>`
                                );
                            });
                        } else {
                            toast('error', xhr.responseJSON?.message || "Gagal menyetujui outlet", 200);
                        }
                    },
                    complete: function () {
                        // Reset button state
                        $approveBtn.prop('disabled', false);
                        $approveBtn.html(originalText);
                    }
                });
            });

            // Add input event listeners to remove error styling when user types
            $('#outlet-code, #outlet-type').on('input', function () {
                $(this).removeClass('border-red-500');
                $(this).next('.error-message').remove();
            });


            $('#rejectBtn').click(function (e) {
                e.preventDefault();
                const outletId = "{{ $outlet->id }}";

                $.ajax({
                    url: `/routing/request/${outletId}/reject`,
                    type: 'PUT',
                    contentType: 'application/json', // Menentukan tipe konten
                    dataType: 'json', // Menentukan tipe data yang diharapkan dari response
                    data: JSON.stringify({ // Mengubah data menjadi string JSON
                        status: 'APPROVED'
                    }),
                    success: function (response) {
                        if (response.status == 'success') {
                            toast('success', response.message, 200);
                            setTimeout(() => {
                                window.location.href = '/routing/request';
                            }, 2000);
                        } else {
                            toast('error', "Gagal menyetujui outlet", 200)
                        }

                    },
                });
            });
        });
    </script>
    <script>
        // add cycle row function
        $(`#visit_day, #week`).select2();
        let cycleCounter = 1;

        function addCycle() {
            cycleCounter++;

            const template = `
            <div class="flex items-end gap-4" data-cycle-id="${cycleCounter}">
                <div class="flex-1">
                    <label for="visit_day_${cycleCounter}">Waktu Kunjungan</label>
                    <select id="visit_day_${cycleCounter}" name="visit_day[]" class="w-full">
                        <option value="" selected disabled>-- Pilih waktu kunjungan --</option>
                        @foreach ($waktuKunjungan as $hari)
                            <option value="{{ $hari['value'] }}">{{ $hari['name'] }}</option>
                        @endforeach
                    </select>
                </div>
                <div class="flex-1">
                    <label for="week_${cycleCounter}">Week</label>
                    <select id="week_${cycleCounter}" name="week[]" class="w-full">
                        <option value="" selected disabled>-- Pilih Week --</option>
                        <option value="1">Week 1</option>
                        <option value="2">Week 2</option>
                        <option value="3">Week 3</option>
                        <option value="4">Week 4</option>
                    </select>
                </div>
                <button type="button" class="px-6 py-4 bg-red-400 rounded-md hover:bg-red-500 transition-all" onclick="removeCycle(${cycleCounter})">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M19 4H15.5L14.5 3H9.5L8.5 4H5V6H19M6 19C6 19.5304 6.21071 20.0391 6.58579 20.4142C6.96086 20.7893 7.46957 21 8 21H16C16.5304 21 17.0391 20.7893 17.4142 20.4142C17.7893 20.0391 18 19.5304 18 19V7H6V19Z" fill="white"/>
                    </svg>
                </button>
            </div>
        `;

            document.querySelector('#cycles-wrapper').insertAdjacentHTML('beforeend', template);
            $(`#visit_day_${cycleCounter}, #week_${cycleCounter}`).select2();
        }

        function removeCycle(id) {
            const cycleToRemove = document.querySelector(`[data-cycle-id="${id}"]`);
            if (cycleToRemove) {
                cycleToRemove.remove();
            }
        }
    </script>
@endpush