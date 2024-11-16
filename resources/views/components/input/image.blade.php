{{-- resources/views/components/image-upload.blade.php --}}
@props(['id', 'name' => 'image', 'label' => 'Upload Image', 'maxSize' => 2])

<div class="flex flex-col items-center w-fit">
    <div class="relative w-fit mx-3">
        <div class="flex justify-center items-center flex-col py-2">
            {{-- Upload Area --}}
            <div class="cursor-pointer text-center grid place-items-center border-2 border-dashed border-blue-400 rounded-lg p-4"
                id="upload-area-{{ $id }}">
                <svg width="30" height="63" viewBox="0 0 64 63" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path
                        d="M28 43.2577C28 45.4323 29.7909 47.1952 32 47.1952C34.2091 47.1952 36 45.4323 36 43.2577V15.074L48.971 27.8423L54.6279 22.2739L32.0005 0L9.37305 22.2739L15.0299 27.8423L28 15.0749V43.2577Z"
                        fill="#fff" />
                    <path
                        d="M0 39.375H8V55.125H56V39.375H64V55.125C64 59.4742 60.4183 63 56 63H8C3.58172 63 0 59.4742 0 55.125V39.375Z"
                        fill="#fff" />
                </svg>
                <h5 class="text-white font-medium mt-2">Klik disini untuk unggah foto</h5>
                <p class="text-white font-light text-sm">
                    Ukuran maksimal foto <strong>{{ $maxSize }}MB</strong>
                </p>
            </div>

            {{-- Preview Container --}}
            <div id="preview-container-{{ $id }}" class="hidden w-[250px] relative">
                <img id="preview-image-{{ $id }}" src="" alt="Preview"
                    class="w-full mx-auto rounded-lg" />
                <button type="button"
                    class="absolute bottom-2 right-2 bg-white p-2 rounded-full shadow-md hover:bg-gray-100 transition-colors"
                    onclick="removeImage('{{ $id }}')">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-red-500" viewBox="0 0 20 20"
                        fill="currentColor">
                        <path fill-rule="evenodd"
                            d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z"
                            clip-rule="evenodd" />
                    </svg>
                </button>
            </div>
        </div>

        {{-- Hidden File Input --}}
        <input type="file" name="{{ $name }}" id="img_{{ $id }}" class="hidden"
            accept="image/png, image/jpeg" onchange="previewImage(this, '{{ $id }}')">
    </div>

    {{-- Label --}}
    <label class="text-center mt-3 text-xs text-white cursor-pointer" for="img_{{ $id }}">
        {{ $label }}
    </label>
</div>
