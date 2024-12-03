<x-action-table-dropdown>
    <li>
        <a href="{{route('visibility.edit', $visibilityId)}}" class="dropdown-option">Lihat
            Data</a>
    </li>
    <li>
        <a href="{{ route('visibility.destroy', $visibilityId) }}"
            class="dropdown-option text-red-400 delete-btn" 
            data-name="Visibility {{ $item->outlet->name }}">
            Hapus Data
        </a>
    </li>
</x-action-table-dropdown>