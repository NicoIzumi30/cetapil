{{-- resources/views/pages/action-power-sku.blade.php --}}
<x-action-table-dropdown>
    <li>
        <button id="view-power-sku" data-id="{{ $id }}" class="dropdown-option">
            Lihat Data
        </button>
    </li>
    <li>
        <a href="{{ route('products.power-skus.destroy', $id) }}" data-name="{{ $sku }}"
            class="dropdown-option text-red-400 delete-btn">
            Hapus Data
        </a>
    </li>
</x-action-table-dropdown>
