import 'package:cetapil_mobile/page/routing/routing.dart';
import 'package:cetapil_mobile/page/selling/selling.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/bottom_nav_controller.dart';
import '../controller/login_controller.dart';
import '../widget/bottom_navbar.dart';
import '../widget/gps_aware.dart';
import 'activity/activity.dart';
import 'dashboard/dashboard.dart';
import 'outlet/outlet.dart';

class MainPage extends StatelessWidget {
  final BottomNavController controller = Get.find<BottomNavController>();
  final LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool isLoggedIn = await loginController.isLoggedIn();
        if (isLoggedIn) {
          if (controller.selectedIndex.value != 2) {
            // If not on home page, navigate to home
            controller.changeIndex(2);
            return false;
          } else {
            // If on home page, show exit confirmation dialog
            return await showExitConfirmationDialog(context);
          }
        }
        // If not logged in, allow default back button behavior
        return true;
      },
      child: GPSAwareScaffold(
          requiresGPS: true,
          body: SafeArea(
            child: Obx(() {
              switch (controller.selectedIndex.value) {
                case 0:
                  return DashboardPage();
                case 1:
                  return RoutingPage();
                case 2:
                  return OutletPage();
                case 3:
                  return ActivityPage();
                case 4:
                  return SellingPage();
                default:
                  return DashboardPage();
              }
            }),
          ),
          bottomNavigationBar: CustomBottomNavigationBar()),
    );
  }

  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit the app?'),
              actions: <Widget>[
                TextButton(
                  child: Text('No'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
