<?php

namespace App\Http\Resources\User;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'phone_number' => $this->phone_number,
            'longitude' => $this->longitude,
            'latitude' => $this->latitude,
            'city' => $this->city,
            'region' => $this->region,
            'address' => $this->address,
            'active' => $this->active,
            'roles' => RoleResource::collection($this->roles),
            'permissions' => PermissionResource::collection($this->permissions)
        ];
    }
}
