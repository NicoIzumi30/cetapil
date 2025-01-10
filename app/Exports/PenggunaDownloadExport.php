<?php

namespace App\Exports;

use App\Models\User;
use App\Traits\ExcelExportable;
use Maatwebsite\Excel\Concerns\FromQuery;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\WithChunkReading;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class PenggunaDownloadExport implements FromQuery, WithHeadings, WithMapping, WithStyles, WithChunkReading
{
    use ExcelExportable;

    protected int $chunkSize = 1000;

    public function __construct()
    {
        $this->useAlternatingRows = true;
    }

    public function query()
    {
        return User::query()
            ->select([
                'id', 'name', 'email', 'phone_number', 
                'city', 'region', 'address', 'active', 
                'created_at'
            ])
            ->orderBy('name');
    }

    public function map($user): array 
    {
        return $this->safeMap(function ($user) {
            return [
                $user->name,
                $user->email,
                $user->phone_number,
                $user->city ?? '',
                $user->region ?? '',
                $user->address ?? '',
                $user->active ? 'Aktif' : 'Tidak Aktif',
                $this->formatDateTime($user->created_at),
            ];
        }, $user, 'User Export');
    }

    public function headings(): array
    {
        return [
            'Nama',
            'Email',
            'No. Telepon', 
            'Kota',
            'Regional',
            'Alamat',
            'Status',
            'Tanggal Dibuat'
        ];
    }

    public function styles(Worksheet $sheet)
    {
        $this->applyDefaultStyles($sheet);
    }

    public function chunkSize(): int
    {
        return $this->chunkSize;
    }
}