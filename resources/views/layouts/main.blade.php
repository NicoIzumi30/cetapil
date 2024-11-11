<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    @vite('resources/css/layout.css')
    @vite('resources/js/dashboard.js')
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
	<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
	@stack('scripts')
	@stack('styles')
</head>

<body class="bg-[#003060]">
    <div class=" flex items-start ">
        @include('components.sidebar')
		<div class="w-full gap-4 my-5 mx-5">
			@yield('banner-content')
			@yield('dashboard-content')
			<footer class="text-[12px] text-end text-white p-3 self-end w-[100%] absolute right-0 ">
				Powered by Zira Creative and well designed by IGNICE - 2024 All Rights Reserved
			</footer>
		</div>
    </div>

</body>
</html>
