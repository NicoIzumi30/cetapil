<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/simple-notify@1.0.4/dist/simple-notify.css" />

</head>

<body class="bg-login">

    <div class="login-layout">
        <img class="bg-accent" src="{{ asset('/assets/images/rounded-bg-accent.svg') }}" alt="">
        <div class="bottom-gradient hidden md:block"></div>
        {{-- Hero Container --}}
        <div class="hero-container">
            <div class="bottom-gradient block md:hidden"></div>
            <img class="desktop-logo" src="{{ asset('/assets/images/desktop-login-logo.webp') }}" alt="desktop-logo">
            <img class="mobile-logo" src="{{ asset('/assets/images/logo.webp') }}" alt="mobile-logo">
            <img class="hero-image" src="{{ asset('/assets/images/women-with-cetaphil-desktop.webp') }}"
                alt="women with cetaphil products">

            <div class="hero-content">
                <h1 class="hero-title">Optimalisasi Bisnis dengan Efisiensi
                    Terintegrasi</h1>
                <p class="hero-description">Sistem Point of Sales yang menyeluruh untuk mendukung strategi operasional
                    yang efektif dan terukur</p>
            </div>
        </div>
        {{-- Hero Container End --}}
        {{-- Form Container --}}
        <div class="form-container">
            <h3 class="form-title">
                Selamat Datang di <span class="text-primary">Dashboard!</span>
            </h3>
            <p class="form-description">Silahkan Masukkan <span>Email</span>dan <span>Kata Sandi</span> untuk
                melanjutkan</p>
            <form class="login-form" action="{{ route('login') }}" method="POST">
                @csrf
                <div class="input">
                    <div class="login-input-container">
                        <svg width="41" height="41" viewBox="0 0 41 41" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M8.39079 35.3999V32.0666C8.39079 30.2985 9.09317 28.6028 10.3434 27.3525C11.5937 26.1023 13.2893 25.3999 15.0575 25.3999H25.0575C26.8256 25.3999 28.5213 26.1023 29.7715 27.3525C31.0217 28.6028 31.7241 30.2985 31.7241 32.0666V35.3999"
                                stroke="#054F7B" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" />
                            <path
                                d="M20.0575 18.7332C16.3756 18.7332 13.3908 15.7485 13.3908 12.0666C13.3908 8.38467 16.3756 5.3999 20.0575 5.3999C23.7394 5.3999 26.7241 8.38467 26.7241 12.0666C26.7241 15.7485 23.7394 18.7332 20.0575 18.7332Z"
                                stroke="#054F7B" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" />
                        </svg>
                        <input class="outline-none" name="email" id="email" required type="email" placeholder="Masukkan Email" />
                    </div>
                </div>
                <div class="input">
                    <div class="login-input-container">
                        <svg width="41" height="41" viewBox="0 0 41 41" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M20.0578 28.7333C20.9418 28.7333 21.7897 28.3821 22.4148 27.757C23.0399 27.1319 23.3911 26.284 23.3911 25.4C23.3911 23.55 21.9078 22.0667 20.0578 22.0667C19.1737 22.0667 18.3259 22.4178 17.7008 23.043C17.0756 23.6681 16.7244 24.5159 16.7244 25.4C16.7244 26.284 17.0756 27.1319 17.7008 27.757C18.3259 28.3821 19.1737 28.7333 20.0578 28.7333ZM10.0578 33.7333V17.0667H30.0578V33.7333H10.0578ZM10.0578 13.7333C9.17373 13.7333 8.32588 14.0845 7.70076 14.7096C7.07564 15.3347 6.72445 16.1826 6.72445 17.0667V33.7333C6.72445 34.6174 7.07564 35.4652 7.70076 36.0903C8.32588 36.7155 9.17373 37.0667 10.0578 37.0667H30.0578C30.9418 37.0667 31.7897 36.7155 32.4148 36.0903C33.0399 35.4652 33.3911 34.6174 33.3911 33.7333V17.0667C33.3911 15.2167 31.9078 13.7333 30.0578 13.7333H28.3911V10.4C28.3911 8.18985 27.5131 6.07023 25.9503 4.50743C24.3875 2.94462 22.2679 2.06665 20.0578 2.06665C18.9634 2.06665 17.8798 2.2822 16.8688 2.70099C15.8577 3.11978 14.939 3.73361 14.1652 4.50743C13.3914 5.28125 12.7776 6.19991 12.3588 7.21095C11.94 8.222 11.7244 9.30563 11.7244 10.4V13.7333H10.0578ZM20.0578 5.39998C21.3839 5.39998 22.6556 5.92677 23.5933 6.86445C24.531 7.80213 25.0578 9.0739 25.0578 10.4V13.7333H15.0578V10.4C15.0578 9.0739 15.5846 7.80213 16.5222 6.86445C17.4599 5.92677 18.7317 5.39998 20.0578 5.39998Z"
                                fill="#054F7B" />
                        </svg>
                        <input id="password" class="outline-none" required type="password" name="password"
                            placeholder="Masukkan Kata Sandi" />
                        <button id="toggle-password" class="mr-3" type="button">
                            <div id="eye-outline" class="hidden">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <path
                                        d="M17.701 18.903C15.9419 20.0187 13.9011 20.6095 11.818 20.606C6.426 20.606 1.94 16.726 1 11.606C1.43092 9.27777 2.60158 7.15072 4.338 5.541L1.212 2.414L2.626 1L22.425 20.798L21.011 22.213L17.701 18.903ZM5.754 6.956C4.39489 8.19166 3.44789 9.81478 3.041 11.606C3.35329 12.9725 3.98026 14.2471 4.872 15.3286C5.76374 16.41 6.89563 17.2684 8.17755 17.8353C9.45948 18.4022 10.856 18.6621 12.2561 18.5941C13.6561 18.5262 15.021 18.1324 16.242 17.444L14.214 15.416C13.3507 15.9598 12.3282 16.1941 11.3142 16.0804C10.3003 15.9668 9.35504 15.5119 8.63357 14.7904C7.9121 14.069 7.45723 13.1237 7.34356 12.1098C7.2299 11.0958 7.46418 10.0733 8.008 9.21L5.754 6.956ZM12.732 13.934L9.49 10.693C9.31206 11.1459 9.27019 11.641 9.3695 12.1173C9.46882 12.5937 9.70502 13.0308 10.0491 13.3749C10.3932 13.719 10.8303 13.9552 11.3067 14.0545C11.783 14.1538 12.2791 14.1119 12.732 13.934ZM20.624 16.199L19.193 14.768C19.863 13.8159 20.3396 12.7416 20.596 11.606C20.3242 10.4156 19.8132 9.29293 19.0941 8.3062C18.3749 7.31946 17.4625 6.48929 16.4125 5.86616C15.3625 5.24302 14.1967 4.83994 12.986 4.68141C11.7753 4.52288 10.5451 4.61222 9.37 4.944L7.792 3.366C9.039 2.876 10.398 2.606 11.818 2.606C17.21 2.606 21.696 6.486 22.637 11.606C22.3306 13.272 21.6409 14.8442 20.624 16.199ZM11.541 7.115C11.6323 7.109 11.7247 7.106 11.818 7.106C12.4324 7.10592 13.0403 7.23166 13.6043 7.47547C14.1683 7.71929 14.6763 8.07601 15.0972 8.52366C15.518 8.9713 15.8428 9.50039 16.0513 10.0783C16.2599 10.6562 16.348 11.2708 16.31 11.884L11.541 7.115Z"
                                        fill="#53A2D2" />
                                </svg>
                            </div>
                            <div id="eye-off-outline">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <path fill-rule="evenodd" clip-rule="evenodd"
                                        d="M15.7859 12C15.7859 14.2091 14.0909 16 12 16C9.90908 16 8.21406 14.2091 8.21406 12C8.21406 9.79086 9.90908 8 12 8C14.0909 8 15.7859 9.79086 15.7859 12ZM13.893 12C13.893 13.1046 13.0455 14 12 14C10.9545 14 10.107 13.1046 10.107 12C10.107 10.8954 10.9545 10 12 10C13.0455 10 13.893 10.8954 13.893 12Z"
                                        fill="#53A2D2" />
                                    <path fill-rule="evenodd" clip-rule="evenodd"
                                        d="M12 3C17.2923 3 21.7392 6.82432 23 12C21.7392 17.1757 17.2923 21 12 21C6.70771 21 2.26084 17.1757 1 12C2.26084 6.82432 6.70771 3 12 3ZM12 19C7.76394 19 4.17382 16.0581 2.96791 12C4.17382 7.94186 7.76394 5 12 5C16.2361 5 19.8262 7.94186 21.0321 12C19.8262 16.0581 16.2361 19 12 19Z"
                                        fill="#53A2D2" />
                                </svg>
                            </div>
                        </button>
                    </div>
                </div>
                <button type="submit" class="login-button">Masuk</button>
            </form>
        </div>
        {{-- Form Container End --}}
    </div>
