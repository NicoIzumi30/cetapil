import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/controller/outlet/outlet_controller.dart';
import 'package:cetapil_mobile/controller/routing/routing_controller.dart';
import 'package:cetapil_mobile/controller/routing/tambah_routing_controller.dart';
import 'package:cetapil_mobile/controller/selling/selling_controller.dart';
import 'package:cetapil_mobile/controller/selling/tambah_produk_selling_controller.dart';
import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:cetapil_mobile/controller/video_controller/video_controller.dart';
import 'package:cetapil_mobile/database/dashboard.dart';
import 'package:cetapil_mobile/page/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'controller/activity/activity_controller.dart';
import 'controller/activity/knowledge_controller.dart';
import 'controller/activity/tambah_availibility_controller.dart';
import 'controller/bottom_nav_controller.dart';
import 'controller/connectivity_controller.dart';
import 'controller/dashboard/dashboard_controller.dart';
import 'controller/gps_controller.dart';
import 'controller/login_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    Intl.defaultLocale = 'id';

    // Use parallel initialization for better performance
    await Future.wait([
      DashboardDatabaseHelper.instance.database,
      GetStorage.init(),
      initializeGPS(),
    ]);

    configureApp();
    bool isLoggedIn = await checkLoginStatus(); // Check login status
    if (isLoggedIn) {
      // If logged in, load all controllers
      await initializeControllers(true); // Load all controllers
    } else {
      // If not logged in, load only login related controllers
      await initializeControllers(false); // Load only login related controllers
    }
    runApp(const MyApp());
  } catch (e) {
    print('App Initialization Error: $e');
  }
}

Future<bool> checkLoginStatus() async {
  final token = await GetStorage().read('token');
  return token != null;
}

Future<void> initializeGPS() async {
  try {
    // Check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Handle case where location service is disabled
      print('Location services are disabled.');
      return;
    }

    // Check and request permissions with more detailed handling
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle accordingly
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, handle accordingly
      print('Location permissions are permanently denied');
      return;
    }

    // Optional: Get current position to validate GPS
    Position? position =
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print('Initial GPS Position: $position');
  } catch (e) {
    print('Comprehensive GPS Initialization Error: $e');
  }
}

Future<void> initializeControllers(bool isLoggedIn) async {
  try {
    if (isLoggedIn) {
      // Load all controllers if logged in
      Get.put(LoginController());
      Get.lazyPut(() => ConnectivityController());
      Get.put(GPSLocationController());
      Get.lazyPut(() => BottomNavController());
      Get.lazyPut(() => DashboardController());
      Get.put(OutletController());
      Get.lazyPut(() => ActivityController());
      Get.put(RoutingController());
      Get.lazyPut(() => SellingController());
      Get.lazyPut(() => TambahActivityController());
      Get.lazyPut(() => VideoController());
      Get.lazyPut(() => TambahRoutingController());
      Get.lazyPut(() => TambahAvailabilityController());
      Get.put(SupportDataController());
      Get.lazyPut(() => TambahProdukSellingController());
    } else {
      // Load only login related controllers
      Get.lazyPut(() => LoginController());
      Get.lazyPut(() => ConnectivityController());
      Get.lazyPut(() => KnowledgeController());
    }
  } catch (e) {
    print('Controller Initialization Error: $e');
  }
}

void configureApp() {
  // This will prevent the app from closing when the back button is pressed
  GetPlatform.isAndroid ? Get.addKey(GlobalKey<NavigatorState>()) : null;

  // Override the default back button behavior
  Get.config(
    defaultTransition: Transition.fade,
    defaultPopGesture: false,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // initialBinding: InitialBindings(),
      debugShowCheckedModeBanner: false,
      title: 'Cetaphil App',
      home: const SplashScreen(),
      theme: ThemeData(
        fontFamily: 'PlusJakartaSans',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          // ... other styles
        ),
      ),
      builder: EasyLoading.init(),
      // Consider adding additional GetMaterialApp configurations
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Controllers that should be available throughout the app
    Get.put(LoginController());
    Get.lazyPut(() => ConnectivityController());
    Get.put(GPSLocationController());
    Get.lazyPut(() => BottomNavController());
    Get.lazyPut(() => DashboardController());
    Get.put(OutletController());
    Get.lazyPut(() => ActivityController());
    Get.put(RoutingController());
    Get.lazyPut(() => SellingController());
    Get.lazyPut(() => TambahActivityController());
    Get.lazyPut(() => VideoController());
    Get.lazyPut(() => TambahRoutingController());
    Get.lazyPut(() => TambahAvailabilityController());
    Get.put(SupportDataController());
    Get.lazyPut(() => TambahProdukSellingController());
    // Add other controllers...
  }
}
