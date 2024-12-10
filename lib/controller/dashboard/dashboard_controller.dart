import 'package:cetapil_mobile/api/api.dart';
import 'package:cetapil_mobile/database/dashboard.dart';
import 'package:cetapil_mobile/model/dashboard.dart';
import 'package:cetapil_mobile/page/login.dart';
import 'package:cetapil_mobile/widget/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../database/database_instance.dart';
import '../../widget/calendar_dialog.dart';
import '../activity/activity_controller.dart';
import '../activity/tambah_activity_controller.dart';
import '../activity/tambah_availibility_controller.dart';
import '../activity/tambah_visibility_controller.dart';
import '../bottom_nav_controller.dart';
import '../outlet/outlet_controller.dart';
import '../routing/routing_controller.dart';
import '../routing/tambah_routing_controller.dart';
import '../selling/selling_controller.dart';
import '../selling/tambah_produk_selling_controller.dart';
import '../support_data_controller.dart';
import '../video_controller/video_controller.dart';
import '../login_controller.dart';

class DashboardController extends GetxController {
  final DashboardDatabaseHelper _dbHelper = DashboardDatabaseHelper.instance;
  final DatabaseHelper _db = DatabaseHelper.instance;
  final LoginController _loginController = Get.find<LoginController>();

  // Observable states
  final RxInt currentIndex = 0.obs;
  final Rx<DateTime> currentDate = DateTime.now().obs;
  final RxBool isLoading = false.obs;
  final Rxn<Dashboard> dashboard = Rxn<Dashboard>();
  final Rxn<String> error = Rxn<String>();

  // User data observables
  final RxString username = "".obs;
  final RxString phoneNumber = "".obs;
  final RxString role = "".obs;
  final RxString longLat = "".obs;

  // New observables for location data
  final RxString currentOutletName = "".obs;
  final RxString checkInTime = "".obs;
  final RxString outletDistance = "-".obs;

  // Carousel data
  final List<String> imageUrls = [
    'assets/carousel1.png',
    'assets/carousel1.png',
    'assets/carousel1.png',
    'assets/carousel1.png',
  ];

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  void _initialize() async {
    initializeDateFormatting('id_ID');
    ever(currentDate, (_) {});
    updateDate();
    await initializeDashboard();
    await getUserData();
  }

  Future<void> getUserData() async {
    try {
      final user = _loginController.currentUser.value;
      if (user != null) {
        username.value = user.name ?? "";
        phoneNumber.value = user.phoneNumber ?? "";
        final roles = _loginController.userRoles;
        role.value = roles.isNotEmpty ? roles.first : "";
        longLat.value = "${user.longitude ?? ""},${user.latitude ?? ""}";
      } else {
        await _loadUserDataFromStorage();
      }
    } catch (e) {
      print('Error getting user data: $e');
      await _loadUserDataFromStorage();
    }
  }

  Future<void> _loadUserDataFromStorage() async {
    username.value = await storage.read('username') ?? "";
    phoneNumber.value = await storage.read('phone_number') ?? "";
    role.value = await storage.read('role') ?? "";
    longLat.value = await storage.read('long_lat') ?? "";
  }

