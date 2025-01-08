<?php

namespace App\Http\Controllers\Web;

use App\Models\Outlet;
use App\Models\OutletForm;
use App\Models\OutletRouting;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Str;

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

        $totalRecords = Outlet::count();
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
                    'visit_day' => getVisitDays($item->id), // Modified to use helper function
                    'visit_week' => getWeeks($item->id),    // Added to show weeks
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
        $outlet = Outlet::with(['user', 'outletRoutings'])->where('id', $id)->first();
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
                'account_type' => 'required|string',
                'visit_day' => 'required|array',
                'visit_day.*' => 'required|string|max:1',
                'week' => 'required|array',
                'week.*' => 'required|string'
            ]);

            $outlet = Outlet::findOrFail($id);
            
            // Update basic outlet information
            $outlet->update([
                'code' => $request->outlet_code,
                'tipe_outlet' => $request->outlet_type,
                'account' => $request->account_type,
                'status' => 'APPROVED'
            ]);

            // Clear existing routings
            OutletRouting::where('outlet_id', $id)->delete();

            // Create new routings
            foreach($request->visit_day as $key => $visitDay) {
                OutletRouting::create([
                    'id' => Str::uuid(),
                    'outlet_id' => $outlet->id,
                    'visit_day' => (string)$visitDay,
                    'week' => $request->week[$key]
                ]);
            }

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
