
<div class="flex items-center gap-4">
	<label for="checkbox-switch" class="font-bold text-lg ">{{ $slot }}</label>
    <input 
        type="checkbox"
		id="checkbox-switch"
		class="custom-checkbox-input"
        {{ $attributes}}
    >
</div>

<style>
.custom-checkbox-input {
    appearance: none;
    width: 100px;
    height: 40px;
    background: #f0f9ff;
    border: 1px solid #0077BD;
    border-radius: 8px;
    position: relative;
    cursor: pointer;
}

.custom-checkbox-input:checked::before {
    left: calc(100px - 38px); 
    top: 3px;
	background: #f0f9ff;;
}

.custom-checkbox-input::before {
    content: '';
    position: absolute;
    left: 4px;
    top: 3px;
    width: 32px;
    height: 32px;
    background: #0077BD;
    border-radius: 4px;
}

.custom-checkbox-input:checked {
	background: #0077BD;
}
</style>