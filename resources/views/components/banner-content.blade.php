@props(['title'])

<div class="flex justify-between flex-col md:flex-row items-start gap-2 md:items-center w-full px-4 md:mb-10 mb-6">
	<div class="z-[40] flex items-center gap-6">
		<h1 class="text-[3rem] font-bold text-white">{{$title}}</h1>
	</div>
	<div class="flex flex-col items-end z-[10]">
		<div class="bg-white flex items-center p-3 gap-5 rounded-md">
			<img class="w-10 h-auto" src="{{ asset('/assets/icons/material-symbols_date-range.svg') }}" alt="calendar">
			<div>
				<p class="text-lightGrey text-sm font-bold">Hari Ini</p>
				<p class="text-black text-sms font-bold">{{formatTanggalIndonesia()}}</p> 
			</div>
		</div>
	</div>
</div>