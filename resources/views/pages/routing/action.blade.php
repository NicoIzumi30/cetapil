<x-action-table-dropdown>
    <li>
        <a href="{{route('routing.edit', $outletId)}}" class="dropdown-option">Lihat
            Data</a>
    </li>
    <li>
        <a href="{{ route('routing.destroy', $outletId) }}"
            class="dropdown-option text-red-400 delete-btn" 
            data-name="{{ $item->name }}">
            Hapus Data
        </a>
    </li>
</x-action-table-dropdown>