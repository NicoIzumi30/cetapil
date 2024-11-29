import 'package:cetapil_mobile/controller/activity/activity_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_availibility_controller.dart';
import 'package:cetapil_mobile/controller/bottom_nav_controller.dart';
import 'package:cetapil_mobile/controller/dashboard/dashboard_controller.dart';
import 'package:cetapil_mobile/controller/gps_controller.dart';
import 'package:cetapil_mobile/controller/outlet/outlet_controller.dart';
import 'package:cetapil_mobile/controller/routing/routing_controller.dart';
import 'package:cetapil_mobile/controller/routing/tambah_routing_controller.dart';
import 'package:cetapil_mobile/controller/selling/selling_controller.dart';
import 'package:cetapil_mobile/controller/selling/tambah_produk_selling_controller.dart';
import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:cetapil_mobile/controller/video_controller/video_controller.dart';
import 'package:cetapil_mobile/page/login.dart';
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

      if (response.status == true && response.data != null) {
        await _saveUserData(response.data!);
        await _initializeControllers(true); // Load all controllers after login
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

  Future<void> _initializeControllers(bool isLoggedIn) async {
    if (isLoggedIn) {
      // Initialize controllers after login
      Get.put(ConnectivityController());
      Get.put(GPSLocationController());
      Get.put(BottomNavController());
      Get.put(DashboardController());
      Get.put(OutletController());
      Get.put(ActivityController());
      Get.put(RoutingController());
      Get.put(SellingController());
      Get.put(TambahActivityController());
      Get.put(VideoController());
      Get.put(TambahRoutingController());
      Get.put(TambahAvailabilityController());
      Get.put(SupportDataController());
      Get.put(TambahProdukSellingController());
    } else {
      // Initialize only the login-related controllers
      Get.put(LoginController());
      Get.lazyPut(() => ConnectivityController());
    }
  }

  Future<void> logout() async {
    await _storage.erase();
    Get.offAll(() => LoginPage());
  }

  Future<void> _saveUserData(LoginModel.Data userData) async {
    await _storage.write('user_id', userData.user?.id);
    await _storage.write('token', userData.token);
    await _storage.write('username', userData.user!.name);
  }
}
