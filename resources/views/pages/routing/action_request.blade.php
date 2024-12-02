<x-action-table-dropdown>
    <li>
        <a href="{{route('routing.request.edit', $item->id)}}" class="dropdown-option">Lihat
            Data</a>
    </li>
    <li>
        <a href="{{route('routing.request.delete', $item->id)}}" class="dropdown-option text-red-400 btn-delete" data-id="{{$item->id}}" data-name="{{$item->name}}">Hapus
            Data</a>
    </li>
</x-action-table-dropdown>