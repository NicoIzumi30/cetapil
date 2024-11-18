@props(['cardTitle', 'cardAction', 'cardFooter', 'cardGroup'])

<div class="card mt-4 mx-4 rounded-lg  min-w-[1180px]">
    <x-card-header>
        <x-slot:cardTitle>
            {{ $cardTitle }}
        </x-slot:cardTitle>
        <x-slot:cardAction>
            {{ $cardAction ?? "" }}
        </x-slot:cardAction>
    </x-card-header>

    <x-card-body>
        {{ $slot }}
    </x-card-body>

    @if(isset($cardGroup))
        {{ $cardGroup }}
    @endif

    @if(isset($cardFooter))
    <div class="card-footer bg-transparent">
        {{ $cardFooter }}
    </div>
    @endif
</div>


<style>
	.card {
		background: linear-gradient(167.42deg, rgba(0, 119, 182, 0.65) 6.37%, rgba(72, 202, 228, 0.15) 74.4%);
	}
</style>
