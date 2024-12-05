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
                <td class="detail">{{$outlet->name}}</td>
                <td class="detail-title">Email Sales</td>
                <td class="colon">:</td>
                <td class="detail">{{$outlet->user->email}}</td>
            </tr>
            <tr>
                <td class="detail-title">PIC Sales</td>
                <td class="colon">:</td>
                <td class="detail">{{$outlet->user->name}}</td>
                <td class="detail-title">Nomor Telepon</td>
                <td class="colon">:</td>
                <td class="detail">{{$outlet->user->phone_number}}</td>
            </tr>
            <tr>
                <td class="detail-title">Alamat Outlet</td>
                <td class="colon">:</td>
                <td class="detail">{{$outlet->address}}</td>
                <td class="detail-title">Hari Kunjungan</td>
                <td class="colon">:</td>
                <td class="detail">{{getVisitDayByNumber($outlet->visit_day)}}</td>
            </tr>
            <tr>
                <td class="detail-title">Longtitude</td>
                <td class="colon">:</td>
                <td class="detail" id="longitude">{{$outlet->longitude}}</td>
                <td class="detail-title">Latitude</td>
                <td class="colon">:</td>
                <td class="detail" id="latitude">{{$outlet->latitude}}</td>
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
                    <x-slot:title>{{$form->question}}</x-slot:title>
                    <x-slot:value>{{$form->answers[0]->answer ?? 'Data Tidak Tersedia'}}</x-slot:value>
                </x-pages.routing.outlet-detail>
            @endforeach

        </div>
    </x-section-card>
    @if($outlet->status == 'PENDING')
    <div class="w-full flex gap-6 mt-16">
        <x-button.light class="w-full" id="rejectBtn">Reject</x-button.light>
        <x-button.info class="w-full" id="approveBtn">Approve</x-button.info>
    </div>
    @elseif($outlet->status == 'REJECTED')
    <div class="w-full flex gap-6 mt-16"></div>
        <x-button.light class="w-full" id="rejected" disabled>Rejected</x-button.light>
    @endif
</x-card>
@endsection

@push('scripts')
    <script>
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

                $.ajax({
                    url: `/routing/request/${outletId}/approve`,
                    type: 'PUT',
                    contentType: 'application/json', // Menentukan tipe konten
                    dataType: 'json', // Menentukan tipe data yang diharapkan dari response
                    data: JSON.stringify({ // Mengubah data menjadi string JSON
                        status: 'APPROVED'
                    }),
                    success: function (response) {
                        if(response.status == 'success'){
                            toast('success', response.message, 200);
                        setTimeout(() => {
                            window.location.href = '/routing/request';
                        }, 2000);
                        }else{
                            toast('error', "Gagal menyetujui outlet", 200)
                        }
                        
                    },

                });
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
                        if(response.status == 'success'){
                            toast('success', response.message, 200);
                        setTimeout(() => {
                            window.location.href = '/routing/request';
                        }, 2000);  
                        }else{
                            toast('error', "Gagal menyetujui outlet", 200)
                        }
                        
                    },
                });
            });
        });

    </script>
@endpush