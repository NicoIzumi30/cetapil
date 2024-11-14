


import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final GetStorage _storage = GetStorage();

  Future<bool> isLoggedIn() async {
    final token = await _storage.read('token');
    return token != null;
  }
}