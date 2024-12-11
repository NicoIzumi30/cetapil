@props(['id'])

<x-modal id="edit-produk-{{ $loop->index }}">
	<x-slot:title>
		Ubah Produk
	</x-slot:title>
	<form class="grid grid-cols-2 gap-6">
		<div>
			<label for="edit-categories" class="!text-black">Kategori Produk</label>
			<div>
				<select id="edit-categories" name="edit-category" class="edit-categories w-full">
					<option value="" selected disabled>
						-- Pilih Category Product --
					</option>
					<option value="cleanser">
						SunProtect
					</option>
				</select>
			</div>
		</div>
		<div>
			<label for="edit-sku" class="!text-black">Produk SKU</label>
			<input id="edit-sku" class="form-control @error('edit-sku') is-invalid @enderror"
				type="text" wire:model="edit-sku" name="edit-sku"
				placeholder="Masukan produk SKU" aria-describedby="edit-sku" value="">
			@error('edit-sku')
				<div class="invalid-feedback">
					{{ $message }}
				</div>
			@enderror
		</div>
		<div>
			<label for="edit-md-price" class="!text-black">Harga MD</label>
			<input id="edit-md-price" type="number" class="form-control" wire:model="edit-md-price"
				name="edit-md-price" placeholder="Masukan Harga MD"
				aria-describedby="edit-md-price" value="">
			@error('edit-md-price')
				<div class="invalid-feedback">
					{{ $message }}
				</div>
			@enderror
		</div>
		<div>
			<label for="edit-sales-price" class="!text-black">Harga Sales</label>
			<input id="edit-sales-price"
				class="form-control @error('edit-sales-price') is-invalid @enderror"
				type="number" wire:model="edit-sales-price" name="edit-sales-price"
				placeholder="Masukan Harga Sales" aria-describedby="edit-sales-price"
				value="">
			@error('edit-sales-price')
				<div class="invalid-feedback">
					{{ $message }}
				</div>
			@enderror
		</div>
	</form>
	<x-slot:footer>
		<div class="flex gap-4">
			<x-button.light class="w-full !text-white !bg-primary ">Simpan Perubahan</x-button.light>
		</div>
	</x-slot:footer>
</x-modal>

@once
<script>
	$(document).ready(function() {
		   $('.edit-categories{$id}').select();
	   });
</script>
@endonce