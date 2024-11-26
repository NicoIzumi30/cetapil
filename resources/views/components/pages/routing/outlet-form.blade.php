@props(['title', 'name'])

<div class="flex justify-between items-center w-full">
    <p class="text-white text-sm font-bold">{{$title}}</p>
    <input type="text" name="{{$name}}" class="text-sm p-4 rounded-md outline-none text-black w-40" placeholder="Masukkan Jumlah" {$attributes}>
</div>