@props(['cardTitle', 'cardAction'])

<div
    {{ $attributes->merge(['class' => 'flex justify-between items-center']) }}>
	<div class="w-full p-6  flex justify-between items-center card-header rounded-t-lg">
        <h2 class=" text-white text-2xl font-bold">{{$cardTitle}}</h2>
		<div class="flex items-start gap-2 justify-content-end self-end justify-self-end place-self-end">
			{{ $cardAction ?? '' }}
		</div>
	</div>
</div>

