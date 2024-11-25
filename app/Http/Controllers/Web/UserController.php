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
        $query = User::with('roles')
            ->where('id', '!=', Auth::id())
            ->orderBy('created_at', 'desc')->get();
        
		$perPage = $request->input('per_page', 10);
        // Validate the per_page parameter to ensure it's one of the allowed values
        $validPerPage = in_array($perPage, [10, 20, 30, 40, 50]) ? $perPage : 10;
        $currentPage = request()->get('page', 1); // Get current page from URL, default to 1
        $offset = ($currentPage - 1) * $validPerPage; // Calculate offset

        // Create paginator instance with dynamic per_page value
        $users = new LengthAwarePaginator(
            $query->slice($offset, $validPerPage)->values(),
            $query->count(),
            $validPerPage,
            $currentPage,
            ['path' => request()->url()]
        );

        // Append the per_page parameter to pagination links
        $users->appends(['per_page' => $validPerPage]);

        return view('pages.users.index', compact('users'));

    }


    /**
     * Show the form for creating a new resource.
     */
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
        $data = Arr::except($request->validated(), ['city', 'permissions', 'role_id', 'password']);
        $user = new User($data);
        $user->city = $request->input('city', null);
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
        $data = Arr::except($request->validated(), ['city', 'permissions', 'role_id', 'password']);
        $user->city = $request->input('city', null);
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
