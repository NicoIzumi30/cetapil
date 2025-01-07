<?php
namespace App\Exports;

use App\Models\Outlet;
use App\Models\Product;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Log;
use Maatwebsite\Excel\Concerns\{
    FromCollection,
    WithHeadings,
    WithMapping,
    WithStyles,
    ShouldAutoSize
};
use PhpOffice\PhpSpreadsheet\Style\{Fill, Border, Alignment};
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class Av3mExport implements FromCollection, WithHeadings, WithMapping, WithStyles, ShouldAutoSize
{
    private Collection $products;
    private Collection $data;
    private array $baseHeadings = ['Code Outlet', 'Nama Outlet'];

    public function __construct()
    {
        $this->products = Product::select('id', 'sku')->get();
        $this->data = Outlet::select('id', 'code', 'name')
        ->whereExists(function ($query) {
            $query->select('outlet_id')
                  ->from('av3ms') // Adjust table name as needed
                  ->whereColumn('outlet_id', 'outlets.id');
        })
        ->get();
    }

    public function collection(): Collection
    {
        return $this->data;
    }

    public function headings(): array
    {
        return array_merge(
            $this->baseHeadings, 
            $this->products->pluck('sku')->unique()->values()->toArray()
        );
    }

    public function map($row): array
    {
        try {
            return array_merge(
                [$row->code ?? '', $row->name ?? ''],
                $this->products->map(fn($product) => getAv3m($row->id, $product->id))->toArray()
            );
        } catch (\Exception $e) {
            Log::error('Error in Av3mExport mapping', [
                'error' => $e->getMessage(),
                'row' => $row->id ?? 'unknown'
            ]);
            return array_fill(0, count($this->products) + 2, 'Error');
        }
    }

    public function styles(Worksheet $sheet): array
    {
        $lastCell = $sheet->getHighestRowAndColumn();
        $range = "A1:{$lastCell['column']}{$lastCell['row']}";

        $this->applyGlobalStyles($sheet, $range);
        $this->applyHeaderStyles($sheet, $lastCell['column']);

        return [1 => ['font' => ['bold' => true]]];
    }

    private function applyGlobalStyles(Worksheet $sheet, string $range): void
    {
        $sheet->getStyle($range)->applyFromArray([
            'alignment' => [
                'horizontal' => Alignment::HORIZONTAL_CENTER,
                'vertical' => Alignment::VERTICAL_CENTER,
                'wrapText' => true,
            ],
            'borders' => [
                'allBorders' => ['borderStyle' => Border::BORDER_THIN],
            ],
        ]);

        $sheet->getDefaultRowDimension()->setRowHeight(20);
    }

    private function applyHeaderStyles(Worksheet $sheet, string $lastColumn): void
    {
        $sheet->getStyle("A1:{$lastColumn}1")->applyFromArray([
            'font' => [
                'bold' => true,
                'color' => ['rgb' => 'FFFFFF'],
            ],
            'fill' => [
                'fillType' => Fill::FILL_SOLID,
                'startColor' => ['rgb' => '4A90E2'],
            ],
        ]);
    }
}