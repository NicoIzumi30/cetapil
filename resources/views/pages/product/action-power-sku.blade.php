<x-action-table-dropdown>
    <li>
        <button 
            type="button"
            data-id="{{ $powerSku->id }}"
            class="dropdown-option view-power-sku"
            onclick="openModal('edit-power-sku'); getPowerSkuData('{{ $powerSku->id }}')">
            Lihat Data
        </button>
    </li>
    <li>
        <a href="{{ route('products.power-skus.destroy', $powerSku->id) }}"
           data-name="{{ $powerSku->product->sku }}"
           class="dropdown-option text-red-400 delete-btn">
            Hapus Data
        </a>
    </li>
</x-action-table-dropdown>