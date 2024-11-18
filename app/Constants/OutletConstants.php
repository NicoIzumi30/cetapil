<?php

namespace App\Constants;

final class OutletStatus
{
    public const APPROVED = 'APPROVED';
    public const PENDING = 'PENDING';
    public const REJECTED = 'REJECTED';

    public const ALL = [
        self::APPROVED,
        self::PENDING,
        self::REJECTED,
    ];
}
class OutletConstants
{
    public const GET_LIST = 'Get the outlet list successfully.';
    public const GET_DETAIL = 'Get the outlet detail successfully.';
    public const CREATE = 'Outlet created successfully.';
    public const UPDATE = 'Outlet updated successfully.';
    public const DETAIL = 'Get outlet detail successfully.';
    public const DELETE = 'Outlet deleted successfully.';
    public const NOT_FOUND = 'Outlet not found.';

    public const APPROVED = 'Outlet approved successfully';
    public const REJECTED = 'Outlet rejected successfully';

    public const GET_FORM_LIST = 'Get the outlet form list successfully.';
    public const INSERT_FORM = 'Form answer inserted successfully';
    public const UPDATE_FORM = 'Form answer updated successfully';

    public const BULK = 'Bulk outlet input successfully created.';
    public const BULK_ERROR = 'Error processing input bulk.';

    public const TEMPLATE_BULK = 'Bulk outlet template download successfully';
    public const UPDATE_AV3M = 'AV3M updated successfully';

    public const GET_CITY_LIST = 'Get the city list successfully';
    public const CITY_NOT_FOUND = 'City not found';
}
