<?php

namespace App\Exports;

use App\Models\Channel;
use App\Models\Product;
use App\Models\Program;
use Illuminate\Support\Facades\Log;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use Maatwebsite\Excel\Concerns\WithStyles;
use PhpOffice\PhpSpreadsheet\Style\Border;
use Maatwebsite\Excel\Concerns\WithMapping;
use PhpOffice\PhpSpreadsheet\Cell\DataType;
use Maatwebsite\Excel\Concerns\WithHeadings;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class ProgramExport implements FromCollection, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{

    public function __construct()
    {

    }

    public function collection()
    {
        return Program::with('province')->orderBy('province_code')->get();
    }

    public function headings(): array
    {
        $headers = [
            'Regional',
            'Program',
            'Created At'
        ];

        return $headers;
    }

    public function map($program): array
    {
        try {
            // Initialize base data
            $row = [
                $program->province->name ?? '',
                $program->path ? config('app.storage_url') . $program->path : '-',
                $program->created_at
            ];
            return $row;
        } catch (\Exception $e) {
            Log::error('Error in ProgramExport mapping', [
                'message' => $e->getMessage(),
                'program_id' => $program->id ?? 'unknown'
            ]);
            throw $e;
        }
    }

    public function styles(Worksheet $sheet)
    {
        $lastColumn = 'C'; 
        $lastRow = $sheet->getHighestRow();

        // Header styles
        $sheet->getStyle("A1:{$lastColumn}1")->applyFromArray([
            'font' => [
                'bold' => true,
                'color' => ['rgb' => 'FFFFFF'],
            ],
            'fill' => [
                'fillType' => Fill::FILL_SOLID,
                'startColor' => ['rgb' => '4A90E2'],
            ],
            'alignment' => [
                'horizontal' => Alignment::HORIZONTAL_CENTER,
                'vertical' => Alignment::VERTICAL_CENTER,
            ],
        ]);

        // Data styles
        $sheet->getStyle("A2:{$lastColumn}{$lastRow}")->applyFromArray([
            'alignment' => [
                'vertical' => Alignment::VERTICAL_CENTER,
            ],
            'borders' => [
                'allBorders' => [
                    'borderStyle' => Border::BORDER_THIN,
                    'color' => ['rgb' => '000000'],
                ],
            ],
        ]);
        $photoCols = ['B']; 
        
        foreach ($photoCols as $col) {
            for ($row = 2; $row <= $lastRow; $row++) {
                $cell = $sheet->getCell($col . $row);
                if ($cell->getValue() !== '-') {
                    $sheet->getCell($col . $row)->setDataType(DataType::TYPE_STRING);
                    $sheet->getCell($col . $row)->getHyperlink()->setUrl($cell->getValue());
                    $sheet->getStyle($col . $row)->applyFromArray([
                        'font' => [
                            'underline' => true,
                            'color' => ['rgb' => '800080'] // Kode warna ungu, bisa disesuaikan
                        ]
                    ]);
                }
            }
        }
        // Align SKU center
        // Set row height
        $sheet->getDefaultRowDimension()->setRowHeight(25);

        // Freeze panes
        $sheet->freezePane('A2');

        return [
            1 => ['font' => ['bold' => true]],
        ];
    }
}