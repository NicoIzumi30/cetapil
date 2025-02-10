<?php

namespace App\Exports;

use App\Models\SalesActivity;
use App\Models\SurveyCategory;
use App\Models\SurveyQuestion;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithEvents;
use Maatwebsite\Excel\Concerns\WithStyles;
use PhpOffice\PhpSpreadsheet\Style\Border;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Events\BeforeWriting;
use PhpOffice\PhpSpreadsheet\Cell\Coordinate;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use Maatwebsite\Excel\Concerns\WithCustomStartCell;
use Illuminate\Support\LazyCollection;
use Illuminate\Support\Collection;

class SurveyExport implements FromCollection, WithMapping, WithStyles, ShouldAutoSize, WithCustomStartCell, WithEvents
{
    protected $surveyCategories;
    protected $surveyQuestions;
    protected $staticColumns;
    protected $query;
    protected $chunkSize = 1000; // Adjust chunk size based on your server's memory capacity
    protected $lastStaticColumn = 'O';

    public function __construct($query)
    {
        $this->query = $query;
        // Load these once to prevent multiple database queries
        $this->surveyCategories = SurveyCategory::orderBy('id')->get();
        $this->surveyQuestions = SurveyQuestion::orderBy('survey_category_id')->get();
        $this->staticColumns = [
            'Nama Sales', 'TSO', 'Outlet', 'Account', 'Channel',
            'Kode Store', 'Tipe Outlet', 'Visit Day', 'Check In',
            'Check Out', 'Total Visit Time', 'Week', 'Knowledge Views',
            'Created At', 'Updated At'
        ];
    }

    public function collection()
    {
        // Use lazy loading with chunks
        return LazyCollection::make(function () {
            $chunk = [];
            $this->query->chunk($this->chunkSize, function ($records) use (&$chunk) {
                foreach ($records as $record) {
                    $chunk[] = $record;
                }
            });
            return $chunk;
        });
    }

    public function startCell(): string
    {
        return 'A3';
    }

    protected function getColumnLetter($number)
    {
        return Coordinate::stringFromColumnIndex($number);
    }

    public function registerEvents(): array
    {
        return [
            BeforeWriting::class => function (BeforeWriting $event) {
                $worksheet = $event->writer->getSheetByIndex(0);
                
                // Cache category colors to prevent repetitive array access
                $categoryColors = [
                    'Apakah POWER SKU tersedia di toko?' => '023e8a',
                    'Berapa harga POWER SKU di toko?' => '0077b6',
                    'Berapa harga kompetitor di toko?' => '00b4d8',
                ];

                // Pre-calculate styles for reuse
                $defaultHeaderStyle = [
                    'fill' => [
                        'fillType' => Fill::FILL_SOLID,
                        'startColor' => ['rgb' => '4A90E2'],
                    ],
                    'font' => [
                        'bold' => true,
                        'color' => ['rgb' => 'FFFFFF'],
                    ],
                    'alignment' => [
                        'horizontal' => Alignment::HORIZONTAL_CENTER,
                        'vertical' => Alignment::VERTICAL_CENTER,
                    ],
                ];

                // Apply category headers
                $currentCol = Coordinate::columnIndexFromString($this->lastStaticColumn);
                foreach ($this->surveyCategories as $category) {
                    $startCol = $this->getColumnLetter(++$currentCol);
                    $questionCount = $this->surveyQuestions->where('survey_category_id', $category->id)->count();

                    if ($questionCount > 0) {
                        $endCol = $this->getColumnLetter($currentCol + $questionCount - 1);
                        $color = $categoryColors[$category->title] ?? '4A90E2';
                        if($category->title == null){
                            $color = '4A90E2';
                        }
                        $worksheet->setCellValue($startCol . '1', $category->title);
                        $worksheet->mergeCells($startCol . '1:' . $endCol . '1');

                        $worksheet->getStyle($startCol . '1:' . $endCol . '1')->applyFromArray([
                            'fill' => [
                                'fillType' => Fill::FILL_SOLID,
                                'startColor' => ['rgb' => $color],
                            ],
                            'alignment' => [
                                'horizontal' => Alignment::HORIZONTAL_CENTER,
                                'vertical' => Alignment::VERTICAL_CENTER,
                                'wrapText' => true,
                            ],
                            'font' => [
                                'bold' => true,
                                'color' => ['rgb' => 'FFFFFF'],
                            ],
                        ]);

                        $currentCol += $questionCount - 1;
                    }
                }

                // Apply static column headers efficiently
                $col = 'A';
                foreach ($this->staticColumns as $header) {
                    $worksheet->setCellValue($col . '2', $header);
                    $worksheet->getStyle($col . '1:' . $col . '2')->applyFromArray($defaultHeaderStyle);
                    $col++;
                }

                // Apply question headers efficiently
                foreach ($this->surveyQuestions as $question) {
                    $worksheet->setCellValue($col . '2', $question->question);
                    $worksheet->getStyle($col . '2')->applyFromArray($defaultHeaderStyle);
                    $col++;
                }
            },
        ];
    }

    public function map($activity): array
    {
        // Pre-calculate total time to avoid repeated calculations
        $totalTime = $activity->time_availability + 
                    $activity->time_visibility + 
                    $activity->time_knowledge + 
                    $activity->time_survey + 
                    $activity->time_order;

        $mappedData = [
            $activity->user->name ?? '-',
            $activity->outlet->TSO ?? '-',
            $activity->outlet->name ?? '-',
            $activity->outlet->account ?? '-',
            $activity->outlet->channel->name ?? '-',
            $activity->outlet->code ?? '-',
            $activity->outlet->tipe_outlet,
            $activity->day_name,
            $activity->checked_in,
            $activity->checked_out,
            $totalTime,
            $activity->created_at->format('W'),
            $activity->views_knowledge,
            $activity->created_at,
            $activity->updated_at,
        ];

        // Eager load surveys to prevent N+1 queries
        $surveys = $activity->surveys->keyBy('survey_question_id');
        
        foreach ($this->surveyQuestions as $question) {
            $answer = $surveys->get($question->id);
            if ($answer) {
                $mappedData[] = $answer->survey->type == 'bool' 
                    ? ($answer->answer == 'true' ? 'YES' : 'NO')
                    : $answer->answer;
            } else {
                $mappedData[] = '-';
            }
        }

        return $mappedData;
    }

    public function styles(Worksheet $sheet)
    {
        $lastColumn = $sheet->getHighestColumn();
        $lastRow = $sheet->getHighestRow();

        // Apply borders and alignment in larger chunks
        $sheet->getStyle("A3:{$lastColumn}{$lastRow}")->applyFromArray([
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

        // Bulk apply horizontal alignments
        $sheet->getStyle("A3:H{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_LEFT);
        $sheet->getStyle("I3:{$lastColumn}{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);

        // Apply alternate row colors in chunks
        for ($row = 3; $row <= $lastRow; $row += 2) {
            $sheet->getStyle("A{$row}:{$lastColumn}{$row}")->applyFromArray([
                'fill' => [
                    'fillType' => Fill::FILL_SOLID,
                    'startColor' => ['rgb' => 'F8F9FA'],
                ],
            ]);
        }

        $sheet->getDefaultRowDimension()->setRowHeight(25);
        $sheet->freezePane('A3');

        return [
            1 => ['font' => ['bold' => true]],
            2 => ['font' => ['bold' => true]],
        ];
    }
}