</body>
<script src="https://cdn.jsdelivr.net/npm/simple-notify@1.0.4/dist/simple-notify.min.js"></script>

<script>
     @if(session('success'))
            new Notify({
                status: 'success',
                title: 'Success',
                text: '{{ session('success') }}',
                effect: 'fade',
                speed: 300,
                customClass: '',
                customIcon: '',
                showIcon: true,
                showCloseButton: true,
                autoclose: true,
                autotimeout: 3000,
                notificationsGap: null,
                notificationsPadding: null,
                type: 'outline',
                position: 'right top',
                customWrapper: '',
            })
        @endif

        @if($errors->any())
        new Notify({
            status: 'error',
            title: 'Failed',
            text: 'Email atau password salah',
            effect: 'fade',
            speed: 300,
            customClass: '',
            customIcon: '',
            showIcon: true,
            showCloseButton: true,
            autoclose: true,
            autotimeout: 3000,
            notificationsGap: null,
            notificationsPadding: null,
            type: 'outline',
            position: 'right top',
            customWrapper: '',
        })
        @endif
    const inputPassword = document.getElementById('password');
    const togglePasswordButton = document.getElementById('toggle-password');
    const eyeOpenIcon = document.getElementById('eye-outline');
    const eyeClosedIcon = document.getElementById('eye-off-outline');

    togglePasswordButton.addEventListener('click', (e) => {
        e.preventDefault();
        inputPassword.type = inputPassword.type === 'password' ? 'text' : 'password';
        eyeOpenIcon.style.display = inputPassword.type === 'password' ? 'none' : 'block';
        eyeClosedIcon.style.display = inputPassword.type === 'password' ? 'block' : 'none';
    });
</script>

</html>