<div>
	<label for="knowledge_file" class="!text-black">
		Unggah product knowledge berupa file pdf
		<div id="fileUpload" class="flex mt-2">
			<input type="text" readonly disabled class="form-control mt-0 border-r-none"
				{{-- if ($knowledge_file) value="{{ pathinfo($knowledge_file->getClientOriginalName(), PATHINFO_FILENAME) . '.pdf' }}" @endif --}} placeholder="Unggah product knowledge berupa file pdf"
				aria-describedby="button-addon2">
			<div
				class="bg-primary text-white align-middle p-3 rounded-r-md cursor-pointer -translate-x-2">
				Browse</div>
		</div>
		<input type="file" id="knowledge_file" name="knowledge_file" class="form-control hidden"
			accept="application/pdf" aria-label="Unggah product knowledge berupa file pdf">
	</label>
</div>