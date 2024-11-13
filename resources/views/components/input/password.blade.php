@props(['title'])

@php
    $inputId = 'password-' . $title;
    $toggleId = 'toggle-' . $title;
    $eyeOpenId = 'eye-outline-' . $title;
    $eyeClosedId = 'eye-off-outline-' . $title;
@endphp 

<div class="mb-4">
    <label for="{{ $inputId }}" class="form-label !text-black">{{ $title }}</label>
    <div class="flex items-center gap-4">
        <input 
            id="{{ $inputId }}"  
            class="form-control" 
            type="password" 
            name="{{$title}}" 
            aria-describedby="password"
            {{ $attributes }} 
        />
        <button id="{{ $toggleId }}" type="button" class="mr-3">
            <i id="{{ $eyeOpenId }}" class="hidden">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M17.701 18.903C15.9419 20.0187 13.9011 20.6095 11.818 20.606C6.426 20.606 1.94 16.726 1 11.606C1.43092 9.27777 2.60158 7.15072 4.338 5.541L1.212 2.414L2.626 1L22.425 20.798L21.011 22.213L17.701 18.903ZM5.754 6.956C4.39489 8.19166 3.44789 9.81478 3.041 11.606C3.35329 12.9725 3.98026 14.2471 4.872 15.3286C5.76374 16.41 6.89563 17.2684 8.17755 17.8353C9.45948 18.4022 10.856 18.6621 12.2561 18.5941C13.6561 18.5262 15.021 18.1324 16.242 17.444L14.214 15.416C13.3507 15.9598 12.3282 16.1941 11.3142 16.0804C10.3003 15.9668 9.35504 15.5119 8.63357 14.7904C7.9121 14.069 7.45723 13.1237 7.34356 12.1098C7.2299 11.0958 7.46418 10.0733 8.008 9.21L5.754 6.956ZM12.732 13.934L9.49 10.693C9.31206 11.1459 9.27019 11.641 9.3695 12.1173C9.46882 12.5937 9.70502 13.0308 10.0491 13.3749C10.3932 13.719 10.8303 13.9552 11.3067 14.0545C11.783 14.1538 12.2791 14.1119 12.732 13.934ZM20.624 16.199L19.193 14.768C19.863 13.8159 20.3396 12.7416 20.596 11.606C20.3242 10.4156 19.8132 9.29293 19.0941 8.3062C18.3749 7.31946 17.4625 6.48929 16.4125 5.86616C15.3625 5.24302 14.1967 4.83994 12.986 4.68141C11.7753 4.52288 10.5451 4.61222 9.37 4.944L7.792 3.366C9.039 2.876 10.398 2.606 11.818 2.606C17.21 2.606 21.696 6.486 22.637 11.606C22.3306 13.272 21.6409 14.8442 20.624 16.199ZM11.541 7.115C11.6323 7.109 11.7247 7.106 11.818 7.106C12.4324 7.10592 13.0403 7.23166 13.6043 7.47547C14.1683 7.71929 14.6763 8.07601 15.0972 8.52366C15.518 8.9713 15.8428 9.50039 16.0513 10.0783C16.2599 10.6562 16.348 11.2708 16.31 11.884L11.541 7.115Z" fill="#53A2D2"/>
                </svg>
            </i>
            <i id="{{ $eyeClosedId }}">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path fill-rule="evenodd" clip-rule="evenodd" d="M15.7859 12C15.7859 14.2091 14.0909 16 12 16C9.90908 16 8.21406 14.2091 8.21406 12C8.21406 9.79086 9.90908 8 12 8C14.0909 8 15.7859 9.79086 15.7859 12ZM13.893 12C13.893 13.1046 13.0455 14 12 14C10.9545 14 10.107 13.1046 10.107 12C10.107 10.8954 10.9545 10 12 10C13.0455 10 13.893 10.8954 13.893 12Z" fill="#53A2D2"/>
                    <path fill-rule="evenodd" clip-rule="evenodd" d="M12 3C17.2923 3 21.7392 6.82432 23 12C21.7392 17.1757 17.2923 21 12 21C6.70771 21 2.26084 17.1757 1 12C2.26084 6.82432 6.70771 3 12 3ZM12 19C7.76394 19 4.17382 16.0581 2.96791 12C4.17382 7.94186 7.76394 5 12 5C16.2361 5 19.8262 7.94186 21.0321 12C19.8262 16.0581 16.2361 19 12 19Z" fill="#53A2D2"/>
                </svg>
            </i>
        </button>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const togglePasswordButton = document.getElementById('{{ $toggleId }}');
        const eyeOpenIcon = document.getElementById('{{ $eyeOpenId }}');
        const eyeClosedIcon = document.getElementById('{{ $eyeClosedId }}');
        const inputPassword = document.getElementById('{{ $inputId }}');

        if (togglePasswordButton && eyeOpenIcon && eyeClosedIcon && inputPassword) {
            togglePasswordButton.addEventListener('click', () => {
                inputPassword.type = inputPassword.type === 'password' ? 'text' : 'password';
                eyeOpenIcon.style.display = inputPassword.type === 'password' ? 'none' : 'block';
                eyeClosedIcon.style.display = inputPassword.type === 'password' ? 'block' : 'none';
            });
        }
    });
</script>