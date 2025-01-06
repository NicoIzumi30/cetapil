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

class MainPage extends GetView<BottomNavController> {
  // final BottomNavController controller = Get.find<BottomNavController>();
  final LoginController loginController = Get.find<LoginController>();

  MainPage() {
    // Ensure BottomNavController is initialized
    if (!Get.isRegistered<BottomNavController>()) {
      Get.put(BottomNavController(), permanent: true);
    }
  }

  final permissionPages = {
    'menu_outlet': OutletPage(),
    'menu_routing': RoutingPage(),
    'menu_activity': ActivityPage(),
    'menu_selling': SellingPage(),
  };

  @override
  Widget build(BuildContext context) {
    final bottomNavController = Get.find<BottomNavController>();
    return WillPopScope(
      onWillPop: () async {
        bool isLoggedIn = await loginController.isLoggedIn();
        if (isLoggedIn) {
          if (bottomNavController.selectedIndex.value != 2) {
            // If not on home page, navigate to home
            bottomNavController.changeIndex(2);
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
            final loginController = Get.find<LoginController>();
            final user = loginController.currentUser.value;
            final permissions = user?.permissions;

            // If no user or permissions, show dashboard
            if (user == null || permissions == null || permissions.isEmpty) {
              return DashboardPage();
            }

            // Determine which page to show based on selected index
            switch (bottomNavController.selectedIndex.value) {
              case 0:
                return DashboardPage(); // Fixed tab
              case 1:
                return permissions.length > 0
                    ? (permissionPages[permissions[0].name] ?? DashboardPage())
                    : DashboardPage();
              case 2:
                return permissions.length > 1
                    ? (permissionPages[permissions[1].name] ?? DashboardPage())
                    : DashboardPage();
              case 3:
                return permissions.length > 2
                    ? (permissionPages[permissions[2].name] ?? DashboardPage())
                    : DashboardPage();
              case 4:
                return permissions.length > 3
                    ? (permissionPages[permissions[3].name] ?? DashboardPage())
                    : DashboardPage();
              default:
                return DashboardPage();
            }
          }),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
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
