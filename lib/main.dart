import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/controller/outlet/outlet_controller.dart';
import 'package:cetapil_mobile/controller/routing/routing_controller.dart';
import 'package:cetapil_mobile/controller/selling/selling_controller.dart';
import 'package:cetapil_mobile/controller/video_controller/video_controller.dart';
import 'package:cetapil_mobile/page/splash_screen.dart';
import 'package:cetapil_mobile/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'controller/activity/activity_controller.dart';
import 'controller/bottom_nav_controller.dart';
import 'controller/connectivity_controller.dart';
import 'controller/dashboard/dashboard_controller.dart';
import 'controller/gps_controller.dart';
import 'controller/login_controller.dart';
import 'database/database_instance.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'id';
  await DatabaseHelper.instance.database;
  await GetStorage.init();
  await initializeGPS();
  await initializeControllers();
  configureApp();
  runApp(const MyApp());
}


Future<void> initializeGPS() async {
  try {
    await Geolocator.requestPermission();
  } catch (e) {
    print('Error requesting GPS permission: $e');
  }
}

Future<void> initializeControllers() async {
  Get.put(LoginController());
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
    );
  }
}