import 'dart:async';
import 'dart:convert';

import 'package:cetapil_mobile/model/auth_check_response.dart';
import 'package:cetapil_mobile/model/calendar_response.dart';
import 'package:cetapil_mobile/model/detail_activity_response.dart';
import 'package:cetapil_mobile/model/list_activity_response.dart';
import 'package:cetapil_mobile/model/list_category_response.dart';
import 'package:cetapil_mobile/model/list_channel_response.dart';
import 'package:cetapil_mobile/model/list_knowledge_response.dart';
import 'package:cetapil_mobile/model/list_planogram_response.dart';
import 'package:cetapil_mobile/model/list_posm_response.dart';
import 'package:cetapil_mobile/model/list_product_sku_response.dart';
import 'package:cetapil_mobile/model/list_routing_response.dart';
import 'package:cetapil_mobile/model/list_selling_response.dart';
import 'package:cetapil_mobile/model/list_visual_response.dart';
import 'package:cetapil_mobile/model/outlet.dart';
import 'package:cetapil_mobile/model/submit_checkin_routing.dart';
import 'package:cetapil_mobile/model/submit_outlet_response.dart';
import 'package:cetapil_mobile/model/submit_selling_response.dart';
import 'package:cetapil_mobile/model/survey_question_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cetapil_mobile/model/submit_activity_response.dart';
import 'package:cetapil_mobile/model/visibility.dart' as VisibilityModel;

import '../model/dashboard.dart';
import '../model/dropdown_model.dart';
import '../model/form_outlet_response.dart';
import '../model/get_city_response.dart';
import '../model/login_response.dart';

const String baseUrl = 'https://cetaphil.id';
// const String baseUrl = 'https://c877-36-68-56-36.ngrok-free.app';
final GetStorage storage = GetStorage();

class ApiWrapper {
  static const int timeoutDuration = 120; // 2 minutes
  static final GetStorage storage = GetStorage();

  static Future<T> getWithTimeout<T>({
    required String url,
    required T Function(String body) parser,
  }) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw 'Tidak ada koneksi internet';
      }

      var token = await storage.read('token');
      if (token == null) throw 'Token tidak ditemukan';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: timeoutDuration));

      if (response.statusCode == 200) {
        return parser(response.body);
      } else if (response.statusCode == 401) {
        throw 'Sesi anda telah berakhir. Silakan login kembali';
      } else if (response.statusCode >= 500) {
        throw 'Server Error';
      }
      throw 'Gagal request: ${response.statusCode}';
    } on TimeoutException {
      throw 'Request timeout setelah $timeoutDuration detik';
    } catch (e) {
      throw 'Gagal request: $e';
    }
  }

  static Future<T> postWithTimeout<T>({
    required String url,
    required Map<String, dynamic> body,
    required T Function(String body) parser,
  }) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No internet connection');
      }

      var token = await storage.read('token');
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(body),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: timeoutDuration));

      if (response.statusCode == 200) {
        return parser(response.body);
      }
      throw Exception('Request failed with status: ${response.statusCode}');
    } on TimeoutException {
      throw 'Request timeout setelah $timeoutDuration detik';
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  static Future<T> multipartWithTimeout<T>({
    required String url,
    required Future<http.MultipartRequest> Function() requestBuilder,
    required T Function(String body) parser,
  }) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No internet connection');
      }

      final request = await requestBuilder();
      var token = await storage.read('token');
      request.headers["Authorization"] = 'Bearer $token';

      final streamedResponse = await request.send().timeout(Duration(seconds: timeoutDuration));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return parser(response.body);
      }
      throw Exception('Request failed with status: ${response.statusCode}');
    } on TimeoutException {
      throw 'Request timeout setelah $timeoutDuration detik';
    } catch (e) {
      throw Exception('Request failed: $e');
    }
  }
}

class Api {
  static const String baseUrl = 'https://cetaphil.id';

  static Future<LoginResponse> login(String email, String password) async {
    return ApiWrapper.multipartWithTimeout<LoginResponse>(
      url: '$baseUrl/api/login',
      requestBuilder: () async {
        var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/login'))
          ..fields['email'] = email
          ..fields['password'] = password;
        return request;
      },
      parser: (body) => LoginResponse.fromJson(json.decode(body)),
    );
  }

