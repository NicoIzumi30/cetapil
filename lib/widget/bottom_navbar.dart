import 'package:cetapil_mobile/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../controller/bottom_nav_controller.dart';

class CustomBottomNavigationBar extends GetView<BottomNavController> {
  CustomBottomNavigationBar() {
    // Check and initialize BottomNavController if not registered
    if (!Get.isRegistered<BottomNavController>()) {
      Get.put(BottomNavController(), permanent: true);
    }
  }
  @override
  Widget build(BuildContext context) {
    final bottomNavController = Get.find<BottomNavController>();
    // Get screen width to make responsive calculations
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04, // Responsive margin
        vertical: 12,
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Obx(() {
            final loginController = Get.find<LoginController>();
            final user = loginController.currentUser.value;
            final permissions = user?.permissions ?? [];

            // Calculate item width including the home button (+1)
            final itemWidth = constraints.maxWidth / (permissions.length + 1);

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home is always shown
                _buildNavItem(0, 'Home', Color(0xFF39B5FF), "assets/icon/Vector.svg", itemWidth,bottomNavController),

                // Outlet
                if (permissions.any((p) => p.name?.trim().toLowerCase() == 'menu_outlet'))
                  _buildNavItem(
                      1, 'Outlet', Color(0xFF39B5FF), "assets/icon/Vector2.svg", itemWidth,bottomNavController),

                // Routing
                if (permissions.any((p) => p.name?.trim().toLowerCase() == 'menu_routing'))
                  _buildNavItem(
                      2, 'Routing', Color(0xFF39B5FF), "assets/icon/Vector1.svg", itemWidth,bottomNavController),

                // Activity
                if (permissions.any((p) => p.name?.trim().toLowerCase() == 'menu_activity'))
                  _buildNavItem(
                      3, 'Activity', Color(0xFF39B5FF), "assets/icon/Vector3.svg", itemWidth,bottomNavController),

                // Selling
                if (permissions.any((p) => p.name?.trim().toLowerCase() == 'menu_selling'))
                  _buildNavItem(
                      4, 'Selling', Color(0xFF39B5FF), "assets/icon/Vector4.svg", itemWidth,bottomNavController),
              ],
            );
          });
        },
      ),
    );
  }

  Widget _buildNavItem(int index, String label, Color color, String pathIcon, double itemWidth, BottomNavController navController) {
    return Obx(() {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: navController.selectedIndex.value == index ? -8 : 0),
        duration: const Duration(milliseconds: 200),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, value),
            child: GestureDetector(
              onTap: () => navController.changeIndex(index),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: itemWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: navController.selectedIndex.value == index ? color : Colors.transparent,
                        boxShadow: navController.selectedIndex.value == index
                            ? [
                                BoxShadow(
                                  color: color.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: SvgPicture.asset(
                        pathIcon,
                        color: navController.selectedIndex.value == index
                            ? Colors.white
                            : const Color(0xFF054F7B),
                        height: navController .selectedIndex.value == index ? 24 : 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                    if (navController.selectedIndex.value != index) ...[
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          label,
                          style: TextStyle(
                            color: const Color(0xFF054F7B),
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
