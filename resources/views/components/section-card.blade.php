@props(['title'])

<div>
    <div class="mt-1">
        <h3 class="font-bold text-2xl text-white border-b-2 border-dashed py-10 mb-10">
            {{ $title }}
        </h3>
    </div>

    <div>
		{{$slot}}
    </div>
</div>
