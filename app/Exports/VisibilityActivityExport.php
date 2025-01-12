<?php

namespace App\Exports;

use App\Models\SalesActivity;
use App\Traits\ExcelExportable;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithStyles;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;

class VisibilityActivityExport implements FromCollection, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    use ExcelExportable;

    protected $startDate;
    protected $endDate;
    protected $region;

    /**
     * Constructor
     */
    public function __construct($startDate = null, $endDate = null, $region = 'all')
    {
        $this->startDate = $startDate ? Carbon::parse($startDate) : null;
        $this->endDate = $endDate ? Carbon::parse($endDate) : null;
        $this->region = $region;
    }

    /**
     * Collection method to get data
     */
    public function collection()
    {
        try {
            $query = SalesActivity::with([
                'outlet' => function($q) {
                    $q->with(['channel', 'city', 'province']);
                },
                'user',
                'salesVisibilities' => function($q) {
                    $q->with(['displays', 'competitors', 'posmType']);
                }
            ])->where('status', 'SUBMITTED');

            if ($this->startDate && $this->endDate) {
                $query->whereBetween('checked_in', [
                    $this->startDate->startOfDay(),
                    $this->endDate->endOfDay()
                ]);
            }

            if ($this->region !== 'all') {
                $query->whereHas('outlet.city', function($q) {
                    $q->where('province_code', $this->region);
                });
            }

            return $query->get();
        } catch (\Exception $e) {
            Log::error('Error in visibility collection', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            return collect([]);
        }
    }

    /**
     * Excel headers
     */
    public function headings(): array
    {
        return [
            'Outlet',
            'Kode Outlet',
            'Tipe Outlet',
            'Account',
            'Channel',
            'Sales',
            'Tipe Display Primary Core 1',
            'Visual Primary Core 1',
            'Condition Primary Core 1',
            'Foto Display Primary Core 1',
            'Lebar Rak Primary Core 1(cm)',
            'Shelving Primary Core 1',
            'Tipe Display Primary Core 2',
            'Visual Primary Core 2',
            'Condition Primary Core 2',
            'Foto Display Primary Core 2',
            'Lebar Rak Primary Core 2(cm)',
            'Shelving Primary Core 2',
            'Tipe Display Primary Core 3',
            'Visual Primary Core 3',
            'Condition Primary Core 3',
            'Foto Display Primary Core 3',
            'Lebar Rak Primary Core 3(cm)',
            'Shelving Primary Core 3',
            'Tipe Display Primary Baby 1',
            'Visual Primary Baby 1',
            'Condition Primary Baby 1',
            'Foto Display Primary Baby 1',
            'Lebar Rak Primary Baby 1(cm)',
            'Shelving Primary Baby 1',
            'Tipe Display Primary Baby 2',
            'Visual Primary Baby 2',
            'Condition Primary Baby 2',
            'Foto Display Primary Baby 2',
            'Lebar Rak Primary Baby 2(cm)',
            'Shelving Primary Baby 2',
            'Tipe Display Primary Baby 3',
            'Visual Primary Baby 3',
            'Condition Primary Baby 3',
            'Foto Display Primary Baby 3',
            'Lebar Rak Primary Baby 3(cm)',
            'Shelving Primary Baby 3',
            'Tipe Display Secondary Core 1',
            'Apakah Ada Secondary Display',
            'Foto Secondary Core 1',
            'Tipe Display Secondary Core 2',
            'Apakah Ada Secondary Display',
            'Foto Secondary Core 2',
            'Tipe Display Secondary Baby 1',
            'Apakah Ada Secondary Display',
            'Foto Secondary Baby 1',
            'Tipe Display Secondary Baby 2',
            'Apakah Ada Secondary Display',
            'Foto Secondary Baby 2',
            'Nama Brand Competitor 1',
            'Mekanisme Promo Competitor 1',
            'Periode Promo Competitor 1',
            'Foto Program Competitor 1',
            'Foto Program Competitor 1',
            'Nama Brand Competitor 2',
            'Mekanisme Promo Competitor 2',
            'Periode Promo Competitor 2',
            'Foto Program Competitor 2',
            'Foto Program Competitor 2',
            'Created At',
            'Ended At',
            'Duration',
            'Week'
        ];
    }

    /**
     * Map the data
     */
    public function map($salesActivity): array
    {
        try {
            $visibility = $salesActivity->salesVisibilities->first();
            if (!$visibility) {
                return array_fill(0, count($this->headings()), '');
            }

            // Helper function to get display data
            $getDisplayData = function($type, $index) use ($visibility) {
                try {
                    $displays = $visibility->displays ?? collect();
                    $display = $displays->where('type', $type)->values()->get($index - 1);
                    return [
                        'type' => $display->display_type ?? '',
                        'visual' => $display->visual ?? '',
                        'condition' => $display->condition ?? '',
                        'photo' => $display->photo_url ?? '',
                        'width' => $display->rack_width ?? '',
                        'shelving' => $display->shelving ?? ''
                    ];
                } catch (\Exception $e) {
                    Log::error("Error getting display data for {$type} index {$index}", [
                        'error' => $e->getMessage()
                    ]);
                    return [
                        'type' => '', 'visual' => '', 'condition' => '',
                        'photo' => '', 'width' => '', 'shelving' => ''
                    ];
                }
            };

            // Helper function to get competitor data
            $getCompetitorData = function($index) use ($visibility) {
                try {
                    $competitors = $visibility->competitors ?? collect();
                    $competitor = $competitors->get($index - 1);
                    return [
                        'brand' => $competitor->brand_name ?? '',
                        'promo' => $competitor->promo_mechanism ?? '',
                        'period' => $competitor->promo_period ?? '',
                        'photo1' => $competitor->photo_url_1 ?? '',
                        'photo2' => $competitor->photo_url_2 ?? ''
                    ];
                } catch (\Exception $e) {
                    Log::error("Error getting competitor data for index {$index}", [
                        'error' => $e->getMessage()
                    ]);
                    return [
                        'brand' => '', 'promo' => '', 'period' => '',
                        'photo1' => '', 'photo2' => ''
                    ];
                }
            };

            // Get all display data
            $primaryCore1 = $getDisplayData('PRIMARY_CORE', 1);
            $primaryCore2 = $getDisplayData('PRIMARY_CORE', 2);
            $primaryCore3 = $getDisplayData('PRIMARY_CORE', 3);
            $primaryBaby1 = $getDisplayData('PRIMARY_BABY', 1);
            $primaryBaby2 = $getDisplayData('PRIMARY_BABY', 2);
            $primaryBaby3 = $getDisplayData('PRIMARY_BABY', 3);
            $secondaryCore1 = $getDisplayData('SECONDARY_CORE', 1);
            $secondaryCore2 = $getDisplayData('SECONDARY_CORE', 2);
            $secondaryBaby1 = $getDisplayData('SECONDARY_BABY', 1);
            $secondaryBaby2 = $getDisplayData('SECONDARY_BABY', 2);

            // Get competitor data
            $competitor1 = $getCompetitorData(1);
            $competitor2 = $getCompetitorData(2);

            // Build the row data
            return [
                $salesActivity->outlet->name ?? '',
                $salesActivity->outlet->code ?? '',
                $salesActivity->outlet->tipe_outlet ?? '',
                $salesActivity->outlet->account ?? '',
                $salesActivity->outlet->channel->name ?? '',
                $salesActivity->user->name ?? '',
                
                // Primary Core 1
                $primaryCore1['type'],
                $primaryCore1['visual'],
                $primaryCore1['condition'],
                $primaryCore1['photo'],
                $primaryCore1['width'],
                $primaryCore1['shelving'],
                
                // Primary Core 2
                $primaryCore2['type'],
                $primaryCore2['visual'],
                $primaryCore2['condition'],
                $primaryCore2['photo'],
                $primaryCore2['width'],
                $primaryCore2['shelving'],
                
                // Primary Core 3
                $primaryCore3['type'],
                $primaryCore3['visual'],
                $primaryCore3['condition'],
                $primaryCore3['photo'],
                $primaryCore3['width'],
                $primaryCore3['shelving'],
                
                // Primary Baby 1
                $primaryBaby1['type'],
                $primaryBaby1['visual'],
                $primaryBaby1['condition'],
                $primaryBaby1['photo'],
                $primaryBaby1['width'],
                $primaryBaby1['shelving'],
                
                // Primary Baby 2
                $primaryBaby2['type'],
                $primaryBaby2['visual'],
                $primaryBaby2['condition'],
                $primaryBaby2['photo'],
                $primaryBaby2['width'],
                $primaryBaby2['shelving'],
                
                // Primary Baby 3
                $primaryBaby3['type'],
                $primaryBaby3['visual'],
                $primaryBaby3['condition'],
                $primaryBaby3['photo'],
                $primaryBaby3['width'],
                $primaryBaby3['shelving'],
                
                // Secondary Displays
                $secondaryCore1['type'],
                $visibility->has_secondary_display_core_1 ? 'Ya' : 'Tidak',
                $secondaryCore1['photo'],
                
                $secondaryCore2['type'],
                $visibility->has_secondary_display_core_2 ? 'Ya' : 'Tidak',
                $secondaryCore2['photo'],
                
                $secondaryBaby1['type'],
                $visibility->has_secondary_display_baby_1 ? 'Ya' : 'Tidak',
                $secondaryBaby1['photo'],
                
                $secondaryBaby2['type'],
                $visibility->has_secondary_display_baby_2 ? 'Ya' : 'Tidak',
                $secondaryBaby2['photo'],
                
                // Competitor 1
                $competitor1['brand'],
                $competitor1['promo'],
                $competitor1['period'],
                $competitor1['photo1'],
                $competitor1['photo2'],
                
                // Competitor 2
                $competitor2['brand'],
                $competitor2['promo'],
                $competitor2['period'],
                $competitor2['photo1'],
                $competitor2['photo2'],
                
                // Time information
                $salesActivity->created_at ? Carbon::parse($salesActivity->created_at)->format('Y-m-d H:i:s') : '',
                $salesActivity->ended_at ? Carbon::parse($salesActivity->ended_at)->format('Y-m-d H:i:s') : '',
                $salesActivity->duration ?? '',
                $salesActivity->week ?? ''
            ];
        } catch (\Exception $e) {
            Log::error('Error mapping visibility row', [
                'activity_id' => $salesActivity->id ?? 'unknown',
                'error' => $e->getMessage()
            ]);
            return array_fill(0, count($this->headings()), '');
        }
    }

    /**
     * Apply styles to the Excel sheet
     */
    public function styles(Worksheet $sheet)
    {
        $this->applyDefaultStyles($sheet);
        
        $lastRow = $sheet->getHighestRow();
        $lastColumn = 'BL'; // Adjust based on your last column

        // Basic styling for the whole sheet
        $sheet->getStyle("A1:{$lastColumn}{$lastRow}")->applyFromArray([
            'alignment' => [
                'vertical' => Alignment::VERTICAL_CENTER
            ]
        ]);

        // Header styling
        $sheet->getStyle("A1:{$lastColumn}1")->applyFromArray([
            'font' => [
                'bold' => true
            ],
            'alignment' => [
                'horizontal' => Alignment::HORIZONTAL_CENTER
            ]
        ]);

        // Left align text columns (basic info)
        $sheet->getStyle("A2:F{$lastRow}")->applyFromArray([
            'alignment' => [
                'horizontal' => Alignment::HORIZONTAL_LEFT
            ]
        ]);

        // Center align data columns
        $sheet->getStyle("G2:{$lastColumn}{$lastRow}")->applyFromArray([
            'alignment' => [
                'horizontal' => Alignment::HORIZONTAL_CENTER
            ]
        ]);

        // Style for URL/photo columns
        $photoColumns = ['J', 'P', 'V', 'AB', 'AH', 'AN', 'AQ', 'AT', 'AW', 'AZ', 'BD', 'BE', 'BI', 'BJ'];
        foreach ($photoColumns as $col) {
            $sheet->getStyle("{$col}2:{$col}{$lastRow}")->applyFromArray([
                'alignment' => [
                    'horizontal' => Alignment::HORIZONTAL_LEFT,
                    'wrapText' => false
                ]
            ]);
        }

        // Auto-wrap text for all other columns
        $sheet->getStyle("A1:{$lastColumn}{$lastRow}")->getAlignment()->setWrapText(true);

        // Set column width for better readability
        foreach (range('A', $lastColumn) as $col) {
            $sheet->getColumnDimension($col)->setAutoSize(true);
        }

        return [
            1 => [
                'font' => ['bold' => true],
                'alignment' => ['horizontal' => Alignment::HORIZONTAL_CENTER]
            ]
        ];
    }
}