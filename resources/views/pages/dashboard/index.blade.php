@extends('layouts.main')

@section('banner-content')
    <div class="flex items-start justify-between mb-6 p-6">
		<div class="z-50">
			<h2 class="text-4xl text-white text-left font-[400]">Selamat Datang,</h2>
			<h1 class="text-5xl text-white my-6 text-left font-bold">{{ auth()->user()->name }}</h1>
			<div class="px-5 py-2 bg-primary rounded-3xl text-center w-fit text-white font-[600] italic text-xl">
				{{ ucwords(auth()->user()->getRoleNames()->first()) }}
			</div>
		</div>
		<div class="flex flex-col items-end z-50">
			<div class="bg-white flex items-center p-3 gap-5 rounded-md">
				<img class="w-10 h-auto" src="{{ asset('/assets/icons/material-symbols_date-range.svg') }}" alt="calendar">
				<div>
					<p class="text-lightGrey text-sm font-bold">Hari Ini</p>
					<p class="text-black text-sms font-bold">{{$tanggal}}</p>
				</div>
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
