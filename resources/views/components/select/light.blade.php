@props(['title'])
<div>
    <select class="bg-white select-custom text-sm font-bold outline-none text-primary text-center border-r-8 border-transparent rounded-md blue px-6 py-2 hover:bg-lightBlue" {{$attributes}}>
		<option value="" selected disabled>{{$title}}</option>
			{{$slot}}
    </select>
</div>

