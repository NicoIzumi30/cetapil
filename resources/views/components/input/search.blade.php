<div >
    <div class="bg-white bg-opacity-[44%] flex items-center gap-2 px-4 rounded-lg rounded-2 border border-primary w-full">
        <span class="input-group-text bg-transparent border-0" id="inputGroup-sizing-sm">
            <svg width="17" height="17" viewBox="0 0 17 17" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path fill-rule="evenodd" clip-rule="evenodd" d="M12.8799 11.6102C15.078 8.78716 14.8795 4.70285 12.2843 2.10765C9.47407 -0.702549 4.91784 -0.702549 2.10765 2.10765C-0.702549 4.91784 -0.702549 9.47407 2.10765 12.2843C4.70285 14.8795 8.78716 15.078 11.6102 12.8799C11.6224 12.8937 11.6351 12.9071 11.6482 12.9203L15.4645 16.7365C15.8157 17.0878 16.3853 17.0878 16.7365 16.7365C17.0878 16.3853 17.0878 15.8157 16.7365 15.4645L12.9203 11.6482C12.9071 11.6351 12.8937 11.6224 12.8799 11.6102ZM11.0122 3.37973C13.1198 5.48737 13.1198 8.90455 11.0122 11.0122C8.90455 13.1198 5.48737 13.1198 3.37973 11.0122C1.27208 8.90455 1.27208 5.48737 3.37973 3.37973C5.48737 1.27208 8.90455 1.27208 11.0122 3.37973Z" fill="url(#paint0_linear_201_6594)"/>
                <defs>
                    <linearGradient id="paint0_linear_201_6594" x1="3.28666" y1="14.0533" x2="15.4091" y2="8.49998" gradientUnits="userSpaceOnUse">
                        <stop stop-color="#fff"/>
                        <stop offset="1" stop-color="#fff"/>
                    </linearGradient>
                </defs>
            </svg>
        </span>
        <input type="text" {{ $attributes->merge(['class' => 'text-sm text-white bg-transparent py-2 outline-none placeholder-white']) }} aria-label="Sizing example input" aria-describedby="inputGroup-sizing-sm" {{$attributes}}>
    </div>
</div>
