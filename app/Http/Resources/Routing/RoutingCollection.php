<?php 
namespace App\Http\Resources\Routing;

use App\Constants\RoutingConstants;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class RoutingCollection extends JsonResource 
{
    public function toArray(Request $request): array
{
   return [
       "status" => "OK",
       "message" => RoutingConstants::GET_LIST,
       "data" => collect($this->resource)->except(['images', 'forms'])
   ];
}
}
?>