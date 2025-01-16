import 'package:cetapil_mobile/controller/login_controller.dart';
import 'package:cetapil_mobile/model/auth_check_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../controller/bottom_nav_controller.dart';

class CustomBottomNavigationBar extends GetView<BottomNavController> {
  // Map of menu items and their corresponding icons
  final Map<String, String> menuIcons = {
    'dashboard': "assets/icon/Vector.svg",
    'menu_outlet': "assets/icon/Vector2.svg",
    'menu_routing': "assets/icon/Vector1.svg",
    'menu_activity': "assets/icon/Vector3.svg",
    'menu_selling': "assets/icon/Vector4.svg",
  };

  // Map of menu items and their display labels
  final Map<String, String> menuLabels = {
    'dashboard': 'Home',
    'menu_outlet': 'Outlet',
    'menu_routing': 'Routing',
    'menu_activity': 'Activity',
    'menu_selling': 'Selling',
  };

  final List<Permission> permissions;

  CustomBottomNavigationBar({
    Key? key,
    required this.permissions, // Make it required
  }) : super(key: key) {
    if (!Get.isRegistered<BottomNavController>()) {
      Get.put(BottomNavController(), permanent: true);
    }
  }
  List<String> _getAvailableMenus(List<Permission> permissions) {
    // Start with dashboard which is always available
    List<String> menus = ['dashboard'];

    // Add other menus based on permissions
    menus.addAll(permissions
        .where((p) => p.name != null && menuIcons.containsKey(p.name!))
        .map((p) => p.name!)
        .toList());
    return menus;
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavController = Get.find<BottomNavController>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
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
            final permissions = loginController.currentUser.value?.permissions ?? [];
            final availableMenus = _getAvailableMenus(permissions);

            final itemWidth = constraints.maxWidth / availableMenus.length;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                availableMenus.length,
                (index) => _buildNavItem(
                  index,
                  menuLabels[availableMenus[index]] ?? '',
                  Color(0xFF39B5FF),
                  menuIcons[availableMenus[index]] ?? '',
                  itemWidth,
                  bottomNavController,
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildNavItem(int index, String label, Color color, String pathIcon, double itemWidth,
      BottomNavController navController) {
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
                        color:
                            navController.selectedIndex.value == index ? color : Colors.transparent,
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
                        height: navController.selectedIndex.value == index ? 24 : 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                    if (navController.selectedIndex.value != index) ...[
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Color(0xFF054F7B),
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
