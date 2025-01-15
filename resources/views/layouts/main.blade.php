<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
        integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
        integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/2.1.8/css/dataTables.dataTables.css" />
    <script src="https://cdn.datatables.net/2.1.8/js/dataTables.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/simple-notify@1.0.4/dist/simple-notify.css" />

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script src="https://cdn.jsdelivr.net/npm/simple-notify@1.0.4/dist/simple-notify.min.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    @vite('resources/css/layout.css')
    @stack('styles')
</head>

<body class="bg-[#003060] relative">
    @include('components.sidebar')
    <div id="main-content" class="my-5 ml-20 z-[20]">
        {{-- Banner Title --}}
        @yield('banner-content')
        {{-- Dashboard Content --}}
        @yield('dashboard-content')
        {{-- Call Center --}}
        <div class="fixed bottom-6 right-6 z-[9999] flex flex-col gap-2 items-end ">
            <div
			 id="call-center-card"
                class="bg-white relative overflow-hidden hidden rounded-md p-4 w-[17rem] origin-left transition-all duration-100 ">
                <div class="z-50 w-full flex flex-col ">
                    <i><svg width="36" height="35" viewBox="0 0 36 35" fill="none"
                            xmlns="http://www.w3.org/2000/svg">
                            <rect x="0.5" width="35" height="35" rx="12" fill="white" />
                            <path
                                d="M18 8.5C13.0312 8.5 9 12.5312 9 17.5C9 22.4687 13.0312 26.5 18 26.5C22.9687 26.5 27 22.4687 27 17.5C27 12.5312 22.9687 8.5 18 8.5ZM17.7187 22.75C17.5333 22.75 17.3521 22.695 17.1979 22.592C17.0437 22.489 16.9236 22.3426 16.8526 22.1713C16.7817 22 16.7631 21.8115 16.7993 21.6296C16.8354 21.4477 16.9247 21.2807 17.0558 21.1496C17.1869 21.0185 17.354 20.9292 17.5359 20.893C17.7177 20.8568 17.9062 20.8754 18.0775 20.9464C18.2488 21.0173 18.3952 21.1375 18.4983 21.2916C18.6013 21.4458 18.6562 21.6271 18.6562 21.8125C18.6562 22.0611 18.5575 22.2996 18.3817 22.4754C18.2058 22.6512 17.9674 22.75 17.7187 22.75ZM19.2862 17.9687C18.5264 18.4787 18.4219 18.9461 18.4219 19.375C18.4219 19.549 18.3527 19.716 18.2297 19.839C18.1066 19.9621 17.9397 20.0312 17.7656 20.0312C17.5916 20.0312 17.4247 19.9621 17.3016 19.839C17.1785 19.716 17.1094 19.549 17.1094 19.375C17.1094 18.348 17.5819 17.5314 18.5541 16.8784C19.4578 16.2719 19.9687 15.8875 19.9687 15.0423C19.9687 14.4677 19.6406 14.0312 18.9614 13.7083C18.8016 13.6323 18.4458 13.5583 18.008 13.5634C17.4586 13.5705 17.032 13.7017 16.7034 13.9661C16.0837 14.4648 16.0312 15.0077 16.0312 15.0156C16.0271 15.1018 16.006 15.1863 15.9692 15.2644C15.9324 15.3424 15.8805 15.4124 15.8167 15.4704C15.7528 15.5284 15.6781 15.5732 15.5969 15.6024C15.5157 15.6315 15.4295 15.6444 15.3434 15.6402C15.2572 15.6361 15.1727 15.615 15.0946 15.5782C15.0166 15.5414 14.9466 15.4895 14.8886 15.4256C14.8306 15.3618 14.7857 15.2871 14.7566 15.2059C14.7275 15.1247 14.7146 15.0385 14.7187 14.9523C14.7239 14.8384 14.8031 13.8123 15.8798 12.9461C16.4381 12.497 17.1483 12.2636 17.9892 12.2533C18.5845 12.2462 19.1437 12.347 19.523 12.5261C20.6578 13.0628 21.2812 13.9577 21.2812 15.0423C21.2812 16.6281 20.2214 17.3402 19.2862 17.9687Z"
                                fill="#0075FF" />
                        </svg></i>
                    <h3 class="font-bold text-xl">Perlu Bantuan?</h3>
                    <p class="text-[12px] mb-3">Hubungi Service Center Dibawah</p>
                    <a href="/"
                        class="text-[12px] bg-[#3A416F] py-2 px-4 w-full rounded-md z-50 text-white font-semibold">Hubungi</a>
                </div>
                <img class="absolute z-0 bottom-0 opacity-65 right-0" src="{{ asset('assets/images/water.webp') }}"
                    alt="water-accent-bg">
            </div>
			<button type="button" onclick="toggleCallCenterCard()" class="bg-white border-black border-2 hover:bg-slate-300 px-4 py-1 rounded-full flex items-center shadow-lg">
				<svg width="36" height="35" viewBox="0 0 36 35" fill="none"
					xmlns="http://www.w3.org/2000/svg">
					<rect x="0.5" width="35" height="35" rx="12" fill="none" />
					<path
						d="M18 8.5C13.0312 8.5 9 12.5312 9 17.5C9 22.4687 13.0312 26.5 18 26.5C22.9687 26.5 27 22.4687 27 17.5C27 12.5312 22.9687 8.5 18 8.5ZM17.7187 22.75C17.5333 22.75 17.3521 22.695 17.1979 22.592C17.0437 22.489 16.9236 22.3426 16.8526 22.1713C16.7817 22 16.7631 21.8115 16.7993 21.6296C16.8354 21.4477 16.9247 21.2807 17.0558 21.1496C17.1869 21.0185 17.354 20.9292 17.5359 20.893C17.7177 20.8568 17.9062 20.8754 18.0775 20.9464C18.2488 21.0173 18.3952 21.1375 18.4983 21.2916C18.6013 21.4458 18.6562 21.6271 18.6562 21.8125C18.6562 22.0611 18.5575 22.2996 18.3817 22.4754C18.2058 22.6512 17.9674 22.75 17.7187 22.75ZM19.2862 17.9687C18.5264 18.4787 18.4219 18.9461 18.4219 19.375C18.4219 19.549 18.3527 19.716 18.2297 19.839C18.1066 19.9621 17.9397 20.0312 17.7656 20.0312C17.5916 20.0312 17.4247 19.9621 17.3016 19.839C17.1785 19.716 17.1094 19.549 17.1094 19.375C17.1094 18.348 17.5819 17.5314 18.5541 16.8784C19.4578 16.2719 19.9687 15.8875 19.9687 15.0423C19.9687 14.4677 19.6406 14.0312 18.9614 13.7083C18.8016 13.6323 18.4458 13.5583 18.008 13.5634C17.4586 13.5705 17.032 13.7017 16.7034 13.9661C16.0837 14.4648 16.0312 15.0077 16.0312 15.0156C16.0271 15.1018 16.006 15.1863 15.9692 15.2644C15.9324 15.3424 15.8805 15.4124 15.8167 15.4704C15.7528 15.5284 15.6781 15.5732 15.5969 15.6024C15.5157 15.6315 15.4295 15.6444 15.3434 15.6402C15.2572 15.6361 15.1727 15.615 15.0946 15.5782C15.0166 15.5414 14.9466 15.4895 14.8886 15.4256C14.8306 15.3618 14.7857 15.2871 14.7566 15.2059C14.7275 15.1247 14.7146 15.0385 14.7187 14.9523C14.7239 14.8384 14.8031 13.8123 15.8798 12.9461C16.4381 12.497 17.1483 12.2636 17.9892 12.2533C18.5845 12.2462 19.1437 12.347 19.523 12.5261C20.6578 13.0628 21.2812 13.9577 21.2812 15.0423C21.2812 16.6281 20.2214 17.3402 19.2862 17.9687Z"
						fill="#0075FF" />
				</svg>
				<p id="helptext" class="text-sm font-semibold">Perlu Bantuan?</p>			
			</button>
        </div>
        {{-- Footer --}}
        <footer class="text-[12px] text-end text-white p-3 self-end w-full absolute right-0">
            <p>Powered and well designed by IGNICE - 2024 All Rights Reserved</p>
            <a href="https://www.streamlinehq.com/illustrations" class="underline text-[8px]">Free icons from
                Streamline</a>
        </footer>
    </div>
    {{-- BG-Image --}}
    <img class="fixed w-full top-0 left-0 -z-[1] h-full" src="{{ asset('/assets/images/dashboard-bg.webp') }}"
        alt="layout background">
    @stack('scripts')
    <script src="https://cdn.jsdelivr.net/npm/simple-notify@1.0.4/dist/simple-notify.min.js"></script>

    <script>
        $.ajaxSetup({
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
            }
        });

        function toast(status, message, speed = 300) {
            let title = 'Success'
            if (status == 'error') {
                title = 'Failed'
            }
            new Notify({
                status: status,
                title: title,
                text: message,
                effect: 'fade',
                speed: speed,
                customClass: '',
                customIcon: '',
                showIcon: true,
                showCloseButton: true,
                autoclose: true,
                autotimeout: 1000,
                notificationsGap: null,
                notificationsPadding: null,
                type: 'outline',
                position: 'right top',
                customWrapper: '',
            })
        }

        function toggleLoading(show, proses) {
            if (show) {
                $('#' + proses + 'BtnText').addClass('hidden');
                $('#' + proses + 'updateBtnLoading').removeClass('hidden');
                $('#' + proses + 'updateBtn').prop('disabled', true);
            } else {
                $('#' + proses + 'BtnText').removeClass('hidden');
                $('#' + proses + 'updateBtnLoading').addClass('hidden');
                $('#' + proses + 'updateBtn').prop('disabled', false);
            }
        }
        @if (session('success'))
            toast('success', '{{ session('success') }}')
        @endif
        @if (session('error'))
            toast('error', '{{ session('error') }}')
        @endif
        @if ($errors->any())
            toast('error', '{{ $errors->first() }}', 1000)
        @endif
        function previewImage(input, id) {
            const file = input.files[0];
            if (file) {
                // Check file size (2MB = 2 * 1024 * 1024 bytes)
                const maxSize = 2 * 1024 * 1024;
                if (file.size > maxSize) {
                    alert(`Ukuran file terlalu besar. Maksimal 2 MB`);
                    input.value = '';
                    return;
                }
                const reader = new FileReader();
                const uploadArea = document.getElementById(`upload-area-${id}`);
                const previewContainer = document.getElementById(`preview-container-${id}`);
                const previewImage = document.getElementById(`preview-image-${id}`);
                reader.onload = function(e) {
                    previewImage.src = e.target.result;
                    uploadArea.classList.add('hidden');
                    previewContainer.classList.remove('hidden');
                }
                reader.readAsDataURL(file);
            }
        }

        function removeImage(id) {
            const input = document.getElementById(`img_${id}`);
            const uploadArea = document.getElementById(`upload-area-${id}`);
            const previewContainer = document.getElementById(`preview-container-${id}`);
            const previewImage = document.getElementById(`preview-image-${id}`);

            input.value = '';
            previewImage.src = '';
            uploadArea.classList.remove('hidden');
            previewContainer.classList.add('hidden');
        }
        // Make upload areas clickable
        document.addEventListener('DOMContentLoaded', function() {
            const uploadAreas = document.querySelectorAll('[id^="upload-area-"]');
            uploadAreas.forEach(area => {
                const id = area.id.replace('upload-area-', '');
                area.addEventListener('click', function() {
                    document.getElementById(`img_${id}`).click();
                });
            });
        });

        function deleteData(url, name) {
            Swal.fire({
                title: 'Apakah Anda yakin?',
                text: "Data " + name + " akan dihapus",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#e74c3c',
                cancelButtonColor: '#3085d6',
                cancelButtonText: 'Batal',
                confirmButtonText: 'Ya, hapus!'
            }).then((result) => {
                if (result.value) {
                    $.ajax({
                        url: url,
                        type: 'DELETE',
                        success: function(response) {
                            console.log(response);
                            if (response.status === 'success') {
                                toast('success', response.message, 150);
                                setTimeout(() => {
                                    window.location.reload();
                                }, 1500);
                            }
                        },
                        error: function(xhr) {
                            toast('error', xhr.responseJSON.message);
                        }
                    });
                }
            });
        }

		function toggleCallCenterCard() {
			$('#call-center-card').toggle()
			$('#helptext').toggle()
		}
    </script>
</body>

</html>
