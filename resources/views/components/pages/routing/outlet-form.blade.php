@props(['title'])

<div class="flex justify-between items-center w-full">
	<p class="text-white text-sm font-bold">{{$title}}</p>
	<input type="text" class="text-sm p-4 rounded-md outline-none text-black w-40" placeholder="Masukkan Jumlah" {$attributes}>
</div>