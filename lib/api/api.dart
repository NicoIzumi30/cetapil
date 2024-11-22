import 'dart:convert';

import 'package:cetapil_mobile/model/list_routing_response.dart';
import 'package:cetapil_mobile/model/outlet.dart';
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
    print(response.body);
    if (response.statusCode == 200) {
      return ListRoutingResponse.fromJson(jsonDecode(response.body));
    }
    throw "Gagal request data Routing : \n${response.body}";
  }

}
