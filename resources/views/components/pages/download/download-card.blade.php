@props(['cardTitle','cardFooter', 'iconName'])

	<div class="w-full rounded-lg bg-slate-500 p-6">
		<div class="flex gap-6 w-full items-center justify-center mb-6">
			<img src="{{ asset("/assets/icons/{$iconName}.svg") }}" class="w-[40px] h-[40px]" alt="{{$cardTitle}} icon">
			<h1 class="font-bold text-3xl text-white uppercase">
				{{ $cardTitle }}
			</h1>
		</div>
	
		<div>
			{{ $slot }}
		</div>
	
		@if(isset($cardFooter))
		<div class="w-full bg-transparent">
			{{ $cardFooter }}
		</div>
		@endif
	</div>
