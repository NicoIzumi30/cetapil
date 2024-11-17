
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/form_outlet_response.dart';
const String baseUrl = 'https://2164-180-254-100-177.ngrok-free.app';
class Api{

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