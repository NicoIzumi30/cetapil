<?php

namespace App\Http\Controllers\Web;

use App\Models\City;
use App\Models\Role;
use App\Models\User;
use App\Models\Province;
use Illuminate\Support\Arr;
use Illuminate\Http\Request;
use App\Http\Requests\UserRequest;
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
    public function index(Request $request)
    {
        $query = User::with('roles')
            ->where('id', '!=', Auth::id())
            ->orderBy('created_at', 'desc')->get();
        
		$perPage = $request->input('per_page', 3);
        // Validate the per_page parameter to ensure it's one of the allowed values
        $validPerPage = in_array($perPage, [3,10, 20, 30, 40, 50]) ? $perPage : 3;
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
        return view('pages.users.create', compact('cities', 'roles'));
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
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
