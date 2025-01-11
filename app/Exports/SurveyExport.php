<?php

namespace App\Exports;

use App\Models\SalesActivity;
use App\Traits\ExcelExportable;
use Carbon\Carbon;
use Maatwebsite\Excel\Concerns\FromQuery;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use Illuminate\Support\Facades\Log;

class SurveyExport implements FromQuery, WithHeadings, WithMapping, WithStyles
{
    use ExcelExportable;

    protected $startDate;
    protected $endDate;
    protected $region;

    public function __construct($startDate = null, $endDate = null, $region = null)
    {
        $this->startDate = $startDate instanceof Carbon ? $startDate : ($startDate ? Carbon::parse($startDate) : null);
        $this->endDate = $endDate instanceof Carbon ? $endDate : ($endDate ? Carbon::parse($endDate) : null);
        $this->region = $region;
        $this->useAlternatingRows = true;

        Log::info('SurveyExport initialized', [
            'start_date' => $this->startDate?->format('Y-m-d'),
            'end_date' => $this->endDate?->format('Y-m-d'),
            'region' => $this->region
        ]);
    }

    public function query()
    {
        return $this->safeQuery(function () {
            $query = SalesActivity::query()
                ->with([
                    'user:id,name',
                    'outlet:id,name,TSO,code,account,tipe_outlet,channel_id',
                    'outlet.channel:id,name',
                    'surveys.survey.category'
                ])
                ->where('status', 'SUBMITTED');
                $query->limit(10);
            if ($this->startDate && $this->endDate) {
                $query->whereBetween('checked_in', [
                    $this->startDate->startOfDay(),
                    $this->endDate->endOfDay()
                ]);
            }

            if ($this->region && $this->region !== 'all') {
                $query->whereHas('outlet.city', function($q) {
                    $q->where('province_code', $this->region);
                });
            }

            return $query->orderBy('created_at', 'desc');
        });
    }

    public function headings(): array
    {
        return [
            'Nama Sales',
            'TSO',
            'Outlet',
            'Account',
            'Channel',
            'Kode Outlet',
            'Tipe Outlet',
            'Visit Day',
            'Check In',
            'Check Out',
            'Total Visit Time',
            'Week',
            'Knowledge Views',
            'Question Category',
            'Question',
            'Answer',
            'Created At'
        ];
    }

    public function map($activity): array
    {
        return $this->safeMap(function($activity) {
            $baseData = [
                data_get($activity, 'user.name', '-'),
                data_get($activity, 'outlet.TSO', '-'),
                data_get($activity, 'outlet.name', '-'),
                data_get($activity, 'outlet.account', '-'),
                data_get($activity, 'outlet.channel.name', '-'),
                data_get($activity, 'outlet.code', '-'),
                data_get($activity, 'outlet.tipe_outlet', '-'),
                getVisitDayByNumber(data_get($activity, 'outlet.visit_day', 0)),
                $this->formatDateTime($activity->checked_in),
                $this->formatDateTime($activity->checked_out),
                ($activity->time_availability ?? 0) + ($activity->time_visibility ?? 0) + 
                ($activity->time_knowledge ?? 0) + ($activity->time_survey ?? 0) + ($activity->time_order ?? 0),
                optional($activity->created_at)->format('W') ?? '-',
                $activity->views_knowledge ?? 0
            ];

            $result = [];
            if ($activity->surveys->isEmpty()) {
                $result[] = array_merge($baseData, ['-', '-', '-', $this->formatDateTime($activity->created_at)]);
            } else {
                foreach ($activity->surveys as $survey) {
                    $result[] = array_merge($baseData, [
                        data_get($survey, 'survey.category.title', '-'),
                        data_get($survey, 'survey.question', '-'),
                        $survey->survey->type === 'bool' ? ($survey->answer === 'true' ? 'YES' : 'NO') : $survey->answer,
                        $this->formatDateTime($activity->created_at)
                    ]);
                }
            }

            return count($result) > 0 ? $result[0] : $result;
        }, $activity, 'Survey Export');
    }

    public function styles(Worksheet $sheet)
    {
        $this->applyDefaultStyles($sheet);
        return [1 => ['font' => ['bold' => true]]];
    }
}