@props(['href'])

@if (isset($href))
    <a href="{{ $href }}" role="button" {{ $attributes->merge(['class' => 'button-info-bg text-sm font-bold text-white text-center rounded-md blue px-6 py-2 hover:bg-lightBlue']) }}>
        {{ $slot }}
    </a>
@else
    <button type="submit" {{ $attributes->merge(['class' => 'button-info-bg text-sm font-bold text-white text-center rounded-md blue px-6 py-2 transition-all duration-200 ease-in-out']) }}>
        {{ $slot }}
    </button>
@endif

<style>
    .button-info-bg {
        background: linear-gradient(135deg, #53A2D2 0%, #0077BD 100%);
    }
    .button-info-bg:hover {
        background: #277bb0;
    }
</style>
