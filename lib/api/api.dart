import 'dart:convert';

import 'package:cetapil_mobile/model/list_activity_response.dart';
import 'package:cetapil_mobile/model/list_category_response.dart';
import 'package:cetapil_mobile/model/list_product_response.dart';
import 'package:cetapil_mobile/model/list_routing_response.dart';
import 'package:cetapil_mobile/model/outlet.dart';
import 'package:cetapil_mobile/model/submit_checkin_routing.dart';
import 'package:cetapil_mobile/model/submit_outlet_response.dart';
import 'package:cetapil_mobile/model/survey_question_response.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../model/dashboard.dart';
import '../model/form_outlet_response.dart';
import '../model/get_city_response.dart';
import '../model/login_response.dart';

const String baseUrl = 'https://dev-cetaphil.i-am.host';
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
        throw Exception('Failed to login: ${response.statusCode} ${response.reasonPhrase}');
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
        return data.map((item) => FormOutletResponse.fromJson(item).toJson()).toList();
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

  static Future<SubmitCheckinRouting> submitCheckin(Map<String, String> data) async {
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

  static Future<ListProductResponse> getProductList(Map<dynamic,dynamic> data) async {
    var url = "$baseUrl/api/activity/product";
    var token = await storage.read('token');
    var response = await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      return ListProductResponse.fromJson(jsonDecode(response.body));
    }
    throw "Gagal request data Routing : \n${response.body}";
  }
}
