@php

    $menus = [
        (object) [
            'icon' => 'fluent_home-12-filled.svg',
            'title' => 'Home',
            'path' => '/',
        ],
        (object) [
            'icon' => 'fluent_box-20-filled.svg',
            'title' => 'Product',
            'path' => '/product',
        ],
        (object) [
            'icon' => 'solar_routing-2-bold.svg',
            'title' => 'Routing',
            'path' => '/routing',
        ],
        (object) [
            'icon' => 'material-symbols_map-search-rounded.svg',
            'title' => 'Map',
            'path' => '/',
        ],
        (object) [
            'icon' => 'icon-shopping.svg',
            'title' => 'Shop',
            'path' => '/',
        ],
        (object) [
            'icon' => 'mdi_account-group.svg',
            'title' => 'People',
            'path' => '/',
        ],
        (object) [
            'icon' => 'mdi_account-cog.svg',
            'title' => 'User',
            'path' => '/profile',
        ],
    ];
@endphp


<aside class="z-50 border bg-sidebar h-screen sticky top-0 p-4">
    <div class="flex items-center gap-4 p-4">
        <img class="w-[100px]" src="{{ asset('/assets/images/logo.webp') }}" alt="logo">
        <h1 class="text-2xl font-bold text-white">Dashboard</h1>
    </div>
    <ul class="p-2 w-[264px] h-full rounded-md flex flex-col gap-4">
        @foreach ($menus as $menu)
            <li>
                <a href="{{ $menu->path }}">
                    <div class="icon-menu-container">
                        <img class="icon-menu" src="{{ asset("assets/icons/{$menu->icon}") }}"
                            alt="{{ $menu->title }}">
                    </div>
                </a>
            </li>
        @endforeach
        <li class="mt-16">
            <a href="/">
                <div class="icon-menu-container">
                    <img class="icon-menu" src="{{ asset('assets/icons/majesticons_door-exit.svg') }}" alt="logout">
                </div>
            </a>
        </li>
    </ul>
</aside>


<style>
    .bg-sidebar {
        background: linear-gradient(173.85deg, #003263 3.73%, #53A2D2 99.57%);
    }
</style>
