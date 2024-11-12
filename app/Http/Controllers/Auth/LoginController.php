<?php

namespace App\Http\Controllers\Auth;

use App\Models\User;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;

class LoginController extends Controller
{
    public function index()
    {
        return view('pages.login');
    }
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);
    
        // Filter tambahan untuk memastikan user aktif dan tidak di-soft delete
        $user = User::where('email', $request->email)
            ->where('active', true)
            ->whereNull('deleted_at')
            ->first();
    
        if (!$user) {
            return back()
                ->withInput($request->only('email'))
                ->withErrors([
                    'email' => 'Email atau password yang Anda masukkan salah.',
                ]);
        }
    
        // Mencoba login
        if (Auth::attempt([
            'email' => $request->email,
            'password' => $request->password,
            'active' => true
        ])) {
            $request->session()->regenerate();
            
            return redirect()->intended('dashboard')
                ->with('success', 'Berhasil login!');
        }
    
        return back()
            ->withInput($request->only('email'))
            ->withErrors([
                'email' => 'Email atau password yang Anda masukkan salah.',
            ]);
    }

}