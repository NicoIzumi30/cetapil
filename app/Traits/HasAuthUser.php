<?php

namespace App\Traits;

use Illuminate\Support\Facades\Auth;

trait HasAuthUser
{
    /**
     * Get the currently authenticated user
     *
     * @return \App\Models\User|null
     */
    protected function getAuthUser()
    {
        return Auth::user();
    }

    /**
     * Get the ID of currently authenticated user
     *
     * @return int|null
     */
    protected function getAuthUserId()
    {
        return Auth::id();
    }

    /**
     * Check if user is authenticated
     *
     * @return bool
     */
    protected function isAuthenticated()
    {
        return Auth::check();
    }

    /**
     * Check if user is not authenticated
     *
     * @return bool
     */
    protected function isNotAuthenticated()
    {
        return Auth::guest();
    }

    /**
     * Get specific user attribute
     *
     * @param string $attribute
     * @return mixed|null
     */
    protected function getAuthUserAttribute(string $attribute)
    {
        return Auth::user()?->{$attribute};
    }

    /**
     * Check if authenticated user has specific role
     *
     * @param string|array $roles
     * @return bool
     */
    protected function hasRole($roles)
    {
        if (!$this->isAuthenticated()) {
            return false;
        }

        if (is_array($roles)) {
            return $this->getAuthUser()->hasAnyRole($roles);
        }

        return $this->getAuthUser()->hasRole($roles);
    }
}
