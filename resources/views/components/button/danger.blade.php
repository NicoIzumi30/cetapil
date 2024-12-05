@props(['href'])

@if (isset($href))
    <a href="{{ $href }}" role="button" {{ $attributes->merge(['class' => 'button-danger-bg text-sm font-bold text-white text-center rounded-md px-6 py-2 hover:bg-lightRed']) }}>
        {{ $slot }}
    </a>
@else
    <button type="submit" {{ $attributes->merge(['class' => 'button-danger-bg text-sm font-bold text-white text-center rounded-md px-6 py-2 transition-all duration-200 ease-in-out']) }}>
        {{ $slot }}
    </button>
@endif

<style>
    .button-danger-bg {
        background: linear-gradient(135deg, #FF6B6B 0%, #DC3545 100%);
    }
    .button-danger-bg:hover {
        background: linear-gradient(135deg, #FF6B6B 100%, #DC3545 100%);
    }
</style>