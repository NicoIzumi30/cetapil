import 'package:cetapil_mobile/controller/activity/activity_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_availibility_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_order_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_visibility_controller.dart';
import 'package:cetapil_mobile/controller/bottom_nav_controller.dart';
import 'package:cetapil_mobile/controller/dashboard/dashboard_controller.dart';
import 'package:cetapil_mobile/controller/outlet/outlet_controller.dart';
import 'package:cetapil_mobile/controller/pdf_controller.dart';
import 'package:cetapil_mobile/controller/routing/routing_controller.dart';
import 'package:cetapil_mobile/controller/routing/tambah_routing_controller.dart';
import 'package:cetapil_mobile/controller/selling/selling_controller.dart';
import 'package:cetapil_mobile/controller/selling/tambah_produk_selling_controller.dart';
import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:cetapil_mobile/controller/video_controller/video_controller.dart';
import 'package:cetapil_mobile/database/activity_database.dart';
import 'package:cetapil_mobile/database/dashboard.dart';
import 'package:cetapil_mobile/database/database_instance.dart';
import 'package:cetapil_mobile/database/selling_database.dart';
import 'package:cetapil_mobile/database/support_database.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../widget/custom_alert.dart';
import '../api/api.dart';
import '../model/login_response.dart' as LoginModel;
import '../model/auth_check_response.dart';
import '../page/login.dart';
import '../page/index.dart';
import 'connectivity_controller.dart';

class LoginController extends GetxController {
  // Dependencies
  final GetStorage _storage = GetStorage();
  final Api _api = Api();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<LoginModel.LoginResponse?> loginResponse = Rx<LoginModel.LoginResponse?>(null);

  // Auth state
  final Rx<AuthUserData?> currentUser = Rx<AuthUserData?>(null);

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      final token = await _storage.read('token');
      if (token == null) return;

      final authResponse = await _api.checkAuth();

