
@props(['title', 'img', 'message, statusCode'])

@php

    $errorList = [
        (object) [
            'title' => 'Dont Have Permission',
            'message' => 'Beranda',
            'path' => '/',
			'statusCode' => '403'
        ],
        (object) [
            'title' => 'Beranda',
            'message' => 'Beranda',
            'path' => '/',
			'statusCode' => '403'
        ],
    ];
@endphp

<main class="bg-primary text-white grid place-items-center " >
	<div class="w-[400px]">
		<img src="{{ asset('assets/images/hot-air-balloon.webp') }}" alt="unauthorized logo" class="w-[200px]"> 
		<h1 class="font-">Anda Tidak Mempunyai akses</h1>
		<p>Maaf, Anda tidak memiliki izin untuk mengakses halaman ini. Silakan hubungi administrator untuk mendapatkan akses yang sesuai.</p>
		<button onclick="history.back()" href="/">Kembali Ke Beranda</button>
		<p>Jika Anda yakin seharusnya memiliki akses, silakan periksa kembali kredensial Anda atau hubungi tim support.</p>
	</div>
</main>
</html>
