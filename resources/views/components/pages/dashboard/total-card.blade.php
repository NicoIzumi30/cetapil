@props(['title', 'total', 'date', 'trendValue'])

<style>
    .card-bg {
        background: linear-gradient(108.46deg, rgba(255, 255, 255, 0.33) 0%, rgba(57, 181, 255, 0.1155) 100%);
    }
</style>

<div class="card-bg rounded-xl shadow-sm w-full overflow-hidden text-white">
    <div class="py-2 px-4 ">
        <h2 class="text-2xl text-center font-bold">{{ $title }}</h2>
        <hr class="mt-2">
    </div>
    <div class="p-2 w-full">
        <div class="flex w-full items-center justify-center gap-2 mb-4">
            <p class="text-5xl font-bold my-4 text-center">{{ $total }}</p>
        </div>
        <p class="text-sm text-center">Update terakhir pada : <span class="italic">{{ $date }}</span></p>
    </div>
</div>
