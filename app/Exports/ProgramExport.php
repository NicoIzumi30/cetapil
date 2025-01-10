<?php

namespace App\Exports;

use App\Models\Program;
use App\Traits\ExcelExportable;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class ProgramExport implements FromCollection, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    use ExcelExportable;

    protected $photoCols = ['B'];

    public function collection()
    {
        return $this->safeCollection(function () {
            return Program::with('province')
                ->orderBy('province_code')
                ->get();
        });
    }

    public function headings(): array
    {
        return [
            'Regional',
            'Program',
            'Last Updated'
        ];
    }

    public function map($program): array
    {
        return $this->safeMap(function ($program) {
            return [
                $program->province->name ?? '',
                $program->path ? config('app.storage_url') . $program->path : '-',
                $program->updated_at
            ];
        }, $program, 'program');
    }

    public function styles(Worksheet $sheet)
    {
        $this->applyDefaultStyles($sheet);
        
        // Apply hyperlinks to program file columns
        $this->applyHyperlinks($sheet, $this->photoCols, $sheet->getHighestRow());

        return [
            1 => ['font' => ['bold' => true]],
        ];
    }
}