      if (authResponse.status == "OK" && authResponse.data != null) {
        currentUser.value = authResponse.data;
        await _updateStoredUserData(authResponse.data!);
      } else {
        await handleSessionExpired();
      }
    } catch (e) {
      print('Auth check error: $e');
      // Check if the error response indicates session expiration
      if (e.toString().contains('Sesi anda telah berakhir')) {
        await handleSessionExpired();
      } else {
        await logout();
      }
    }
  }

  Future<void> handleSessionExpired() async {
    try {
      // Clear all stored data
      await _storage.erase();
      currentUser.value = null;

      // Show session expired message
      CustomAlerts.showError(
          Get.context!, "Sesi Berakhir", "Sesi anda telah berakhir. Silakan login kembali");

      // Redirect to login page after showing message
      await Future.delayed(const Duration(seconds: 2));
      Get.offAll(() => LoginPage());
    } catch (e) {
      print('Error handling session expiration: $e');
      // Fallback to direct logout if error occurs
      await logout();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (email.isEmpty || password.isEmpty) {
        throw 'Email & Password tidak boleh kosong';
      }

      if (!Get.find<ConnectivityController>().isConnected) {
        throw 'Tidak ada koneksi internet';
      }

      final response = await _api.login(email, password);
      loginResponse.value = response;

      if (response.status == true && response.data != null) {
        await _saveInitialLoginData(response.data!);

        // Validate and get complete user data
        final authResponse = await _api.checkAuth();
        if (authResponse.status == "OK" && authResponse.data != null) {
          currentUser.value = authResponse.data;
          await _updateStoredUserData(authResponse.data!);
          Get.offAll(() => MainPage(), transition: Transition.fade);
        } else {
          throw 'Failed to validate user authentication';
        }

        // Initialize controllers after successful login
        await initializeAuthRequiredControllers();

        Get.offAll(() => MainPage(), transition: Transition.fade);
      } else {
        throw response.message ?? 'An error occurred';
      }
    } catch (e) {
      _handleLoginError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      // 1. Stop any ongoing dashboard fetches first
      if (Get.isRegistered<DashboardController>()) {
        final dashboardController = Get.find<DashboardController>();
        // Cancel any ongoing operations
        dashboardController.cancelOperations();
      }

      // 2. Clear storage and user data before cleaning up controllers
      // This ensures no more API calls can be made
      await _storage.erase();
      currentUser.value = null;

      // 3. Cleanup auth-dependent controllers
      cleanupAuthControllers();

      // 4. Clear all databases
      await _cleanupAllDatabases();

      // 5. Navigate to login
      Get.offAll(() => LoginPage());
    } catch (e) {
      print('Logout error: $e');
      CustomAlerts.showError(Get.context!, "Error", "Failed to logout properly: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void _handleLoginError(dynamic error) {
    String errorMsg;
    if (error == "Server Error") {
      errorMsg = 'Server Error mohon kontak support';
    } else if (!Get.find<ConnectivityController>().isConnected) {
      errorMsg = 'Tidak ada koneksi internet';
    } else {
      errorMsg = error.toString();
    }
    errorMessage.value = errorMsg;
    print('Login error: $errorMsg');
  }

  Future<void> _saveInitialLoginData(LoginModel.Data userData) async {
    await _storage.write('user_id', userData.user?.id);
    await _storage.write('token', userData.token);
    await _storage.write('username', userData.user?.name);
    await _storage.write('role', userData.user?.role);
    await _storage.write('phone_number', userData.user?.phoneNumber);
  }

  Future<void> _updateStoredUserData(AuthUserData userData) async {
    try {
      await _storage.write('user_id', userData.id);
      await _storage.write('email', userData.email);
      await _storage.write('username', userData.name);
      await _storage.write('phone_number', userData.phoneNumber);
      await _storage.write('longitude', userData.longitude);
      await _storage.write('latitude', userData.latitude);

      // Ensure permissions are properly initialized
      currentUser.value = userData;

      if (userData.roles != null) {
        final roles = userData.roles!.map((role) => {'id': role.id, 'name': role.name}).toList();
        await _storage.write('roles', roles);
      }

      if (userData.permissions != null) {
        final permissions = userData.permissions!
            .map((permission) => {'id': permission.id, 'name': permission.name})
            .toList();
        await _storage.write('permissions', permissions);
      }
    } catch (e) {
      print('Error updating user data: $e');
      // Initialize with empty permissions if there's an error
      currentUser.value = AuthUserData(
          id: userData.id,
          email: userData.email,
          name: userData.name,
          phoneNumber: userData.phoneNumber,
          longitude: userData.longitude,
          latitude: userData.latitude,
          roles: [],
          permissions: []);
      throw 'Failed to update user data';
    }
  }

  // Permission checking methods
  bool hasPermission(String permissionName) {
    try {
      if (currentUser.value?.permissions == null) return false;
      return currentUser.value!.permissions!.any((permission) => permission.name == permissionName);
    } catch (e) {
      print('Permission check error: $e');
      return false;
    }
  }

  bool hasRole(String roleName) {
    try {
      if (currentUser.value?.roles == null) return false;
      return currentUser.value!.roles!.any((role) => role.name == roleName);
    } catch (e) {
      print('Role check error: $e');
      return false;
    }
  }

  // Utility methods
  Future<bool> isLoggedIn() async {
    final token = await _storage.read('token');
    if (token == null) return false;

    try {
      final authResponse = await _api.checkAuth();
      return authResponse.status == "OK" && authResponse.data != null;
    } catch (e) {
      print('Login check error: $e');
      return false;
    }
  }

  Future<void> initializeAuthRequiredControllers() async {
    // Main controllers
    Get.lazyPut(() => BottomNavController(), fenix: true);
    Get.lazyPut(() => OutletController(), fenix: true);
    Get.lazyPut(() => ActivityController(), fenix: true);
    Get.lazyPut(() => RoutingController(), fenix: true);
    Get.lazyPut(() => SellingController(), fenix: true);
    Get.lazyPut(() => VideoController(), fenix: true);
    Get.lazyPut(() => PdfController(), fenix: true);
    Get.lazyPut(() => SupportDataController(), fenix: true);

    // Activity related controllers
    Get.lazyPut(() => TambahActivityController(), fenix: true);
    Get.lazyPut(() => TambahAvailabilityController(), fenix: true);
    Get.lazyPut(() => TambahVisibilityController(), fenix: true);
    Get.lazyPut(() => TambahOrderController(), fenix: true);

    // Routing and Selling controllers
    Get.lazyPut(() => TambahRoutingController(), fenix: true);
    Get.lazyPut(() => TambahProdukSellingController(), fenix: true);
  }

  void cleanupAuthControllers() {
    // Main controllers
    Get.delete<DashboardController>(force: true);
    Get.delete<OutletController>(force: true);
    Get.delete<ActivityController>(force: true);
    Get.delete<RoutingController>(force: true);
    Get.delete<SellingController>(force: true);
    Get.delete<VideoController>(force: true);
    Get.delete<PdfController>(force: true);
    Get.delete<SupportDataController>(force: true);

    // Activity related controllers
    Get.delete<TambahActivityController>(force: true);
    Get.delete<TambahAvailabilityController>(force: true);
    Get.delete<TambahVisibilityController>(force: true);
    Get.delete<TambahOrderController>(force: true);

    // Routing and Selling controllers
    Get.delete<TambahRoutingController>(force: true);
    Get.delete<TambahProdukSellingController>(force: true);
  }

  Future<void> _cleanupAllDatabases() async {
    try {
      // Clear Support Database
      try {
        final supportDb = SupportDatabaseHelper.instance;
        await supportDb.clearAllTables();
        await supportDb.close();

        final dbPath = await getDatabasesPath();
        final supportDbPath = join(dbPath, 'data_support.db');
        if (await databaseExists(supportDbPath)) {
          await deleteDatabase(supportDbPath);
        }
      } catch (e) {
        print('Error clearing support database: $e');
      }

      // Clear Selling Database
      try {
        final sellingDb = SellingDatabaseHelper.instance;
        await sellingDb.close();

        final dbPath = await getDatabasesPath();
        final sellingDbPath = join(dbPath, 'selling_database.db');
        if (await databaseExists(sellingDbPath)) {
          await deleteDatabase(sellingDbPath);
        }
      } catch (e) {
        print('Error clearing selling database: $e');
      }

      // Clear Dashboard Database
      try {
        final dashboardDb = DashboardDatabaseHelper.instance;
        await dashboardDb.clearDashboard();
        await dashboardDb.close();

        final dbPath = await getDatabasesPath();
        final dashboardDbPath = join(dbPath, 'dashboard.db');
        if (await databaseExists(dashboardDbPath)) {
          await deleteDatabase(dashboardDbPath);
        }
      } catch (e) {
        print('Error clearing dashboard database: $e');
      }

      // Clear Activity Database
      try {
        final activityDb = ActivityDatabaseHelper.instance;
        await activityDb.close();

        final dbPath = await getDatabasesPath();
        final activityDbPath = join(dbPath, 'sales_activity.db');
        if (await databaseExists(activityDbPath)) {
          await deleteDatabase(activityDbPath);
        }
      } catch (e) {
        print('Error clearing activity database: $e');
      }

      // Clear Main Database (outlets, routing, etc)
      try {
        final mainDb = DatabaseHelper.instance;
        await mainDb.close();

        final dbPath = await getDatabasesPath();
        final mainDbPath = join(dbPath, 'outlet_database.db');
        if (await databaseExists(mainDbPath)) {
          await deleteDatabase(mainDbPath);
        }
      } catch (e) {
        print('Error clearing main database: $e');
      }

      print('All databases cleared successfully');
    } catch (e) {
      print('Error in database cleanup: $e');
    }
  }

  String? get userToken => _storage.read('token');
  String? get userName => currentUser.value?.name;
  List<String> get userPermissions =>
      currentUser.value?.permissions?.map((p) => p.name ?? '').toList() ?? [];
  List<String> get userRoles => currentUser.value?.roles?.map((r) => r.name ?? '').toList() ?? [];
}
