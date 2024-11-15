<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    @vite(['resources/css/app.css'])
	<style>
		body {
			height: 100vh;
		}
	</style>
</head>

<body class="bg-primary text-white grid place-items-center " >
	<div class="w-[400px]">
		<img src="{{ asset('assets/images/hot-air-balloon.webp') }}" alt="unauthorized logo" class="w-[200px]"> 
		<h1 class="font-">Anda Tidak Mempunyai akses</h1>
		<p>Maaf, Anda tidak memiliki izin untuk mengakses halaman ini. Silakan hubungi administrator untuk mendapatkan akses yang sesuai.</p>
		<a href="/">Kembali Ke Beranda</a>
		<p>Jika Anda yakin seharusnya memiliki akses, silakan periksa kembali kredensial Anda atau hubungi tim support.</p>
	</div>
</body>
</html>
