<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Constants\SurveyConstants;
use App\Http\Requests\Survey\SaveSurveyRequest;
use App\Http\Resources\Survey\SurveyCollection;
use App\Models\SalesActivity;
use App\Models\SalesSurvey;
use App\Models\SurveyCategory;
use Illuminate\Http\JsonResponse;
use Symfony\Component\HttpFoundation\Response as HTTPCode;

class SurveyController extends Controller
{
    public function index(): SurveyCollection
    {
        $surveys = SurveyCategory::get();
        return new SurveyCollection($surveys);
    }

    public function saveSurvey(SaveSurveyRequest $request): JsonResponse
    {
        $data = $request->validated();
        foreach ($data['surveys'] as $survey) {
            SalesSurvey::create([
                'survey_question_id' => $survey['id'],
                'sales_activity_id' => $survey['sales_activity_id'],
                'answer' => $survey['answer'],
            ]);
        }

        $activity = SalesActivity::findOrFail($data['surveys'][0]['sales_activity_id']);
        $activity->status = 'SUBMITTED';
        $activity->save();

        return $this->successResponse(SurveyConstants::SAVE, HTTPCode::HTTP_OK);
    }
}
