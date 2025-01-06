import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_visibility_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../controller/connectivity_controller.dart';
import '../controller/gps_controller.dart';
import '../controller/login_controller.dart';
import '../widget/logo_animation.dart';
import 'index.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final loginController = Get.find<LoginController>();
  String version = '';

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
    _getVersion();
  }

  Future<void> _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = "${packageInfo.version}+${packageInfo.buildNumber}";
    });
  }

  Future<void> _navigateToNextScreen() async {
    bool isLoggedIn = await loginController.isLoggedIn();
    Future.delayed(const Duration(seconds: 3), () {
      Get.put(ConnectivityController(), permanent: true);
      Get.put(GPSLocationController(), permanent: true);

      // Get.put(SupportDataController(), permanent: true);
      Get.offAll(
        () => isLoggedIn ? MainPage() : LoginPage(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // SVG Background
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'POSM APPLICATION',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const EnhancedFadeInImage(
                          imagePath: 'assets/logo2.png',
                          width: 100,
                          height: 100,
                          scaleEffect: true,
                          slideEffect: true,
                          duration: Duration(milliseconds: 1500),
                          curve: Curves.easeIn,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'KARENA KITA BERHAK MILIKI KULIT SEHAT',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Version $version',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Designed by IGNICE - 2024 All Rights Reserved',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}