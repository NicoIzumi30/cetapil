<?php

namespace App\Http\Controllers\Web;

use App\Models\Outlet;
use App\Models\OutletForm;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Validation\ValidationException;

class RoutingRequestControler extends Controller
{

    protected $weekOptions = [
        '1x4' => [
            ['name' => 'Week 1', 'value' => '1'],
            ['name' => 'Week 2', 'value' => '2'],
            ['name' => 'Week 3', 'value' => '3'],
            ['name' => 'Week 4', 'value' => '4']
        ],
        '1x2' => [
            ['name' => 'Week 1 & 3', 'value' => '13'],
            ['name' => 'Week 2 & 4', 'value' => '24']
        ]
    ];
    
    public function index()
    {
        return view("pages.routing.request");
    }
    public function getData(Request $request)
    {
        $query = Outlet::with('user:id,name')
            ->whereIn('status', ['PENDING', 'REJECTED'])
            ->orderBy('created_at', 'desc');
        $totalRecords = Outlet::count(); // Total semua records
        $filteredRecords = (clone $query)->count();

        $result = $query->skip($request->start)
            ->take($request->length)
            ->get();

        return response()->json([
            'draw' => intval($request->draw),
            'recordsTotal' => $totalRecords,
            'recordsFiltered' => $filteredRecords,
            'data' => $result->map(function ($item) {
                return [
                    'id' => $item->id,
                    'outlet' => $item->name,
                    'sales' => $item->user->name,
                    'area' => $item->longitude . ', ' . $item->latitude,
                    'visit_day' => getVisitDayByNumber($item->visit_day),
                    'status' => getStatusBadge($item->status),
                    'actions' => view('pages.routing.action_request', [
                        'item' => $item,
                        'outletId' => $item->id
                    ])->render()
                ];
            })
        ]);
    }
    public function edit($id)
    {
        $outlet = Outlet::with('user')->where('id', $id)->first();
        $outletForms = OutletForm::with(['answers' => function ($query) use ($id) {
            $query->where('outlet_id', $id);
        }])->get();
        $cycles = ["1x1", "1x2", "1x4"];
        $weekOptions = $this->weekOptions;

        return view('pages.routing.detail-request', compact('outlet', 'outletForms','cycles','weekOptions'));
    }
    public function approve(Request $request, string $id)
{
    try {
        $request->validate([
            'outlet_code' => 'required|string',
            'outlet_type' => 'required|string',
            'account_type' => 'required|string',
            'cycle' => 'required|string|in:1x1,1x2,1x4',
            'week' => 'required_if:cycle,1x2,1x4',
        ]);

        $outlet = Outlet::findOrFail($id);
        $updateData = [
            'code' => $request->outlet_code,
            'tipe_outlet' => $request->outlet_type,
            'account' => $request->account_type,
            'cycle' => $request->cycle,
            'status' => 'APPROVED',
        ];

        if (in_array($request->cycle, ['1x2', '1x4'])) {
            $updateData['week'] = $request->cycle === '1x2' ?
                ($request->week === '13' ? '1&3' : '2&4') :
                $request->week;
        }

        $outlet->update($updateData);

        return response()->json([
            'status' => 'success',
            'message' => 'Outlet berhasil disetujui',
        ]);
    } catch (ValidationException $e) {
        return response()->json([
            'status' => 'error',
            'message' => 'Harap isi semua field yang diperlukan',
            'errors' => $e->errors(),
        ], 422);
    } catch (\Exception $e) {
        return response()->json([
            'status' => 'error',
            'message' => 'Outlet gagal disetujui',
        ], 500);
    }
}
    public function reject(Request $request, string $id)
    {
        try {
            $outlet = Outlet::findOrFail($id);
            $outlet->status = 'REJECTED';
            $outlet->save();
            return response()->json([
                'status' => 'success',
                'message' => 'Outlet berhasil ditolak'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Outlet gagal ditolak'
            ], 500);
        }
    }
}
