function previewImage(input, id, maxImageSize) {
	const file = input.files[0];
	if (file) {
		const maxSize =  maxImageSize * 1024 * 1024;
		if (file.size > maxSize) {
			alert(`Ukuran file terlalu besar. Maksimal 2 MB`);
			input.value = '';
			return;
		}

		const reader = new FileReader();
		const uploadArea = document.getElementById(`upload-area-${id}`);
		const previewContainer = document.getElementById(`preview-container-${id}`);
		const previewImage = document.getElementById(`preview-image-${id}`);

		reader.onload = function(e) {
			previewImage.src = e.target.result;
			uploadArea.classList.add('hidden');
			previewContainer.classList.remove('hidden');
		}

		reader.readAsDataURL(file);
	}
}

function removeImage(id) {
	const input = document.getElementById(`img_${id}`);
	const uploadArea = document.getElementById(`upload-area-${id}`);
	const previewContainer = document.getElementById(`preview-container-${id}`);
	const previewImage = document.getElementById(`preview-image-${id}`);

	input.value = '';
	previewImage.src = '';
	uploadArea.classList.remove('hidden');
	previewContainer.classList.add('hidden');
}

// Make upload areas clickable
document.addEventListener('DOMContentLoaded', function() {
	const uploadAreas = document.querySelectorAll('[id^="upload-area-"]');
	uploadAreas.forEach(area => {
		const id = area.id.replace('upload-area-', '');
		area.addEventListener('click', function() {
			document.getElementById(`img_${id}`).click();
		});
	});
});