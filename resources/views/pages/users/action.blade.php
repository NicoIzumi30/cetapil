<!-- resources/views/products/actions.blade.php -->
<x-action-table-dropdown>
    <li>
    <a href="{{route('users.edit', $userId)}}" class="dropdown-option">Lihat
    Data</a> 
    </li>
    <li>
        <a href="{{ route('users.destroy', $userId) }}"
            class="dropdown-option text-red-400 delete-btn" 
            data-name="{{ $item->name}}">
            Hapus Data
        </a>
    </li>
</x-action-table-dropdown>