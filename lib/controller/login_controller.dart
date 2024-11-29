


import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cetapil_mobile/model/login_response.dart' as LoginModel;

import '../api/api.dart';
import '../model/login_response.dart';
import '../page/index.dart';
import 'connectivity_controller.dart';

class LoginController extends GetxController {
  final GetStorage _storage = GetStorage();
  final Api _api = Api();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<bool> isLoggedIn() async {
    final token = await _storage.read('token');
    return token != null;
  }

  Rx<LoginModel.LoginResponse?> loginResponse = Rx<LoginModel.LoginResponse?>(null);

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    // await Future.delayed(Duration(seconds: 1));

    try {
      final response = await _api.login(email, password);
      loginResponse.value = response;
      // EasyLoading.show();
      if (response.status == true && response.data != null) {
        // Save user data and token
        await _saveUserData(response.data!);

        // Show loading indicator

        // await resetDataOnLogin();
        // // After successful login, check attendance
        // await checkAttendanceAfterLogin();

        // // Simulate a delay (remove this in production)
        // await Future.delayed(Duration(seconds: 1));

        // Navigate to MainPage
        // EasyLoading.dismiss();
        Get.offAll(() => MainPage(), transition: Transition.fade);
      } else {
        errorMessage.value = response.message ?? 'An error occurred';
      }
    } catch (e) {
      print(e);
      if (e == "Server Error") {
        errorMessage.value = 'Server Error mohon kontak support';
      } else {
        if (Get.find<ConnectivityController>().isConnected) {
          if (email.isEmpty || password.isEmpty) {
            errorMessage.value = 'Email & Password tidak boleh kosong';
          } else {
            errorMessage.value = 'Email & Password anda salah';
          }
        } else {
          errorMessage.value = 'Tidak ada koneksi internet';
        }
      }
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> _saveUserData(LoginModel.Data userData) async {
    await _storage.write('user_id', userData.user?.id);
    await _storage.write('token', userData.token);
    await _storage.write('username', userData.user!.name);
  }
}