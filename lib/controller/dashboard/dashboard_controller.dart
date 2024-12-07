import 'package:cetapil_mobile/api/api.dart';
import 'package:cetapil_mobile/database/dashboard.dart';
import 'package:cetapil_mobile/model/dashboard.dart';
import 'package:cetapil_mobile/page/login.dart';
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
  final db = DatabaseHelper.instance;
  
  var currentIndex = 0.obs;
  var currentDate = DateTime.now().obs;
  var isLoading = false.obs;
  var dashboard = Rxn<Dashboard>();
  var error = Rxn<String>();
  var username = "".obs;
  var phoneNumber = "".obs;
  var role = "".obs;
  var longLat = "".obs;
  
  final List<String> imageUrls = [
    'assets/carousel1.png',
    'assets/carousel1.png',
    'assets/carousel1.png',
    'assets/carousel1.png',
  ];

  @override
  void onInit() {
    super.onInit();
    initializeDateFormatting('id_ID');
    ever(currentDate, (_) {});
    updateDate();
    initializeDashboard();
    getUserData();
  }

  getUserData()async{
    username.value = await storage.read('username') ?? "";
    phoneNumber.value = await storage.read('phone_number');
    role.value = await storage.read('role');
    longLat.value = await storage.read('long_lat');
  }

  logOut()async{
    await storage.erase();
    // await Get.deleteAll();
    db.deleteDatabase();
    // Get.put(LoginController());
    Get.offAll(()=>LoginPage(),binding:  BindingsBuilder(() {
      // Get.put(ConnectivityController(), permanent: true);
      // Get.put(GPSLocationController(), permanent: true);
      Get.lazyPut(()=>SupportDataController());
      Get.lazyPut(() => DashboardController());
      Get.lazyPut(() => LoginController());
      Get.lazyPut(() => BottomNavController());
      Get.lazyPut(() => OutletController());
      Get.lazyPut(() => ActivityController());
      Get.lazyPut(() => RoutingController());
      Get.lazyPut(() => SellingController());
      Get.lazyPut(() => TambahActivityController());
      Get.lazyPut(() => VideoController());
      Get.lazyPut(() => TambahRoutingController());
      Get.lazyPut(() => TambahAvailabilityController());
      Get.lazyPut(() => TambahVisibilityController());
      Get.lazyPut(() => TambahProdukSellingController());
    }));
  }

  Future<void> initializeDashboard() async {
    try {
      // First try to load from local database
      final localData = await _dbHelper.getLatestDashboard();
      if (localData != null) {
        dashboard.value = localData;
      }
      
      // Then fetch fresh data from API
      await fetchDashboardData();
    } catch (e) {
      error.value = 'Failed to initialize dashboard: $e';
      print('Error initializing dashboard: $e');
    }
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      error.value = null;

      // Fetch data from API
      final response = await Api.getDashboard();
      
      // Save to database
      await _dbHelper.saveDashboard(response);
      
      // Update state
      dashboard.value = response;
    } catch (e) {
      error.value = 'Failed to fetch dashboard data: $e';
      print('Error fetching dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh data when pull-to-refresh is triggered
  Future<void> onRefresh() async {
    try {
      await fetchDashboardData();
    } catch (e) {
      error.value = 'Failed to refresh dashboard: $e';
      print('Error refreshing dashboard: $e');
    }
  }

  void updateDate() {
    // Update date every second
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
}