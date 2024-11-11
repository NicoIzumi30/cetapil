@props(['title'])
<div>
    <select class="form-select-search-primary"
        {{ $attributes }}>
        <option value="" selected disabled>{{ $title }}</option>
        {{ $slot }}
    </select>
</div>

<script>
    $(document).ready(function() {
        $('.form-select-search-primary').select2({
            dropdownParent: $('.select2-primary')
        });
    });
</script>
