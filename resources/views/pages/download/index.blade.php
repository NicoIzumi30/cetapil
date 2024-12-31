@extends('layouts.main')

@section('banner-content')
<x-banner-content :title="'Download'" />
@endsection

@section('dashboard-content')
{{-- Download --}}
<x-card>
    <x-slot:cardTitle>
		Download 
    </x-slot:cardTitle>
    {{-- Download Action --}}
    <x-slot:cardAction>
    </x-slot:cardAction>
    {{-- Download Action End --}}

</x-card>

@endsection