  static Future<GetCityResponse> getListCity() async {
    return ApiWrapper.getWithTimeout<GetCityResponse>(
      url: "$baseUrl/api/outlet/cities",
      parser: (body) => GetCityResponse.fromJson(jsonDecode(body)),
    );
  }

  static Future<List<Map<String, dynamic>>> getFormOutlet() async {
    return ApiWrapper.getWithTimeout<List<Map<String, dynamic>>>(
      url: "$baseUrl/api/outlet/forms",
      parser: (body) {
        final jsonResponse = json.decode(body);
        final List<dynamic> data = jsonResponse;
        return data.map((item) => FormOutletResponse.fromJson(item).toJson()).toList();
      },
    );
  }

  static Future<Dashboard> getDashboard() async {
    return ApiWrapper.getWithTimeout<Dashboard>(
      url: "$baseUrl/api/dashboard",
      parser: (body) => Dashboard.fromJson(jsonDecode(body)),
    );
  }

  static Future<OutletResponse> getOutletList() async {
    return ApiWrapper.getWithTimeout<OutletResponse>(
      url: "$baseUrl/api/outlet",
      parser: (body) => OutletResponse.fromJson(jsonDecode(body)),
    );
  }

  static Future<ListRoutingResponse> getRoutingList() async {
    return ApiWrapper.getWithTimeout<ListRoutingResponse>(
      url: "$baseUrl/api/routing",
      parser: (body) => ListRoutingResponse.fromJson(jsonDecode(body)),
    );
  }

  static Future<SurveyQuestionResponse> getSurveyQuestion() async {
    return ApiWrapper.getWithTimeout<SurveyQuestionResponse>(
      url: "$baseUrl/api/activity/surveys",
      parser: (body) => SurveyQuestionResponse.fromJson(jsonDecode(body)),
    );
  }

  static Future<SubmitCheckinRouting> submitCheckin(Map<String, String> data) async {
    return ApiWrapper.postWithTimeout<SubmitCheckinRouting>(
      url: "$baseUrl/api/routing/check_in",
      body: {
        'outlet_id': data['outlet_id'],
        'checked_in': data['checked_in'],
        'latitude': data['latitude'],
        'longitude': data['longitude'],
      },
      parser: (body) => SubmitCheckinRouting.fromJson(jsonDecode(body)),
    );
  }

  static Future<SubmitCheckinRouting> cancelActivity(String activityId) async {
    return ApiWrapper.getWithTimeout<SubmitCheckinRouting>(
      url: "$baseUrl/api/activity/$activityId/cancel",
      parser: (body) => SubmitCheckinRouting.fromJson(jsonDecode(body)),
    );
  }

  static Future<SubmitOutletResponse> submitOutlet(
      Map<String, dynamic> data, List<FormOutletResponse> question) async {
    return ApiWrapper.multipartWithTimeout<SubmitOutletResponse>(
      url: "$baseUrl/api/outlet/forms/create-with-forms",
      requestBuilder: () async {
        var request =
            http.MultipartRequest('post', Uri.parse("$baseUrl/api/outlet/forms/create-with-forms"));

        request.fields["channel_id"] = data["channel_id"];
        request.fields["name"] = data["outletName"];
        request.fields["category"] = data["category"];
        request.fields["city"] = data["city_name"];
        request.fields["visit_day"] = data["visit_day"];
        request.fields["longitude"] = data["longitude"];
        request.fields["latitude"] = data["latitude"];
        request.fields["address"] = data["address"];
        request.fields["cycle"] = data["cycle"];

        for (int i = 0; i < question.length; i++) {
          request.fields["forms[$i][id]"] = data["forms[$i][id]"];
          request.fields["forms[$i][answer]"] = data["forms[$i][answer]"];
        }

        request.files.add(await http.MultipartFile.fromPath(
          'img_front',
          data["image_path_1"],
        ));
        request.files.add(await http.MultipartFile.fromPath(
          'img_banner',
          data["image_path_2"],
        ));
        request.files.add(await http.MultipartFile.fromPath(
          'img_main_road',
          data["image_path_3"],
        ));

        return request;
      },
      parser: (body) => SubmitOutletResponse.fromJson(jsonDecode(body)),
    );
  }

