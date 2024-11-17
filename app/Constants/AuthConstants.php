<?php

namespace App\Constants;

class AuthConstants {
    // SUCCESS
    public const LOGIN = 'User logged in successfully';
    public const LOGOUT = 'User logged out successfully';
    public const ME = 'Get auth detail successfully';
    public const CHANGE_PASSWORD = 'Password changed successfully';

    // ERROR
    public const INVALID_CREDENTIAL = 'These credentials do not match our records';
    public const USER_NOT_FOUND = 'User not found or token is invalid';
    public const TOKEN_NOT_PROVIDED = 'Unauthorized, token not provided';
    public const PASSWORD_NOT_MATCHED = 'Old password is invalid';
}
