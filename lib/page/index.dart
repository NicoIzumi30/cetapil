import 'package:cetapil_mobile/model/auth_check_response.dart';
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
    if (!Get.isRegistered<BottomNavController>()) {
      Get.put(BottomNavController(), permanent: true);
    }
  }

  // Define the order of menu items and their corresponding pages
  final Map<String, Widget> menuOrder = {
    'dashboard': DashboardPage(), // Always available
    'menu_outlet': OutletPage(),
    'menu_routing': RoutingPage(),
    'menu_activity': ActivityPage(),
    'menu_selling': SellingPage(),
  };

  Widget _getPageForIndex(int index, List<Permission> permissions) {
    // Dashboard is always the first item
    if (index == 0) return menuOrder['dashboard']!;

    // Get available menu items based on permissions
    final availableMenus =
        permissions.map((p) => p.name).where((name) => menuOrder.containsKey(name)).toList();

    // If index is within available menus range, show corresponding page
    if (index - 1 < availableMenus.length) {
      return menuOrder[availableMenus[index - 1]] ?? DashboardPage();
    }

    return DashboardPage(); // Fallback to dashboard
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavController = Get.find<BottomNavController>();

    return WillPopScope(
      onWillPop: () async {
        bool isLoggedIn = await loginController.isLoggedIn();
        if (isLoggedIn) {
          if (bottomNavController.selectedIndex.value != 0) {
            // If not on dashboard, navigate to dashboard
            bottomNavController.changeIndex(0);
            return false;
          } else {
            return await showExitConfirmationDialog(context);
          }
        }
        return true;
      },
      child: GPSAwareScaffold(
        requiresGPS: true,
        body: SafeArea(
          child: Obx(() {
            final user = loginController.currentUser.value;
            final permissions = user?.permissions ?? [];

            return _getPageForIndex(
              bottomNavController.selectedIndex.value,
              permissions,
            );
          }),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          permissions: loginController.currentUser.value?.permissions ?? [],
        ),
      ),
    );
  }

  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
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
