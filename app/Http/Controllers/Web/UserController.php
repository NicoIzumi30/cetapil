<?php

namespace App\Http\Controllers\Web;

use App\Http\Requests\User\UpdateUserRequest;
use App\Models\City;
use App\Models\Role;
use App\Models\User;
use Illuminate\Support\Arr;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Http\Requests\User\CreateUserRequest;
use Illuminate\Pagination\LengthAwarePaginator;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    protected $rolePermissions = [
        'admin' => [
            ['value' => 'menu_report', 'label' => 'Menu Reports'],
            ['value' => 'menu_product', 'label' => 'Menu Produk'],
            ['value' => 'menu_visibility', 'label' => 'Menu Visibility'],
            ['value' => 'menu_routing', 'label' => 'Menu Routing'],
            ['value' => 'menu_selling', 'label' => 'Menu Selling'],
            ['value' => 'menu_user', 'label' => 'Menu Pengguna'],
        ],
        'sales' => [
            ['value' => 'menu_routing', 'label' => 'Menu Routing'],
            ['value' => 'menu_selling', 'label' => 'Menu Selling'],
            ['value' => 'menu_outlet', 'label' => 'Menu Outlet'],
            ['value' => 'menu_activity', 'label' => 'Menu Activity'],
        ],
        'merchandiser' => [
            ['value' => 'menu_routing', 'label' => 'Menu Routing'],
            ['value' => 'menu_selling', 'label' => 'Menu Selling'],
            ['value' => 'menu_outlet', 'label' => 'Menu Outlet'],
            ['value' => 'menu_activity', 'label' => 'Menu Activity'],
        ],
        'superadmin' => [
            ['value' => 'menu_report', 'label' => 'Menu Reports'],
            ['value' => 'menu_product', 'label' => 'Menu Produk'],
            ['value' => 'menu_visibility', 'label' => 'Menu Visibility'],
            ['value' => 'menu_routing', 'label' => 'Menu Routing'],
            ['value' => 'menu_selling', 'label' => 'Menu Selling'],
            ['value' => 'menu_user', 'label' => 'Menu Pengguna'],
            ['value' => 'menu_outlet', 'label' => 'Menu Outlet'],
            ['value' => 'menu_activity', 'label' => 'Menu Activity'],
        ],
    ];
    public function index(Request $request)
    {
        return view('pages.users.index');
    }

    public function getData(Request $request)
{
    $query = User::with('roles')
    ->where('id', '!=', Auth::id())
    ->orderBy('created_at', 'desc');
    
    if ($request->filled('search_term')) {
        $searchTerm = htmlspecialchars(trim($request->search_term));
        $query->where(function($q) use ($searchTerm) {
            $q->where('name', 'like', "%{$searchTerm}%")
            ->orWhere('email', 'like', "%{$searchTerm}%");
        });
    }
    $filteredRecords = (clone $query)->count();
    
    $result = $query->skip($request->start)
                   ->take($request->length)
                   ->get();
    
    return response()->json([
        'draw' => intval($request->draw),
        'recordsTotal' => $filteredRecords,
        'recordsFiltered' => $filteredRecords,
        'data' => $result->map(function($item) {
            return [
                'id' => (int)$item->id,
                'name' => htmlspecialchars($item->name),
                'email' => htmlspecialchars($item->email),
                'role' => htmlspecialchars(ucwords($item->roles[0]->name)),
                'outlet_area' => htmlspecialchars($item->longitude . ', ' . $item->latitude),
                'status' => htmlspecialchars($item->active == 1 ? 'Aktif' : 'Tidak Aktif'),
                'actions' => (view('pages.users.action', [
                    'item' => $item,
                    'userId' => $item->id
                ])->render())
            ];
        })
    ]);
}
    public function create()
    {
        $cities = City::all();
        $roles = Role::all();
        $rolePermissions = $this->rolePermissions;
        return view('pages.users.create', compact('cities', 'roles','rolePermissions'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(CreateUserRequest $request)
    {
        $data = Arr::except($request->validated(), ['city','name', 'permissions', 'role_id', 'password']);
        $user = new User($data);
        $user->city = $request->input('city', null);
        $user->name = ucwords($request->name);
        $user->password = Hash::make($request->password);
        $user->givePermissionTo($request->permissions);
        $user->assignRole($request->role_id);
        $user->save();

        return redirect()->route('users.index')->with('success', 'User created successfully');
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        $user = User::find($id);

        $cities = City::all();
        $roles = Role::all();
        $permissions = array_values($user->getDirectPermissions()->pluck('name')->toArray());
        $rolePermissions = $this->rolePermissions;
        return view('pages.users.edit', compact('user', 'cities', 'roles','permissions', 'rolePermissions'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(UpdateUserRequest $request, string $id)
    {
        $user = User::findOrFail($id);
        $data = Arr::except($request->validated(), ['city','name', 'permissions', 'role_id', 'password']);
        $user->city = $request->input('city', null);
        $user->name = ucwords($request->name);
        $user->fill($data);
        if ($request->input('password')) {
            $user->password = Hash::make($request->password);
        }
        $user->syncPermissions($request->permissions);
        $user->syncRoles($request->role_id);
        $user->save();

        return redirect()->route('users.index')->with('success', 'User updated successfully');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        try {
            $user = User::findOrFail($id);
            $user->delete();
    
            return response()->json([
                'success' => true,
                'status' => 'success',
                'message' => 'Data has been deleted successfully!'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to delete data!'
            ], 500);
        }

    }
}
