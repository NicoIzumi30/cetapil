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
import 'package:permission_handler/permission_handler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'controller/activity/activity_controller.dart';
import 'controller/bottom_nav_controller.dart';
import 'controller/dashboard/dashboard_controller.dart';
import 'controller/login_controller.dart';
import 'controller/pdf_controller.dart';

/// Application entry point
/// Initializes essential services and launches the app
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // await Upgrader.clearSavedSettings();
  // Request necessary storage permissions
  await [
    Permission.storage,
    Permission.manageExternalStorage,
  ].request();

  try {
    // Set default locale to Indonesian
    Intl.defaultLocale = 'id';

    // Initialize core services in parallel for better performance
    await Future.wait([
      DashboardDatabaseHelper.instance.database, // Local database
      GetStorage.init(), // Local storage
      initializeGPS(), // GPS services
    ]);

    configureApp();
    runApp(const MyApp());
  } catch (e) {
    print('App Initialization Error: $e');
  }
}

/// Checks if user is currently logged in by verifying token existence
/// Returns true if valid token exists, false otherwise
Future<bool> checkLoginStatus() async {
  final token = await GetStorage().read('token');
  return token != null;
}

/// Initializes and validates GPS services
/// Handles permission requests and checks location service status
Future<void> initializeGPS() async {
  try {
    // Verify if device location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    // Handle location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      return;
    }

    // Validate GPS by getting initial position
    Position? position =
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print('Initial GPS Position: $position');
  } catch (e) {
    print('Comprehensive GPS Initialization Error: $e');
  }
}

/// Configures global app settings and behavior
void configureApp() {
  // Android-specific back button handling
  GetPlatform.isAndroid ? Get.addKey(GlobalKey<NavigatorState>()) : null;

  // Configure GetX default behaviors
  Get.config(
    defaultTransition: Transition.fade,
    defaultPopGesture: false,
  );
}

/// Root widget of the application
/// Configures theme, routing, and global app settings
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitialBindings(),
      debugShowCheckedModeBanner: false,
      title: 'Cetaphil App',
      home: SplashScreen(),
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
        ),
      ),
      builder: EasyLoading.init(),
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

/// Handles dependency injection and controller initialization
/// Registers all controllers needed throughout the app lifecycle
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Register controllers with GetX dependency injection
    Get.lazyPut(() => SupportDataController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => BottomNavController());
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => OutletController());
    Get.lazyPut(() => ActivityController());
    Get.lazyPut(() => RoutingController());
    Get.lazyPut(() => SellingController());
    Get.lazyPut(() => VideoController());
    Get.lazyPut(() => PdfController());
    Get.lazyPut(() => TambahRoutingController());
    Get.lazyPut(() => TambahProdukSellingController());
  }
}
