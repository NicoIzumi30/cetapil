<?php

namespace App\Http\Controllers\Web;

use App\Models\Outlet;
use App\Models\OutletForm;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Validation\ValidationException;

class RoutingRequestControler extends Controller
{
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
        return view('pages.routing.detail-request', compact('outlet', 'outletForms'));
    }
    public function approve(Request $request, string $id)
    {
        try {
            $request->validate([
                'outlet_code' => 'required|string',
                'outlet_type' => 'required|string',
            ]);

            $outlet = Outlet::findOrFail($id);
            $outlet->update([
                'code' => $request->outlet_code,
                'tipe_outlet' => $request->outlet_type,
                'status' => 'APPROVED',
            ]);

            return response()->json([
                'status' => 'success',
                'message' => 'Outlet berhasil disetujui',
            ]);
        } catch (ValidationException $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'Harap isi kode outlet dan tipe outlet',
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
