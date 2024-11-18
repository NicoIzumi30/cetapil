<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    @vite('resources/js/dashboard.js')
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
    <script src="https://cdn.jsdelivr.net/npm/simple-notify@1.0.4/dist/simple-notify.min.js"></script>
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
        {{-- Footer --}}
        <footer class="text-[12px] text-end text-white p-3 self-end w-[100%] absolute right-0 ">
            Powered and well designed by IGNICE - 2024 All Rights Reserved
        </footer>
    </div>
    {{-- BG-Image --}}
    <img class="fixed w-full top-0 left-0 pointer-events-none z-0 h-full"
        src="{{ asset('/assets/images/dashboard-bg.webp') }}" alt="logo">
    @stack('scripts')

    <script>
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
    </script>
</body>

</html>
