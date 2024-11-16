<?php

namespace App\Http\Controllers\Auth;

use App\Models\User;
use Illuminate\Http\Request;
use App\Http\Requests\LoginRequest;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;

class LoginController extends Controller
{
    public function index()
    {
        return view('pages.login');
    }
    public function login(LoginRequest $request)
    {
        if (Auth::attempt([
            'email' => $request->email,
            'password' => $request->password,
            'active' => true
        ], true)) {
            $request->session()->regenerate();
            session(['auth.user_id' => Auth::id()]);
            session()->save();
            return redirect()->intended('/');
        }
        
        return back()->withErrors([
            'email' => 'Email atau password salah.',
        ]);
    }

}