@props(['title', 'total'])

<style>
    .card-header-bg {
        background: linear-gradient(135deg, #53A2D2 0%, #0077BD 100%);
    }
</style>

<div class="bg-white rounded-xl shadow-sm w-full overflow-hidden">
    <div class="card-header-bg py-2 px-4">
        <h2 class="text-lightBlue text-xl text-center font-medium">{{ $title }}</h2>
    </div>
    <div class="p-4">
        <p class="text-4xl font-bold text-center my-4">{{ $total }}</p>
		<p class="text-[11px] text-center">Update terakhir pada : {{ $total }}</p>
    </div>
</div>


