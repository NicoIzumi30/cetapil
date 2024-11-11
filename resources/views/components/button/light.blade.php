@props(['href'])

@if (isset($href))
    <a href="{{ $href }}" role="button" {{ $attributes->merge(['class' => 'bg-white mx-0 text-sm font-bold text-primary text-center rounded-md blue px-6 py-2 hover:bg-lightBlue']) }}>
        {{ $slot }}
    </a>
@else
    <button type="submit" {{ $attributes->merge(['class' => 'bg-white mx-0 text-sm font-bold text-primary text-center rounded-md blue px-6 py-2 hover:bg-lightBlue']) }}>
        {{ $slot }}
    </button>
@endif
