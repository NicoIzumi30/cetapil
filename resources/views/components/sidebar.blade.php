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
    class="z-[45] bg-sidebar h-[100%] fixed top-0 p-4 w-20 hover:w-80 group transition-all duration-200 ease-in-out">
    <div class="flex items-center gap-4 ">
        <img class="w-[50px]" src="{{ asset('/assets/images/logo.webp') }}" alt="logo">
        <h1 class="text-2xl font-bold text-white group-hover:block  hidden">Dashboard</h1>
    </div>
    <hr class="sidebar-border my-6" />
    <ul class="p-2 w-[70px] group-hover:w-[264px] h-full rounded-md flex flex-col gap-4">
        @foreach ($menus as $menu)
            <li>
                <a href="{{ $menu->path}}"
                    class="flex items-center gap-6 text-lightBlue rounded-md hover:bg-primary hover:bg-opacity-15">
                    <div class="icon-menu-container">
                        <img class="icon-menu" src="{{ asset("assets/icons/{$menu->icon}") }}"
                            alt="{{ $menu->title }}">
                    </div>
                    <p class="group-hover:block hidden">{{ $menu->title }}</p>
                </a>
            </li>
        @endforeach
        <li>
            <div class="absolute bottom-6 left-6 right-6">
                <div
                    class="bg-white relative overflow-hidden rounded-md p-4 mb-4 scale-x-0 opacity-0 group-hover:opacity-100 group-hover:scale-x-100 w-[270px] origin-left transition-all ">
                    <div class="z-50 w-full flex flex-col">
                        <i><svg width="36" height="35" viewBox="0 0 36 35" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <rect x="0.5" width="35" height="35" rx="12" fill="white" />
                                <path
                                    d="M18 8.5C13.0312 8.5 9 12.5312 9 17.5C9 22.4687 13.0312 26.5 18 26.5C22.9687 26.5 27 22.4687 27 17.5C27 12.5312 22.9687 8.5 18 8.5ZM17.7187 22.75C17.5333 22.75 17.3521 22.695 17.1979 22.592C17.0437 22.489 16.9236 22.3426 16.8526 22.1713C16.7817 22 16.7631 21.8115 16.7993 21.6296C16.8354 21.4477 16.9247 21.2807 17.0558 21.1496C17.1869 21.0185 17.354 20.9292 17.5359 20.893C17.7177 20.8568 17.9062 20.8754 18.0775 20.9464C18.2488 21.0173 18.3952 21.1375 18.4983 21.2916C18.6013 21.4458 18.6562 21.6271 18.6562 21.8125C18.6562 22.0611 18.5575 22.2996 18.3817 22.4754C18.2058 22.6512 17.9674 22.75 17.7187 22.75ZM19.2862 17.9687C18.5264 18.4787 18.4219 18.9461 18.4219 19.375C18.4219 19.549 18.3527 19.716 18.2297 19.839C18.1066 19.9621 17.9397 20.0312 17.7656 20.0312C17.5916 20.0312 17.4247 19.9621 17.3016 19.839C17.1785 19.716 17.1094 19.549 17.1094 19.375C17.1094 18.348 17.5819 17.5314 18.5541 16.8784C19.4578 16.2719 19.9687 15.8875 19.9687 15.0423C19.9687 14.4677 19.6406 14.0312 18.9614 13.7083C18.8016 13.6323 18.4458 13.5583 18.008 13.5634C17.4586 13.5705 17.032 13.7017 16.7034 13.9661C16.0837 14.4648 16.0312 15.0077 16.0312 15.0156C16.0271 15.1018 16.006 15.1863 15.9692 15.2644C15.9324 15.3424 15.8805 15.4124 15.8167 15.4704C15.7528 15.5284 15.6781 15.5732 15.5969 15.6024C15.5157 15.6315 15.4295 15.6444 15.3434 15.6402C15.2572 15.6361 15.1727 15.615 15.0946 15.5782C15.0166 15.5414 14.9466 15.4895 14.8886 15.4256C14.8306 15.3618 14.7857 15.2871 14.7566 15.2059C14.7275 15.1247 14.7146 15.0385 14.7187 14.9523C14.7239 14.8384 14.8031 13.8123 15.8798 12.9461C16.4381 12.497 17.1483 12.2636 17.9892 12.2533C18.5845 12.2462 19.1437 12.347 19.523 12.5261C20.6578 13.0628 21.2812 13.9577 21.2812 15.0423C21.2812 16.6281 20.2214 17.3402 19.2862 17.9687Z"
                                    fill="#0075FF" />
                            </svg></i>
                        <h3 class="font-bold text-xl">Perlu Bantuan?</h3>
                        <p class="text-[12px] mb-3">Hubungi Service Center Dibawah</p>
                        <a href="/"
                            class="text-[12px] bg-[#3A416F] py-2 px-4 w-full rounded-md z-50 text-white font-semibold">Hubungi</a>
                    </div>
                    <img class="absolute z-0 bottom-0 opacity-65 right-0" src="{{ asset('assets/images/water.webp') }}"
                        alt="water-accent-bg">
                </div>
                <a href="/logout"
                    class="flex items-center gap-6 text-lightBlue rounded-md hover:bg-primary hover:bg-opacity-15">
                    <div class="icon-menu-container">
                        <img class="icon-menu" src="{{ asset('assets/icons/majesticons_door_exit.svg') }}"
                            alt="logout">
                    </div>
                    <p class="group-hover:block hidden">Log Out</p>
                </a>
            </div>
        </li>
    </ul>
</aside>
