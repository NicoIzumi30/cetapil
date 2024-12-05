import 'dart:convert';

import 'package:cetapil_mobile/model/list_activity_response.dart';
import 'package:cetapil_mobile/model/list_category_response.dart';
import 'package:cetapil_mobile/model/list_channel_response.dart';
import 'package:cetapil_mobile/model/list_knowledge_response.dart';
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
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cetapil_mobile/model/submit_activity_response.dart';
import 'package:cetapil_mobile/model/visibility.dart' as VisibilityModel;

import '../model/dashboard.dart';
import '../model/dropdown_model.dart';
import '../model/form_outlet_response.dart';
import '../model/get_city_response.dart';
import '../model/login_response.dart';

const String baseUrl = 'https://dev-cetaphil.i-am.host';
// const String baseUrl = 'https://c877-36-68-56-36.ngrok-free.app';
final GetStorage storage = GetStorage();

class Api {
  Future<LoginResponse> login(String email, String password) async {
    var uri = Uri.parse('$baseUrl/api/login');
    var request = http.MultipartRequest('POST', uri)
      ..fields['email'] = email
      ..fields['password'] = password;

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(json.decode(response.body));
      } else {
        if (response.statusCode >= 500) {
          throw Exception('Server Error');
        }
        throw Exception(
            'Failed to login: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  static Future<GetCityResponse> getListCity() async {
    try {
      var url = "$baseUrl/api/outlet/cities";
      var token = await storage.read('token');
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return GetCityResponse.fromJson(jsonDecode(response.body));
      }
      throw Exception('Failed to load cities: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to load cities: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getFormOutlet() async {
    try {
      var token = await storage.read('token');
      var url = "$baseUrl/api/outlet/forms";
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse;
        print(data);
        return data
            .map((item) => FormOutletResponse.fromJson(item).toJson())
            .toList();
      }

      throw Exception('Failed to load forms');
    } catch (e) {
      print('API Error: $e');
      rethrow;
    }
  }

  static Future<Dashboard> getDashboard() async {
    var url = "$baseUrl/api/dashboard";
    var token = await storage.read('token');
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return Dashboard.fromJson(jsonDecode(response.body));
    }
    throw "Gagal request data dashboard : \n${response.body}";
  }

