<!-- resources/views/products/actions.blade.php -->
<x-action-table-dropdown>
    <li>
        <button class="dropdown-option" id="view-product" data-id="{{ $productId }}">
            Lihat Data
        </button>
    </li>
    <li>
        <a href="{{ route('products.destroy', $productId) }}"
            class="dropdown-option text-red-400 delete-btn" 
            data-name="{{ $item->sku }}">
            Hapus Data
        </a>
        <button class="dropdown-option" id="view-av3m" data-id="{{ $productId }}">
            Update AV3M
        </button>
    </li>
</x-action-table-dropdown>