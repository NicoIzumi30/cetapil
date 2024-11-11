@extends('layouts.main')

@section('banner-content')
    <div class="flex items-start justify-between mb-6">
		<div class="z-50">
			<img class="w-[266px] h-auto" src="{{ asset('/assets/images/logo.webp') }}" alt="logo">
			<h1 class="text-[4rem] mt-10 font-semibold text-[#0177BE]">Dashboard</h1>
		</div>
		<div class="flex flex-col items-end z-50">
			<div class="bg-white flex items-center p-3 gap-5 rounded-md">
				<img class="w-10 h-auto" src="{{ asset('/assets/icons/material-symbols_date-range.svg') }}" alt="calendar">
				<div>
					<p class="text-lightGrey text-sm font-bold">Hari Ini</p>
					<p class="text-black text-sms font-bold">Senin, 10 November 2024</p>
				</div>
			</div>
			<h2 class="text-4xl text-white mt-6 text-right font-[400]">Selamat Datang,</h2>
			<h1 class="text-5xl text-white mb-6 text-right font-extrabold">Andromeda Phytagoras Silalahi</h1>
			<div class="px-5 py-2 bg-primary rounded-3xl text-center w-fit text-white font-[600] italic text-xl">
				Superadmin
			</div>
		</div>
	</div>
@endsection

@section('dashboard-content')
    <main class="w-full">
		<div class="flex w-full gap-5">
			<x-pages.dashboard.total-card :title="'Total Report'" :total="7.432"/>
			<x-pages.dashboard.total-card :title="'Total Sales'" :total="7.432"/>
			<x-pages.dashboard.total-card :title="'Total Routing'" :total="7.432"/>
			<x-pages.dashboard.total-card :title="'Total Visibility'" :total="7.432"/>
		</div>
		<div>
		</div>
	</main>
@endsection