  Future<void> logOut() async {
    try {
      isLoading.value = true;
      await _db.deleteDatabase();

      // Clear all controllers
      final controllersToDelete = [
        SupportDataController,
        DashboardController,
        BottomNavController,
        OutletController,
        ActivityController,
        RoutingController,
        SellingController,
        TambahActivityController,
        VideoController,
        TambahRoutingController,
        TambahAvailabilityController,
        TambahVisibilityController,
        TambahProdukSellingController,
      ];

      for (final controller in controllersToDelete) {
        Get.delete<dynamic>(force: true, tag: controller.toString());
      }

      await _loginController.logout();

      Get.offAll(() => LoginPage(), binding: BindingsBuilder(() {
        for (final controller in controllersToDelete) {
          Get.lazyPut(() => controller);
        }
      }));
    } catch (e) {
      print('Logout error: $e');
      CustomAlerts.showError(Get.context!, "Error", "Gagal logout: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initializeDashboard() async {
    try {
      final localData = await _dbHelper.getLatestDashboard();
      if (localData != null) {
        dashboard.value = localData;
        _updateCurrentOutletInfo(localData);
      }

      await fetchDashboardData();
    } catch (e) {
      error.value = 'Failed to initialize dashboard: $e';
      print('Error initializing dashboard: $e');
    }
  }

  void _updateCurrentOutletInfo(Dashboard dashboardData) {
    final currentOutlet = dashboardData.data?.currentOutlet;
    if (currentOutlet != null) {
      currentOutletName.value = currentOutlet.name ?? "";
      checkInTime.value = currentOutlet.checkedIn ?? "";

      // Format distance for display
      if (currentOutlet.distanceToOutlet != null) {
        final distance = currentOutlet.distanceToOutlet!;
        if (distance >= 1000) {
          outletDistance.value = "${(distance / 1000).toStringAsFixed(2)} km";
        } else {
          outletDistance.value = "${distance.toStringAsFixed(2)} m";
        }
      } else {
        outletDistance.value = "-";
      }
    } else {
      currentOutletName.value = "";
      checkInTime.value = "";
      outletDistance.value = "-";
    }
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await Api.getDashboard();

      if (response.status == false &&
          response.message?.contains('Sesi anda telah berakhir') == true) {
        await _loginController.handleSessionExpired();
        return;
      }

      await _dbHelper.saveDashboard(response);
      dashboard.value = response;
      _updateCurrentOutletInfo(response);
    } catch (e) {
      error.value = 'Failed to fetch dashboard data: $e';
      print('Error fetching dashboard data: $e');

      if (e.toString().contains('Sesi anda telah berakhir')) {
        await _loginController.handleSessionExpired();
      }
    } finally {
      isLoading.value = false;
    }
  }

  String formatDateTime(String? dateTimeString) {
    if (dateTimeString == null) return '';
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(dateTime);
    } catch (e) {
      print('Error formatting date: $e');
      return dateTimeString;
    }
  }

  Future<void> onRefresh() async {
    try {
      await fetchDashboardData();
    } catch (e) {
      error.value = 'Failed to refresh dashboard: $e';
      print('Error refreshing dashboard: $e');
    }
  }

  void updateDate() {
    Future.delayed(const Duration(seconds: 1), () {
      currentDate.value = DateTime.now();
      updateDate();
    });
  }

  String getIndonesianDay() {
    final day = DateFormat('EEEE', 'id_ID').format(currentDate.value);
    return day[0].toUpperCase() + day.substring(1);
  }

  String getIndonesianMonth() {
    final month = DateFormat('MMMM', 'id_ID').format(currentDate.value);
    return month[0].toUpperCase() + month.substring(1);
  }

  String getFormattedDate() {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(currentDate.value);
  }

  void showCustomCalendarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomCalendarDialog(
        initialDate: DateTime.now(),
        onDateSelected: (date) {
          print('Selected date: ${DateFormat('yyyy-MM-dd').format(date)}');
          Navigator.pop(context);
        },
      ),
    );
  }

  // Power SKU helpers
  List<PowerSkus> getPowerSkus() {
    return dashboard.value?.data?.powerSkus ?? [];
  }

  bool hasPowerSkus() {
    return getPowerSkus().isNotEmpty;
  }

  String getLastUpdateInfo() {
    final performanceUpdate = dashboard.value?.data?.lastPerformanceUpdate;
    final skuUpdate = dashboard.value?.data?.lastPowerSkuUpdate;

    if (performanceUpdate != null && skuUpdate != null) {
      return 'Last updated: $performanceUpdate';
    }
    return '';
  }
}
