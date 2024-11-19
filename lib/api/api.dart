
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/form_outlet_response.dart';
import '../model/login_response.dart';
const String baseUrl = 'https://8a37-103-86-100-201.ngrok-free.app';
class Api{

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

  static Future<FormOutletResponse> getFormOutlet() async {
    var url = "$baseUrl/api/outlet/forms";
    // var token = await storage.read('token');
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        // 'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return FormOutletResponse.fromJson(jsonDecode(response.body));
    }
    throw "Gagal request form outlet:\n${response.body}";
  }
}