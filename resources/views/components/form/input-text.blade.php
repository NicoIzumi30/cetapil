@props(['name', 'id'])

<div class="mb-3">
    <label for="{{ $id }}" class="form-label">{{ $label }}</label>
    <input type="text" id="{{ $id }}" class="form-control" {{ $attributes }} />
</div>

