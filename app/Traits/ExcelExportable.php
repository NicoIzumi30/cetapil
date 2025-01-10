<?php

namespace App\Traits;

use Illuminate\Support\Collection;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use PhpOffice\PhpSpreadsheet\Cell\DataType;
use Illuminate\Support\Facades\Log;
use Carbon\Carbon;

trait ExcelExportable
{
    protected int $minimumWidth = 10;
    protected int $maximumWidth = 50;
    protected string $headerColor = '4A90E2';
    protected int $defaultRowHeight = 25;
    protected bool $useAlternatingRows = false;
    protected string $alternatingRowColor = 'F8F9FA';

    /**
     * Apply default styles to the worksheet
     */
    public function applyDefaultStyles(Worksheet $sheet): void
    {
        $lastRow = $sheet->getHighestRow();
        $lastColumn = $sheet->getHighestColumn();

        // Header styles
        $this->applyHeaderStyles($sheet, $lastColumn);

        // Data styles
        $this->applyDataStyles($sheet, $lastColumn, $lastRow);

        // Column widths
        $this->optimizeColumnWidths($sheet, $lastColumn);

        // Alternating row colors if enabled
        if ($this->useAlternatingRows) {
            $this->applyAlternatingRowColors($sheet, $lastColumn, $lastRow);
        }

        // Set default row height
        $sheet->getDefaultRowDimension()->setRowHeight($this->defaultRowHeight);

        // Freeze top row
        $sheet->freezePane('A2');
    }

    protected function applyAlternatingRowColors(Worksheet $sheet, string $lastColumn, int $lastRow): void
    {
        for ($row = 2; $row <= $lastRow; $row++) {
            if ($row % 2 == 0) {
                $sheet->getStyle("A{$row}:{$lastColumn}{$row}")->applyFromArray([
                    'fill' => [
                        'fillType' => Fill::FILL_SOLID,
                        'startColor' => ['rgb' => $this->alternatingRowColor],
                    ],
                ]);
            }
        }
    }

    protected function safeQuery(callable $queryBuilder)
    {
        try {
            return $queryBuilder();
        } catch (\Exception $e) {
            Log::error('Error executing query:', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            throw $e;
        }
    }

    protected function formatDateTime(?string $dateTime, string $format = 'Y-m-d H:i:s'): string
    {
        return $dateTime ? Carbon::parse($dateTime)->format($format) : '';
    }

    /**
     * Apply header styles
     */
    protected function applyHeaderStyles(Worksheet $sheet, string $lastColumn): void
    {
        $sheet->getStyle("A1:{$lastColumn}1")->applyFromArray([
            'font' => [
                'bold' => true,
                'color' => ['rgb' => 'FFFFFF'],
            ],
            'fill' => [
                'fillType' => Fill::FILL_SOLID,
                'startColor' => ['rgb' => $this->headerColor],
            ],
            'alignment' => [
                'horizontal' => Alignment::HORIZONTAL_CENTER,
                'vertical' => Alignment::VERTICAL_CENTER,
            ],
        ]);
    }

    /**
     * Apply data styles
     */
    protected function applyDataStyles(Worksheet $sheet, string $lastColumn, int $lastRow): void
    {
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
    }

    /**
     * Optimize column widths
     */
    protected function optimizeColumnWidths(Worksheet $sheet, string $lastColumn): void
    {
        foreach (range('A', $lastColumn) as $column) {
            $sheet->getColumnDimension($column)->setAutoSize(true);
            $columnWidth = $sheet->getColumnDimension($column)->getWidth();

            if ($columnWidth < $this->minimumWidth) {
                $sheet->getColumnDimension($column)->setWidth($this->minimumWidth);
            } elseif ($columnWidth > $this->maximumWidth) {
                $sheet->getColumnDimension($column)->setWidth($this->maximumWidth);
                $sheet->getStyle($column)->getAlignment()->setWrapText(true);
            }
        }
    }

    /**
     * Apply hyperlinks to specified columns
     */
    protected function applyHyperlinks(Worksheet $sheet, array $columns, int $lastRow): void
    {
        foreach ($columns as $col) {
            for ($row = 2; $row <= $lastRow; $row++) {
                $cell = $sheet->getCell($col . $row);
                $value = $cell->getValue();
                
                if ($value !== '-' && filter_var($value, FILTER_VALIDATE_URL)) {
                    $cell->setDataType(DataType::TYPE_STRING);
                    $cell->getHyperlink()->setUrl($value);
                    $sheet->getStyle($col . $row)->applyFromArray([
                        'font' => [
                            'underline' => true,
                            'color' => ['rgb' => '800080']
                        ]
                    ]);
                }
            }
        }
    }

    /**
     * Safe mapping with error handling
     */
    protected function safeMap(callable $mapper, $row, string $context): array
    {
        try {
            return $mapper($row);
        } catch (\Exception $e) {
            Log::error("Error mapping {$context}:", [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
                'row_id' => $row->id ?? 'unknown'
            ]);
            
            // Return empty array with same length as headers
            return array_fill(0, count($this->headings()), '-');
        }
    }

    /**
     * Format currency values
     */
    protected function formatCurrency($value): string
    {
        return 'Rp ' . number_format($value, 0, ',', '.');
    }

    /**
     * Get collection with error handling
     */
    protected function safeCollection(callable $collector): Collection
    {
        try {
            return $collector();
        } catch (\Exception $e) {
            Log::error('Error collecting data:', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            return collect([]);
        }
    }
}