  static Future<ListActivityResponse> getActivityList() async {
    return ApiWrapper.getWithTimeout<ListActivityResponse>(
      url: "$baseUrl/api/activity",
      parser: (body) => ListActivityResponse.fromJson(jsonDecode(body)),
    );
  }

  static Future<ListPosmResponse> getItemPOSMList() async {
    return ApiWrapper.getWithTimeout<ListPosmResponse>(
      url: "$baseUrl/api/activity/posm",
      parser: (body) => ListPosmResponse.fromJson(jsonDecode(body)),
    );
  }

  static Future<ListVisualResponse> getItemVisualList() async {
    return ApiWrapper.getWithTimeout<ListVisualResponse>(
      url: "$baseUrl/api/activity/visual",
      parser: (body) => ListVisualResponse.fromJson(jsonDecode(body)),
    );
  }

  static Future<ListCategoryResponse> getCategoryList() async {
    return ApiWrapper.getWithTimeout<ListCategoryResponse>(
      url: "$baseUrl/api/activity/product-categories",
      parser: (body) => ListCategoryResponse.fromJson(jsonDecode(body)),
    );
  }

  static Future<ListProductSkuResponse> getAllProductSKU() async {
    return ApiWrapper.getWithTimeout<ListProductSkuResponse>(
      url: "$baseUrl/api/activity/get-all-product",
      parser: (body) => ListProductSkuResponse.fromJson(jsonDecode(body)),
    );
  }

  static Future<ListChannelResponse> getAllChannel() async {
    return ApiWrapper.getWithTimeout<ListChannelResponse>(
      url: "$baseUrl/api/activity/channels",
      parser: (body) => ListChannelResponse.fromJson(jsonDecode(body)),
    );
  }

  static Future<ListKnowledgeResponse> getknowledge() async {
    return ApiWrapper.getWithTimeout<ListKnowledgeResponse>(
      url: "$baseUrl/api/product-knowledge",
      parser: (body) => ListKnowledgeResponse.fromJson(jsonDecode(body)),
    );
  }

  static Future<ListSellingResponse> getListSelling() async {
    return ApiWrapper.getWithTimeout<ListSellingResponse>(
      url: "$baseUrl/api/selling",
      parser: (body) => ListSellingResponse.fromJson(jsonDecode(body)),
    );
  }

  static Future<DetailActivityResponse> getDetailActivity(String activityId) async {
    return ApiWrapper.getWithTimeout<DetailActivityResponse>(
      url: "$baseUrl/api/activity/$activityId/detail",
      parser: (body) => DetailActivityResponse.fromJson(jsonDecode(body)),
    );
  }

  static Future<CalendarResponse> getCalendarDashboard(int month, int year) async {
    return ApiWrapper.getWithTimeout<CalendarResponse>(
      url: "$baseUrl/api/dashboard/calendar?month=$month&year=$year",
      parser: (body) => CalendarResponse.fromJson(jsonDecode(body)),
    );
  }

  static Future<ListPlanogramResponse> getPlanogramList() async {
    return ApiWrapper.getWithTimeout<ListPlanogramResponse>(
      url: "$baseUrl/api/activity/planogram",
      parser: (body) => ListPlanogramResponse.fromJson(jsonDecode(body)),
    );
  }

