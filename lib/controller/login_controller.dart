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

      // Add check and reset databases
      await checkAndResetDatabases();

      final authResponse = await _api.checkAuth();

      if (authResponse.status == "OK" && authResponse.data != null) {
        currentUser.value = authResponse.data;
        await _updateStoredUserData(authResponse.data!);
      } else {
        await handleSessionExpired();
      }
    } catch (e) {
      print('Auth check error: $e');
      if (e.toString().contains('Sesi anda telah berakhir')) {
        await handleSessionExpired();
      } else {
        await logout();
      }
    }
  }

  Future<void> resetControllersState() async {
    try {
      // Reset OutletController state
      if (Get.isRegistered<OutletController>()) {
        final outletController = Get.find<OutletController>();
        outletController.outlets.clear();
        outletController.filteredOutlets.clear();
        // Reset other state variables as needed
      }

      // Reset ActivityController state
      if (Get.isRegistered<ActivityController>()) {
        final activityController = Get.find<ActivityController>();
        activityController.activity.clear();
        await activityController.loadLocalData();
        // Reset other state variables
      }

      // Reset RoutingController state
      if (Get.isRegistered<RoutingController>()) {
        final routingController = Get.find<RoutingController>();
        routingController.routing.clear();
        await routingController.loadLocalData();
        // Reset other state variables
      }

      // Reset SellingController state
      if (Get.isRegistered<SellingController>()) {
        final sellingController = Get.find<SellingController>();
        sellingController.sellingData.clear();
        sellingController.initialize();
        // Reset other state variables
      }

      // Reset SupportDataController state
      if (Get.isRegistered<SupportDataController>()) {
        final supportController = Get.find<SupportDataController>();
        supportController.survey.clear();
        supportController.formOutlet.clear();
        supportController.products.clear();
        supportController.categories.clear();
        supportController.channels.clear();
        supportController.knowledge.clear();
        supportController.posmTypes.clear();
        supportController.visualTypes.clear();
        supportController.planograms.clear();
        supportController.checkAndFetchData();
      }

      print('All controller states reset successfully');
    } catch (e) {
      print('Error resetting controller states: $e');
    }
  }

