<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Outlet\CreateOutletFormAnswerRequest;
use App\Http\Requests\Routing\CreateNOORequest;
use App\Models\OutletForm;
use App\Models\OutletFormAnswer;
use Illuminate\Http\Request;
use App\Constants\OutletConstants;
use App\Http\Requests\Outlet\CreateNOOWithFormsRequest;
use App\Http\Resources\Outlet\OutletResource;
use App\Http\Resources\Routing\RoutingCollection;
use App\Models\City;
use App\Models\OutletImage;
use Symfony\Component\HttpFoundation\Response;
use App\Traits\OutletTrait;
use App\Traits\ProductTrait;
use Illuminate\Support\Arr;
use App\Models\Outlet;
use App\Traits\HasAuthUser;
use Illuminate\Support\Facades\DB;
use Illuminate\Database\Eloquent\Builder;

class OutletController extends Controller
{
    use OutletTrait, ProductTrait, HasAuthUser;

    public function index(Request $request)
    {
        // $page = $request->input('page', 1);
        // $size = $request->input('size', 10);
        $user = $this->getAuthUser();
        $outlets = Outlet::query()->approved()->where('user_id', $user->id);

        $outlets = $outlets->where(function (Builder $builder) use ($request) {
            $keyword = $request->input('keyword');
            if ($keyword) {
                $builder->where('name', 'like', '%' . $keyword . '%');
            }
        });

        $outlets = $outlets->get();
        return new RoutingCollection($outlets);
    }

    public function forms(Request $request)
    {
        $data = OutletForm::select('id', 'question', 'type')->get();
        return response()->json($data);
    }


    public function createOutletWithForms(CreateNOOWithFormsRequest $request)
    {
        if ($this->isNotAuthenticated()) {
            return $this->failedResponse(
                'Unauthorized: User not found',
                Response::HTTP_UNAUTHORIZED
            );
        }

        DB::beginTransaction();
        try {
            // Create outlet
            $data = Arr::except($request->validated(), ['city', 'img_front', 'img_banner', 'img_main_road', 'forms']);
            $outlet = new Outlet($data);
            $outlet->user_id = $this->getAuthUserId();
            $outlet->status = 'PENDING';

            // Handle city
            $city = City::whereName($request->city)->first();
            if (!$city) {
                return $this->failedResponse(OutletConstants::CITY_NOT_FOUND, Response::HTTP_NOT_FOUND);
            }
            $outlet->city_id = $city->id;
            $outlet->save();

            // Handle images
            $images = ['img_front', 'img_banner', 'img_main_road'];
            foreach ($images as $key => $image) {
                if ($request->hasFile($image)) {
                    $file = $request->file($image);
                    $media = saveFile($file, "outlets/$outlet->id");
                    OutletImage::create([
                        'outlet_id' => $outlet->id,
                        'position' => $key + 1,
                        'filename' => $media['filename'],
                        'path' => $media['path']
                    ]);
                }
            }

            // Handle form answers
            if ($request->has('forms')) {
                $forms = $request->forms;
                if (is_string($forms)) {
                    $forms = json_decode($forms, true);
                }

                foreach ($forms as $form) {
                    OutletFormAnswer::create([
                        'outlet_id' => $outlet->id,
                        'outlet_form_id' => $form['id'],
                        'answer' => $form['answer']
                    ]);
                }
            }

            DB::commit();
            return $this->successResponse(
                OutletConstants::CREATE,
                Response::HTTP_OK,
                new OutletResource($outlet)
            );
        } catch (\Exception $e) {
            DB::rollBack();
            return $this->failedResponse(
                'Failed to create outlet: ' . $e->getMessage(),
                Response::HTTP_INTERNAL_SERVER_ERROR
            );
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function requestNOO(CreateNOORequest $request)
    {
        $data = Arr::except($request->validated(), ['city', 'img_front', 'img_banner', 'img_main_road']);
        $outlet = new Outlet($data);
        $outlet->user_id = $this->getAuthUserId();
        $outlet->status = 'PENDING';

        $city = City::whereName($request->city)->first();
        if (!$city) {
            $this->failedResponse(OutletConstants::CITY_NOT_FOUND, Response::HTTP_NOT_FOUND);
        }
        $outlet->city_id = $city->id;
        $outlet->save();

        $images = ['img_front', 'img_banner', 'img_main_road'];
        foreach ($images as $key => $image) {
            if ($request->hasFile($image)) {
                $file = $request->file($image);
                $media = saveFile($file, "outlets/$outlet->id");
                OutletImage::create([
                    'outlet_id' => $outlet->id,
                    'position' => $key + 1,
                    'filename' => $media['filename'],
                    'path' => $media['path']
                ]);
            }
        }


        return $this->successResponse(OutletConstants::CREATE, Response::HTTP_OK, new OutletResource($outlet));
    }

    public function storeFormAnswer(CreateOutletFormAnswerRequest $request)
    {
        $data = $request->validated();

        foreach ($data['forms'] as $form) {
            OutletFormAnswer::create([
                'outlet_id' => $data['outlet_id'],
                'outlet_form_id' => $form['id'],
                'answer' => $form['answer']
            ]);
        }
        return $this->successResponse(OutletConstants::INSERT_FORM, Response::HTTP_OK);
    }
    public function getCityList()
    {
        $cities = City::select('id', 'name')->get();
        return $this->successResponse(OutletConstants::GET_CITY_LIST, Response::HTTP_OK, $cities);
    }
}