  static Future<SubmitActivityResponse> submitActivity(
    Map<String, dynamic> data,
    List<Map<String, dynamic>> availabilityList,
    List<Map<String, dynamic>> visibilityPrimaryList,
    List<Map<String, dynamic>> visibilitySecondaryList,
    List<Map<String, dynamic>> visibilityKompetitorList,
    List<Map<String, dynamic>> surveyList,
    List<Map<String, dynamic>> orderList,
  ) async {
    return ApiWrapper.multipartWithTimeout<SubmitActivityResponse>(
      url: "$baseUrl/api/activity/submit",
      requestBuilder: () async {
        var request = http.MultipartRequest('post', Uri.parse("$baseUrl/api/activity/submit"));

        // General fields
        request.fields["sales_activity_id"] = data["sales_activity_id"].toString();
        request.fields["outlet_id"] = data["outlet_id"].toString();
        request.fields["views_knowledge"] = data["views_knowledge"].toString();
        request.fields["time_availability"] = data["time_availability"].toString();
        request.fields["time_visibility"] = data["time_visibility"].toString();
        request.fields["time_knowledge"] = data["time_knowledge"].toString();
        request.fields["time_survey"] = data["time_survey"].toString();
        request.fields["time_order"] = data["time_order"].toString();
        request.fields["current_time"] = data["current_time"].toString();

        // Availability list
        for (var i = 0; i < availabilityList.length; i++) {
          request.fields["availability[$i][product_id]"] = availabilityList[i]["id"].toString();
          request.fields["availability[$i][stock_on_hand]"] =
              availabilityList[i]["stock_on_hand"].toString();
          request.fields["availability[$i][stock_inventory]"] =
              availabilityList[i]["stock_on_inventory"].toString();
          request.fields["availability[$i][av3m]"] = availabilityList[i]["av3m"].toString();
          request.fields["availability[$i][status]"] =
              _checkStatus(availabilityList[i]["recommend"].toString());
          request.fields["availability[$i][rekomendasi]"] =
              availabilityList[i]["recommend"].toString();
          request.fields["availability[$i][availability]"] =
              availabilityList[i]["availability_exist"] == "true" ? "Y" : "N";
        }

        // Visibility sections
        _addVisibilityFields(
            request, visibilityPrimaryList, visibilitySecondaryList, visibilityKompetitorList);

        // Survey list
        for (var i = 0; i < surveyList.length; i++) {
          request.fields["survey[$i][survey_question_id]"] =
              surveyList[i]["survey_question_id"].toString();
          request.fields["survey[$i][answer]"] = surveyList[i]["answer"].toString();
        }

        // Order list
        for (var i = 0; i < orderList.length; i++) {
          request.fields["order[$i][product_id]"] = orderList[i]["id"]?.toString() ?? '0';
          request.fields["order[$i][total_items]"] = orderList[i]["jumlah"]?.toString() ?? '0';
          request.fields["order[$i][subtotal]"] = orderList[i]["harga"]?.toString() ?? '0';
        }

        return request;
      },
      parser: (body) => SubmitActivityResponse.fromJson(jsonDecode(body)),
    );
  }

  static String _checkStatus(String number) {
    int num = int.parse(number);
    if (num < 0) {
      return "MINUS";
    } else if (num > 0) {
      return "OVER";
    } else {
      return "IDEAL";
    }
  }