// Then update your checkAndResetDatabases method:
  Future<void> checkAndResetDatabases() async {
    try {
      final lastResetDate = _storage.read('last_db_reset_date');
      final currentDate = DateTime.now().toLocal();
      final today =
          DateTime(currentDate.year, currentDate.month, currentDate.day).toIso8601String();

      if (lastResetDate == null || lastResetDate != today) {
        print('Resetting databases for new day: $today');

        // 1. Reset controller states
        await resetControllersState();

        // 2. Clean up all databases
        await _clearAllDatabasesData();

        // 3. Update the reset date
        await _storage.write('last_db_reset_date', today);
      }
    } catch (e) {
      print('Error checking/resetting databases: $e');
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
        final currentDate = DateTime.now().toLocal();
        final today =
            DateTime(currentDate.year, currentDate.month, currentDate.day).toIso8601String();
        await _storage.write('last_db_reset_date', today);

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
    try {
      // First initialize main controllers
      Get.put(BottomNavController(), permanent: true);
      Get.put(OutletController(), permanent: true);
      Get.put(ActivityController(), permanent: true);
      Get.put(RoutingController(), permanent: true);
      Get.put(SellingController(), permanent: true);
      Get.put(VideoController(), permanent: true);
      Get.put(PdfController(), permanent: true);
      Get.put(SupportDataController(), permanent: true);

      // Then initialize dependent controllers
      await Future.delayed(
          Duration(milliseconds: 100)); // Brief delay to ensure main controllers are ready

      Get.put(TambahActivityController(), permanent: true);
      Get.put(TambahAvailabilityController(), permanent: true);
      Get.put(TambahVisibilityController(), permanent: true);
      Get.put(TambahOrderController(), permanent: true);
      Get.put(TambahRoutingController(), permanent: true);
      Get.put(TambahProdukSellingController(), permanent: true);

      print('All controllers initialized successfully');
    } catch (e) {
      print('Error initializing controllers: $e');
      throw e;
    }
  }

  void cleanupAuthControllers() {
    try {
      // First, clean up dependent controllers (those that might depend on other controllers)
      final dependentControllers = [
        TambahActivityController,
        TambahAvailabilityController,
        TambahVisibilityController,
        TambahOrderController,
        TambahRoutingController,
        TambahProdukSellingController,
      ];

      // Then clean up main controllers
      final mainControllers = [
        ActivityController,
        RoutingController,
        SellingController,
        OutletController,
        VideoController,
        PdfController,
        SupportDataController,
        DashboardController,
        BottomNavController,
      ];

      // Clean up dependent controllers first
      for (var controllerType in dependentControllers) {
        try {
          if (Get.isRegistered<dynamic>(tag: controllerType.toString())) {
            Get.delete(tag: controllerType.toString(), force: true);
          }
        } catch (e) {
          print('Error cleaning up ${controllerType.toString()}: $e');
        }
      }

      // Then clean up main controllers
      for (var controllerType in mainControllers) {
        try {
          if (Get.isRegistered<dynamic>(tag: controllerType.toString())) {
            Get.delete(tag: controllerType.toString(), force: true);
          }
        } catch (e) {
          print('Error cleaning up ${controllerType.toString()}: $e');
        }
      }

      print('All controllers cleaned up successfully');
    } catch (e) {
      print('Error during controller cleanup: $e');
    }
  }

  Future<void> _initializeAllDatabases() async {
    try {
      // Initialize support database
      try {
        final supportDb = await SupportDatabaseHelper.instance.database;
        // Load initial data if needed
        await supportDb.execute('SELECT 1'); // Test query to ensure database is ready
        print('Support database initialized');
      } catch (e) {
        print('Error initializing support database: $e');
      }

      // Initialize selling database
      try {
        final sellingDb = await SellingDatabaseHelper.instance.database;
        await sellingDb.execute('SELECT 1');
        print('Selling database initialized');
      } catch (e) {
        print('Error initializing selling database: $e');
      }

      // Initialize dashboard database
      try {
        final dashboardDb = await DashboardDatabaseHelper.instance.database;
        await dashboardDb.execute('SELECT 1');
        print('Dashboard database initialized');
      } catch (e) {
        print('Error initializing dashboard database: $e');
      }

      // Initialize activity database
      try {
        final activityDb = await ActivityDatabaseHelper.instance.database;
        await activityDb.execute('SELECT 1');
        print('Activity database initialized');
      } catch (e) {
        print('Error initializing activity database: $e');
      }

      // Initialize main database
      try {
        final mainDb = await DatabaseHelper.instance.database;
        await mainDb.execute('SELECT 1');
        print('Main database initialized');
      } catch (e) {
        print('Error initializing main database: $e');
      }

      print('All databases initialized successfully');

      // Wait a brief moment to ensure all databases are ready
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      print('Error in database initialization: $e');
    }
  }

  Future<void> _clearAllDatabasesData() async {
    try {
      // Clear Support Database tables
      try {
        final supportDb = SupportDatabaseHelper.instance;
        await supportDb.clearAllTables();
        print('Support database tables cleared');
      } catch (e) {
        print('Error clearing support database tables: $e');
      }

      // Clear Selling Database tables
      try {
        final sellingDb = await SellingDatabaseHelper.instance.database;
        await sellingDb.transaction((txn) async {
          await txn.delete('products');
          await txn.delete('selling_data');
          await txn.delete('users');
        });
        print('Selling database tables cleared');
      } catch (e) {
        print('Error clearing selling database tables: $e');
      }

      // Clear Dashboard Database tables
      try {
        final dashboardDb = DashboardDatabaseHelper.instance;
        await dashboardDb.clearDashboard(); // Using existing method
        print('Dashboard database tables cleared');
      } catch (e) {
        print('Error clearing dashboard database tables: $e');
      }

      // Clear Activity Database tables
      try {
        final activityDb = await ActivityDatabaseHelper.instance.database;
        await activityDb.transaction((txn) async {
          await txn.delete('sales_activity');
          await txn.delete('availability');
          await txn.delete('visibility_primary');
          await txn.delete('visibility_secondary');
          await txn.delete('visibility_kompetitor');
          await txn.delete('survey');
          await txn.delete('orders');
        });
        print('Activity database tables cleared');
      } catch (e) {
        print('Error clearing activity database tables: $e');
      }

      // Clear Main Database tables (outlets, routing, etc)
      try {
        final mainDb = await DatabaseHelper.instance.database;
        await mainDb.transaction((txn) async {
          await txn.delete('outlets');
          await txn.delete('outlet_images');
          await txn.delete('outlet_forms');
          await txn.delete('outlet_form_answers');
          await txn.delete('routing');
          await txn.delete('routing_images');
          await txn.delete('routing_form_answers');
          await txn.delete('routing_activities');
          await txn.delete('outlet_activities');
          await txn.delete('sales_activities');
          await txn.delete('activity_av3m_products');
          await txn.delete('activity_visibilities');
        });
        print('Main database tables cleared');
      } catch (e) {
        print('Error clearing main database tables: $e');
      }

      print('All database tables cleared successfully');
    } catch (e) {
      print('Error in database tables cleanup: $e');
    }
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