  static Future<OutletResponse> getOutletList() async {
    var url = "$baseUrl/api/outlet";
    var token = await storage.read('token');
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return OutletResponse.fromJson(jsonDecode(response.body));
    }
    throw "Gagal request data Outlet : \n${response.body}";
  }

  static Future<ListRoutingResponse> getRoutingList() async {
    var url = "$baseUrl/api/routing";
    var token = await storage.read('token');
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      return ListRoutingResponse.fromJson(jsonDecode(response.body));
    }
    throw "Gagal request data Routing : \n${response.body}";
  }

  static Future<SurveyQuestionResponse> getSurveyQuestion() async {
    var url = "$baseUrl/api/activity/surveys";
    var token = await storage.read('token');
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      return SurveyQuestionResponse.fromJson(jsonDecode(response.body));
    }
    throw "Gagal request data Survey Question : \n${response.body}";
  }

  static Future<SubmitCheckinRouting> submitCheckin(
      Map<String, String> data) async {
    var url = "$baseUrl/api/routing/check_in";
    var token = await storage.read('token');
    var response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'outlet_id': data['outlet_id'],
        'checked_in': data['checked_in'],
      }),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      return SubmitCheckinRouting.fromJson(jsonDecode(response.body));
    }
    throw "Gagal submit checkin : \n${response.body}";
  }

  static Future<SubmitOutletResponse> submitOutlet(
      Map<String, dynamic> data, List<FormOutletResponse> question) async {
    var url = "$baseUrl/api/outlet/forms/create-with-forms";
    var token = await storage.read('token');
    var request = await http.MultipartRequest('post', Uri.parse(url));
    request.headers["Content-type"] = 'application/json';
    request.headers["Authorization"] = 'Bearer $token';

    request.fields["channel_id"] = data["channel_id"];
    request.fields["name"] = data["outletName"];
    request.fields["category"] = data["category"];
    request.fields["city"] = data["city_name"];
    request.fields["visit_day"] = data["visit_day"];
    request.fields["longitude"] = data["longitude"];
    request.fields["latitude"] = data["latitude"];
    request.fields["address"] = data["address"];
    request.fields["cycle"] = data["cycle"];

    ///Form
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

    var response = await request.send();
    var responseJson = await http.Response.fromStream(response);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return SubmitOutletResponse.fromJson(jsonDecode(responseJson.body));
    } else {
      throw "Unable to Submit Outlet";
    }
  }

  static Future<ListActivityResponse> getActivityList() async {
    var url = "$baseUrl/api/activity";
    var token = await storage.read('token');
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      return ListActivityResponse.fromJson(jsonDecode(response.body));
    }
    throw "Gagal request data Routing : \n${response.body}";
  }

  static Future<ListPosmResponse> getItemPOSMList() async {
    var url = "$baseUrl/api/activity/posm";
    var token = await storage.read('token');
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      return ListPosmResponse.fromJson(jsonDecode(response.body));
    }
    throw "Gagal request data POSM : \n${response.body}";
  }

  static Future<ListVisualResponse> getItemVisualList() async {
    var url = "$baseUrl/api/activity/visual";
    var token = await storage.read('token');
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      return ListVisualResponse.fromJson(jsonDecode(response.body));
    }
    throw "Gagal request item Visual : \n${response.body}";
  }

  static Future<ListCategoryResponse> getCategoryList() async {
    var url = "$baseUrl/api/activity/product-categories";
    var token = await storage.read('token');
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      return ListCategoryResponse.fromJson(jsonDecode(response.body));
    }
    throw "Gagal request list Category : \n${response.body}";
  }

  static Future<ListProductSkuResponse> getAllProductSKU() async {
    var url = "$baseUrl/api/activity/get-all-product";
    var token = await storage.read('token');
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      return ListProductSkuResponse.fromJson(jsonDecode(response.body));
    }
    throw "Gagal request all Product SKU : \n${response.body}";
  }

  static Future<ListChannelResponse> getAllChannel() async {
    var url = "$baseUrl/api/activity/channels";
    var token = await storage.read('token');
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      return ListChannelResponse.fromJson(jsonDecode(response.body));
    }
    throw "Gagal request all Channel : \n${response.body}";
  }

  static Future<ListKnowledgeResponse> getknowledge() async {
    var url = "$baseUrl/api/product-knowledge";
    var token = await storage.read('token');
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      return ListKnowledgeResponse.fromJson(jsonDecode(response.body));
    }
    throw "Gagal request all Knowledge : \n${response.body}";
  }

  static Future<ListSellingResponse> getListSelling() async {
    var url = "$baseUrl/api/selling";
    var token = await storage.read('token');
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      return ListSellingResponse.fromJson(jsonDecode(response.body));
    }
    throw "Gagal request all Selling : \n${response.body}";
  }

  static Future<SubmitSellingResponse> submitSelling(
      Map<String, dynamic> data, List<Map<String, dynamic>> productList) async {
    var url = "$baseUrl/api/selling/create";
    var token = await storage.read('token');
    var request = await http.MultipartRequest('post', Uri.parse(url));
    request.headers["Content-type"] = 'application/json';
    request.headers["Authorization"] = 'Bearer $token';

    request.fields["outlet_name"] = data["outlet_name"].toString();
    request.fields["category_outlet"] = data["category_outlet"].toString();
    request.fields["longitude"] = data["longitude"].toString();
    request.fields["latitude"] = data["latitude"].toString();

    for(var i = 0; i < productList.length; i++){
      request.fields["products[$i][id]"] = productList[i]["id"].toString();
      request.fields["products[$i][stock]"] = productList[i]["stock"].toString();
      request.fields["products[$i][selling]"] = productList[i]["selling"].toString();
      request.fields["products[$i][balance]"] = productList[i]["balance"].toString();
      request.fields["products[$i][price]"] = productList[i]["price"].toString();
    }
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      data["image"],
    ));

    var response = await request.send();
    var responseJson = await http.Response.fromStream(response);

    print(response.statusCode);
    if (response.statusCode == 200) {
      return SubmitSellingResponse.fromJson(jsonDecode(responseJson.body));
    } else {
      throw "Unable to Submit Selling";
    }
  }

  static Future<SubmitActivityResponse> submitActivity(
      Map<String, dynamic> data,
      List<Map<String, dynamic>> availabilityList,
      List<Map<String, dynamic>> visibilityList,
      List<Map<String, dynamic>> surveyList,
      List<Map<String, dynamic>> orderList,
      ) async {
    var url = "$baseUrl/api/activity/submit";
    var token = await storage.read('token');
    var request = await http.MultipartRequest('post', Uri.parse(url));
    request.headers["Content-type"] = 'application/json';
    request.headers["Authorization"] = 'Bearer $token';

    ///General Section
    request.fields["sales_activity_id"] = data["sales_activity_id"].toString() ?? "";
    request.fields["outlet_id"] = data["outlet_id"].toString() ?? "";
    request.fields["views_knowledge"] = data["views_knowledge"].toString() ?? "";
    request.fields["time_availability"] = data["time_availability"].toString() ?? "";
    request.fields["time_visibility"] = data["time_visibility"].toString() ?? "";
    request.fields["time_knowledge"] = data["time_knowledge"].toString() ?? "";
    request.fields["time_survey"] = data["time_survey"].toString() ?? "";
    request.fields["time_order"] = data["time_order"].toString() ?? "";
    request.fields["current_time"] = data["current_time"].toString() ?? "";
    request.fields["time_survey"] = data["time_survey"].toString() ?? "";

    /// Availability Section
    for (var i = 0; i < availabilityList.length; i++) {
      request.fields["availability[$i][product_id]"] =
          availabilityList[i]["id"].toString() ?? "";
      request.fields["availability[$i][availability_stock]"] =
          availabilityList[i]["stock"].toString() ?? "";
      request.fields["availability[$i][average_stock]"] =
          availabilityList[i]["av3m"].toString() ?? "";
      request.fields["availability[$i][ideal_stock]"] =
          availabilityList[i]["recommend"].toString() ?? "";
    }

    ///Visibility Section
    for (var i = 0; i < visibilityList.length; i++) {
      request.fields["visibility[$i][visibility_id]"] =
          visibilityList[i]['id'].id.toString() ?? "";
      request.fields["visibility[$i][condition]"] =
          visibilityList[i]['condition'].toString() ?? "";
      request.files.add(await http.MultipartFile.fromPath(
        'visibility[$i][file1]',
        visibilityList[i]['image1'].path,
      ));
      request.files.add(await http.MultipartFile.fromPath(
        'visibility[$i][file2]',
        visibilityList[i]['image2'].path,
      ));
    }

    ///Survey Section
    for (var i = 0; i < surveyList.length; i++) {
      request.fields["survey[$i][survey_question_id]"] =
          surveyList[i]["survey_question_id"].toString() ?? "";
      request.fields["survey[$i][answer]"] = surveyList[i]["answer"].toString() ?? "";
    }

    ///Order Section
    for (var i = 0; i < orderList.length; i++) {
      request.fields["order[$i][product_id]"] =
          orderList[i]["id"].toString() ?? "";
      request.fields["order[$i][total_items]"] =
          orderList[i]["jumlah"].toString() ?? "";
      request.fields["order[$i][subtotal]"] =
          orderList[i]["harga"].toString() ?? "";
    }

    var response = await request.send();
    var responseJson = await http.Response.fromStream(response);

    print(response.statusCode);
    if (response.statusCode == 200) {
      return SubmitActivityResponse.fromJson(jsonDecode(responseJson.body));
    } else {
      throw "Unable to Submit Activity";
    }
  }
}
