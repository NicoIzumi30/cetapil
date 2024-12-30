<?php

namespace App\Exports;

use App\Models\SalesActivity;
use App\Models\SurveyCategory;
use App\Models\SurveyQuestion;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use Maatwebsite\Excel\Concerns\FromQuery;
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

class SurveyExport implements FromQuery, WithMapping, WithStyles, ShouldAutoSize, WithCustomStartCell, WithEvents
{
    protected $surveyCategories;
    protected $surveyQuestions;
    protected $staticColumns;
    protected $lastStaticColumn = 'O'; // Kolom sebelum data survey dimulai

    public function __construct()
    {
        $this->surveyCategories = SurveyCategory::orderBy('id')->get();
        $this->surveyQuestions = SurveyQuestion::orderBy('survey_category_id')->get();
        $this->staticColumns = [
            'Nama Sales', 'TSO', 'Outlet', 'Account', 'Channel',
            'Kode Store', 'Tipe Outlet', 'Visit Day', 'Check In',
            'Check Out', 'Total Visit Time', 'Week', 'Knowledge Views',
            'Created At', 'Updated At'
        ];
    }

    public function query()
    {
        return SalesActivity::with([
            'user:id,name',
            'outlet:id,name,TSO,code,account,tipe_outlet,channel_id,visit_day',
            'outlet.channel:id,name',
            'surveys.survey'
        ]);
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

                $currentCol = Coordinate::columnIndexFromString($this->lastStaticColumn);
                $categoryColors = [
                    'Apakah POWER SKU tersedia di toko?' => '023e8a', // Biru
                    'Berapa harga POWER SKU di toko?' => '0077b6',   // Hijau
                    'Berapa harga kompetitor di toko?' => '00b4d8',  // Oranye
                ];

                foreach ($this->surveyCategories as $category) {
                    $startCol = $this->getColumnLetter(++$currentCol);
                    $questionCount = $this->surveyQuestions->where('survey_category_id', $category->id)->count();

                    if ($questionCount > 0) {
                        $endCol = $this->getColumnLetter($currentCol + $questionCount - 1);
                        $color = $categoryColors[$category->title] ?? '4A90E2';

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
                $col = 'A';
                foreach ($this->staticColumns as $header) {
                    $worksheet->getStyle($col . '1')->applyFromArray([
                        'fill' => [
                            'fillType' => Fill::FILL_SOLID,
                            'startColor' => ['rgb' => '4A90E2'], // Biru
                        ],
                        'font' => [
                            'bold' => true,
                            'color' => ['rgb' => 'FFFFFF'], // Hitam
                        ],
                        'alignment' => [
                            'horizontal' => Alignment::HORIZONTAL_CENTER,
                            'vertical' => Alignment::VERTICAL_CENTER,
                        ],
                    ]);
                    $col++;
                }
                // Atur warna dan font untuk baris kedua
                $col = 'A';
                foreach ($this->staticColumns as $header) {
                    $worksheet->setCellValue($col . '2', $header);
                    $worksheet->getStyle($col . '2')->applyFromArray([
                        'fill' => [
                            'fillType' => Fill::FILL_SOLID,
                            'startColor' => ['rgb' => '4A90E2'], // Biru
                        ],
                        'font' => [
                            'bold' => true,
                            'color' => ['rgb' => 'FFFFFF'], // Hitam
                        ],
                        'alignment' => [
                            'horizontal' => Alignment::HORIZONTAL_CENTER,
                            'vertical' => Alignment::VERTICAL_CENTER,
                        ],
                    ]);
                    $col++;
                }

                foreach ($this->surveyQuestions as $question) {
                    $worksheet->setCellValue($col . '2', $question->question);
                    $worksheet->getStyle($col . '2')->applyFromArray([
                        'fill' => [
                            'fillType' => Fill::FILL_SOLID,
                            'startColor' => ['rgb' => '4A90E2'], // Biru
                        ],
                        'font' => [
                            'bold' => true,
                            'color' => ['rgb' => 'FFFFFF'], // Hitam
                        ],
                        'alignment' => [
                            'horizontal' => Alignment::HORIZONTAL_CENTER,
                            'vertical' => Alignment::VERTICAL_CENTER,
                        ],
                    ]);
                    $col++;
                }
            },
        ];
    }

    public function map($activity): array
    {
        $mappedData = [
            $activity->user->name,
            $activity->outlet->TSO,
            $activity->outlet->name,
            $activity->outlet->account,
            $activity->outlet->channel->name,
            $activity->outlet->code,
            $activity->outlet->tipe_outlet,
            $activity->outlet->visit_day,
            $activity->checked_in,
            $activity->checked_out,
            $activity->time_availability + $activity->time_visibility + $activity->time_knowledge + $activity->time_survey + $activity->time_order,
            $activity->created_at->format('W'),
            $activity->views_knowledge,
            $activity->created_at,
            $activity->updated_at,
        ];

        foreach ($this->surveyQuestions as $question) {
            $answer = $activity->surveys
                ->where('survey_question_id', $question->id)
                ->first();
                if($answer){
                    if($answer->survey->type == 'bool'){
                        $answer = $answer->answer == 'true' ? 'YES' : 'NO';
                    }else{
                        $answer = $answer->answer;
                    }
                }else{
                    $answer = '-';
                }
            $mappedData[] = $answer;
        }

        return $mappedData;
    }

    public function styles(Worksheet $sheet)
    {
        $lastColumn = $sheet->getHighestColumn();
        $lastRow = $sheet->getHighestRow();

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

        $sheet->getStyle("A3:H{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_LEFT);
        $sheet->getStyle("I3:{$lastColumn}{$lastRow}")->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);

        for ($row = 3; $row <= $lastRow; $row++) {
            if ($row % 2 == 1) {
                $sheet->getStyle("A{$row}:{$lastColumn}{$row}")->applyFromArray([
                    'fill' => [
                        'fillType' => Fill::FILL_SOLID,
                        'startColor' => ['rgb' => 'F8F9FA'],
                    ],
                ]);
            }
        }

        $sheet->getDefaultRowDimension()->setRowHeight(25);
        $sheet->freezePane('A3');

        return [
            1 => ['font' => ['bold' => true]],
            2 => ['font' => ['bold' => true]],
        ];
    }
}
