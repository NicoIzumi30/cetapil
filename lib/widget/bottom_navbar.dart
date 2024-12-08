import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../controller/bottom_nav_controller.dart';

class CustomBottomNavigationBar extends GetView<BottomNavController> {


  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 90,
        margin: const EdgeInsets.all(16),
        padding: EdgeInsets.all(5),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home, 'Home',Color(0xFF39B5FF),"assets/icon/Vector.svg"),
            _buildNavItem(1, Icons.route, 'Routing',Color(0xFF39B5FF),"assets/icon/Vector1.svg"),
            _buildNavItem(2, Icons.store, 'Outlet',Color(0xFF39B5FF),"assets/icon/Vector2.svg"),
            _buildNavItem(3, Icons.assignment, 'Activity',Color(0xFF39B5FF),"assets/icon/Vector3.svg"),
            _buildNavItem(4, Icons.shopping_bag, 'Selling',Color(0xFF39B5FF),"assets/icon/Vector4.svg"),
          ],
        ),
      );
  }



  Widget _buildNavItem(int index, IconData icon, String label, Color color,String pathIcon) {
    return Obx(() {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: controller.selectedIndex.value == index ? -8 : 0),
        duration: const Duration(milliseconds: 200),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, value),
            child: GestureDetector(
              onTap: () async {
                controller.changeIndex(index);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: controller.selectedIndex.value == index ? color : Colors.transparent,
                        boxShadow: controller.selectedIndex.value == index
                            ? [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ]
                            : [],
                      ),
                      child:
                      SvgPicture.asset(pathIcon,
                        color: controller.selectedIndex.value == index
                              ? Colors.white
                              : Color(0xFF054F7B),
                      height: controller.selectedIndex.value == index ? 32 : 24,
                      )
                      // Icon(
                      //   icon,
                      //   color: controller.selectedIndex.value == index
                      //       ? Colors.white
                      //       : Color(0xFF054F7B),
                      //   size: controller.selectedIndex.value == index ? 32 : 24,
                      // ),
                    ),
                    controller.selectedIndex.value == index
                        ? const SizedBox()
                        : const SizedBox(height: 4),
                    controller.selectedIndex.value == index
                        ? const SizedBox()
                        : Text(
                      label,
                      style: TextStyle(
                        color: controller.selectedIndex.value == index ? Colors.white : Color(0xFF054F7B),
                        fontSize: 12,
                        fontWeight: controller.selectedIndex.value == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
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