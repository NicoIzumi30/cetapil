@props(['label'])

<div class="grid grid-cols-2 items-center my-6">
	<p class="text-white">{{$label}}</p>
	<div class="w-1/2">
		<label for="av3m" class="form-label">AV3M</label>
		<input class="form-control" type="number" name="av3m" placeholder="Masukan Jumlah AV3M" {{$attributes}}
			aria-describedby="av3m" />
	</div>
</div>