  static void _addVisibilityFields(
    http.MultipartRequest request,
    List<Map<String, dynamic>> visibilityPrimaryList,
    List<Map<String, dynamic>> visibilitySecondaryList,
    List<Map<String, dynamic>> visibilityKompetitorList,
  ) async {
    // Primary visibility
    for (var i = 0; i < visibilityPrimaryList.length; i++) {
      request.fields["visibility[$i][category]"] = visibilityPrimaryList[i]['category'].toString();
      request.fields["visibility[$i][type]"] = "PRIMARY";
      request.fields["visibility[$i][position]"] = visibilityPrimaryList[i]['position'].toString();
      request.fields["visibility[$i][posm_type_id]"] =
          visibilityPrimaryList[i]['posm_type_id'].toString();
      request.fields["visibility[$i][visual_type]"] =
          visibilityPrimaryList[i]['visual_type_name'].toString().toUpperCase();
      request.fields["visibility[$i][condition]"] =
          visibilityPrimaryList[i]['condition'].toString().toUpperCase();
      request.fields["visibility[$i][shelf_width]"] =
          visibilityPrimaryList[i]['shelf_width'].toString().toUpperCase();
      request.fields["visibility[$i][shelving]"] =
          visibilityPrimaryList[i]['shelving'].toString().toUpperCase();
      request.files.add(await http.MultipartFile.fromPath(
        'visibility[$i][display_photo]',
        visibilityPrimaryList[i]['image_visibility'].path,
      ));
    }

    // Secondary visibility
    for (var i = 0; i < visibilitySecondaryList.length; i++) {
      request.fields["visibility[${i + 6}][category]"] =
          visibilitySecondaryList[i]['category'].toString();
      request.fields["visibility[${i + 6}][type]"] = "SECONDARY";
      request.fields["visibility[${i + 6}][position]"] =
          visibilitySecondaryList[i]['position'].toString();
      request.fields["visibility[${i + 6}][visual_type]"] =
          visibilitySecondaryList[i]['display_type'].toString().toUpperCase();
      request.fields["visibility[${i + 6}][has_secondary_display]"] =
          visibilitySecondaryList[i]['secondary_exist'].toString() == "true" ? "Y" : "N";
      request.files.add(await http.MultipartFile.fromPath(
        'visibility[${i + 6}][display_photo]',
        visibilitySecondaryList[i]['display_image'].path,
      ));
    }

    // Competitor visibility
    for (var i = 0; i < visibilityKompetitorList.length; i++) {
      request.fields["visibility[${i + 10}][category]"] = "COMPETITOR";
      request.fields["visibility[${i + 10}][type]"] = "COMPETITOR";
      request.fields["visibility[${i + 10}][position]"] =
          visibilityKompetitorList[i]['position'].toString();
      request.fields["visibility[${i + 10}][competitor_brand_name]"] =
          visibilityKompetitorList[i]['brand_name'].toString().toUpperCase();
      request.fields["visibility[${i + 10}][competitor_promo_mechanism]"] =
          visibilityKompetitorList[i]['promo_mechanism'].toString();
      request.fields["visibility[${i + 10}][competitor_promo_start]"] =
          visibilityKompetitorList[i]['promo_periode_start'].toString();
      request.fields["visibility[${i + 10}][competitor_promo_end]"] =
          visibilityKompetitorList[i]['promo_periode_end'].toString();
      request.files.add(await http.MultipartFile.fromPath(
        'visibility[${i + 10}][display_photo]',
        visibilityKompetitorList[i]['program_image1'].path,
      ));
      request.files.add(await http.MultipartFile.fromPath(
        'visibility[${i + 10}][display_photo_2]',
        visibilityKompetitorList[i]['program_image2'].path,
      ));
    }
  }

  static Future<SubmitSellingResponse> submitSelling(
      Map<String, dynamic> data, List<Map<String, dynamic>> productList) async {
    return ApiWrapper.multipartWithTimeout<SubmitSellingResponse>(
      url: "$baseUrl/api/selling/create",
      requestBuilder: () async {
        var request = http.MultipartRequest('post', Uri.parse("$baseUrl/api/selling/create"));

        request.fields["outlet_id"] = data["outlet_id"].toString();
        request.fields["longitude"] = data["longitude"].toString();
        request.fields["latitude"] = data["latitude"].toString();
        request.fields["checked_in"] = data["checked_in"].toString();
        request.fields["checked_out"] = data["checked_out"].toString();
        request.fields["duration"] = data["duration"].toString();

        for (var i = 0; i < productList.length; i++) {
          request.fields["products[$i][id]"] = productList[i]["id"].toString();
          request.fields["products[$i][qty]"] = productList[i]["qty"].toString();
          request.fields["products[$i][price]"] = productList[i]["price"].toString();
        }

        request.files.add(await http.MultipartFile.fromPath(
          'image',
          data["image"],
        ));

        return request;
      },
      parser: (body) => SubmitSellingResponse.fromJson(jsonDecode(body)),
    );
  }

  static Future<AuthCheckResponse> checkAuth() async {
    return ApiWrapper.getWithTimeout<AuthCheckResponse>(
      url: "$baseUrl/api/user",
      parser: (body) {
        final responseData = json.decode(body);
        if (responseData['success'] == false &&
            responseData['message']?.contains('Sesi anda telah berakhir') == true) {
          throw Exception('Sesi anda telah berakhir. Silakan login kembali');
        }
        return AuthCheckResponse.fromJson(responseData);
      },
    );
  }
}
