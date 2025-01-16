@php
$menus[] =  (object) [
            'icon' => 'fluent_home_12_filled.svg',
            'title' => 'Beranda',
            'path' => '/',
        ];
    if(auth()->user()->hasPermissionTo('menu_product')) {
        $menus[] = (object) [
            'icon' => 'fluent_box_20_filled.svg',
            'title' => 'Product',
            'path' => '/products',
        ];
    }
    if(auth()->user()->hasPermissionTo('menu_routing')) {
        $menus[] = (object) [
            'icon' => 'solar_routing_2_bold.svg',
            'title' => 'Routing',
            'path' => '/routing',
        ];
    }
    if(auth()->user()->hasPermissionTo('menu_visibility')) {
        $menus[] = (object) [
            'icon' => 'material-symbols_map_search_rounded.svg',
            'title' => 'Visibility',
            'path' => '/visibility',
        ];
    }
    if(auth()->user()->hasPermissionTo('menu_selling')) {
        $menus[] = (object) [
            'icon' => 'mdi_selling.svg',
            'title' => 'Penjualan',
            'path' => '/selling',
        ];
    }
    if(auth()->user()->hasPermissionTo('menu_selling')) {
        $menus[] = (object) [
            'icon' => 'fluent_clipboard.svg',
            'title' => 'Survey',
            'path' => '/survey',
        ];
    }
    if(auth()->user()->hasPermissionTo('menu_selling')) {
        $menus[] = (object) [
            'icon' => 'line-md_download.svg',
            'title' => 'Download',
            'path' => '/download',
        ];
    }
    if(auth()->user()->hasPermissionTo('menu_user')) {
        $menus[] = (object) [
            'icon' => 'mdi_account_group.svg',
            'title' => 'Pengguna',
            'path' => '/users',
        ];
    }
    $menus[] = 
        (object) [
            'icon' => 'mdi_account_cog.svg',
            'title' => 'Manajemen Akun',
            'path' => '/profile',
        ];
    
@endphp

<aside id="sidebar"
    class="z-[45] bg-sidebar h-[100%] fixed top-0 p-6 w-20 hover:w-80 group transition-all duration-100 ease-in-out ">
    <div class="flex items-center gap-4 w-[40px] h-[40px]">
        <img src="{{ asset('/assets/images/logo.webp') }}" alt="logo">
        <h1 class="text-2xl font-bold text-white group-hover:block  hidden">Dashboard</h1>
    </div>
    <hr class="sidebar-border my-6" />
    <ul class="w-20 group-hover:w-[17rem] h-full rounded-md flex flex-col gap-4">
        @foreach ($menus as $menu)
            <li>

                <a href="{{ $menu->path }}"
                    class="flex items-center h-[40px] gap-6 text-lightBlue rounded-md hover:bg-primary hover:bg-opacity-15">
                    <div class="icon-menu-container">
                        <img class="icon-menu" src="{{ asset("assets/icons/{$menu->icon}") }}"
                            alt="{{ $menu->title }}">
                    </div>
                    <p class="group-hover:block hidden">{{ $menu->title }}</p>
                </a>
            </li>
        @endforeach
        <div  class="absolute bottom-6 left-6 right-6 w-[70px] group-hover:w-[264px]">
            <a href="/logout" class="flex items-center h-[50px] gap-6 text-lightBlue rounded-md hover:bg-primary hover:bg-opacity-15\">
                <div class="icon-menu-container">
                    <img class="!max-w-[30px] h-[30px]" src="{{ asset('assets/icons/majesticons_door_exit.svg') }}" alt="logout">
                </div>
                <p class="group-hover:block hidden">Log Out</p>
            </a>
        </div>
    </ul>
</aside>
