import 'package:cetapil_mobile/page/dashboard/setting_password.dart';
import 'package:cetapil_mobile/utils/colors.dart';
import 'package:cetapil_mobile/widget/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../controller/dashboard/dashboard_controller.dart';
import '../../widget/back_button.dart';
import '../../widget/dialog.dart';
import '../../widget/password_field.dart';
import '../../widget/text_field.dart';

class SettingProfile extends GetView<DashboardController> {
  final DashboardController dashboardController = Get.find<DashboardController>();
  final TextEditingController _controller =
      TextEditingController(text: "Andromeda Phytagoras Silalahi");
  final RxString appVersion = ''.obs;

  void getVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = "${packageInfo.version}+${packageInfo.buildNumber}";
    } catch (e) {
      print("Error getting version: $e");
      appVersion.value = "Version not available";
    }
  }

  @override
  Widget build(BuildContext context) {
    getVersion();
    return SafeArea(
        child: Stack(
      children: [
        Image.asset(
          'assets/background.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EnhancedBackButton(
                onPressed: () => Navigator.of(context).pop(),
                backgroundColor: Colors.white,
                iconColor: Colors.blue,
              ),
              const SizedBox(height: 20),
              Text("Profile Pengguna", style: AppTextStyle.titlePage),
              const SizedBox(height: 20),
              ModernTextField(
                enable: false,
                title: "Nama Pengguna",
                controller: TextEditingController(text: dashboardController.username.value),
              ),
              ModernTextField(
                enable: false,
                title: "Nomor Telepon Pengguna",
                controller: TextEditingController(text: dashboardController.phoneNumber.value),
              ),
              ModernTextField(
                enable: false,
                title: "Jabatan Pengguna",
                controller: TextEditingController(text: dashboardController.role.value),
              ),
              const SizedBox(height: 15),
              Text("Area Domisili Pengguna", style: AppTextStyle.titlePage),
              const SizedBox(height: 15),
              ModernTextField(
                title: "Longitudes & Latitudes",
                controller: TextEditingController(text: dashboardController.longLat.value),
                enable: false,
              ),
              const SizedBox(height: 15),
              ButtonPrimary(
                  tipeButton: "danger",
                  ontap: () => Alerts.showLogOutDialog(context),
                  title: "Keluar Akun"),
              const SizedBox(height: 10),
              const Spacer(),
              Center(
                child: Obx(() => Text(
                      'Version ${appVersion.value}',
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
              ),
              const SizedBox(height: 10),
            ],
          ),
        )
      ],
    ));
  }
}
