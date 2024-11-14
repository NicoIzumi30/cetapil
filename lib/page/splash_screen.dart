import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'login.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to login page after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(
            () => const LoginPage(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 800),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // SVG Background
          SvgPicture.asset(
            'assets/background.svg',
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
                        SvgPicture.asset(
                          'assets/logo.svg',
                          fit: BoxFit.cover,
                          width: 100,
                        ),
                        Image.asset('assets/logo2.png'),
                        // SvgPicture.asset(
                        //   'assets/logo.svg',
                        // ),
                        // AnimatedContainer(
                        //   duration: Duration(milliseconds: 500),
                        //   width: 100,
                        //   child: SvgPicture.asset(
                        //     'assets/logo.svg',
                        //     width: 100,
                        //     height: 30,
                        //   ),
                        // ),
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