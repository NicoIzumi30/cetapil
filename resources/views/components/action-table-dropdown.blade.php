@props(['item', 'button'])

<div class="dropdown-center">
    @if (isset($button))
        {{ $button }}
    @else
        <button class="dropdown-button text-white" type="button">
            <span class="text-center">
                <svg width="24" height="24" viewBox="0 0 47 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path
                        d="M24 34.5957C22.3431 34.5957 21 33.1946 21 31.4663C21 29.738 22.3431 28.3369 24 28.3369C25.6569 28.3369 27 29.738 27 31.4663C27 33.1946 25.6569 34.5957 24 34.5957ZM24 25.2075C22.3431 25.2075 21 23.8065 21 22.0782C21 20.3499 22.3431 18.9488 24 18.9488C25.6569 18.9488 27 20.3499 27 22.0782C27 22.9081 26.6839 23.7041 26.1213 24.291C25.5587 24.8778 24.7956 25.2075 24 25.2075ZM24 15.8194C22.3431 15.8194 21 14.4183 21 12.69C21 10.9617 22.3431 9.56065 24 9.56065C25.6569 9.56065 27 10.9617 27 12.69C27 13.52 26.6839 14.316 26.1213 14.9028C25.5587 15.4897 24.7956 15.8194 24 15.8194Z"
                        fill="#fff" />
                </svg>
            </span>
        </button>
    @endif
    <div class="dropdown-menu hidden shadow-lg">
        <div 
            class="z-10 bg-white divide-y absolute rounded-[4px] shadow w-44 dropdown-options-container">
            <ul class="py-2 text-sm text-gray-700 " aria-labelledby="dropdown-button">
				{{ $slot }}
            </ul>
        </div>
    </div>
</div>
