import 'package:cetapil_mobile/page/dashboard/setting_password.dart';
import 'package:cetapil_mobile/utils/colors.dart';
import 'package:cetapil_mobile/widget/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/dashboard/dashboard_controller.dart';
import '../../widget/back_button.dart';
import '../../widget/dialog.dart';
import '../../widget/password_field.dart';
import '../../widget/text_field.dart';

class SettingProfile extends GetView<DashboardController> {
  final DashboardController dashboardController = Get.find<DashboardController>();
  final TextEditingController _controller =
      TextEditingController(text: "Andromeda Phytagoras Silalahi");

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {
                  Navigator.of(context).pop();
                },
                backgroundColor: Colors.white,
                iconColor: Colors.blue,
              ),
              SizedBox(
                height: 20,
              ),
              Text("Profile Pengguna", style: AppTextStyle.titlePage),
              SizedBox(
                height: 20,
              ),
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
              SizedBox(
                height: 15,
              ),
              Text("Area Domisili Pengguna", style: AppTextStyle.titlePage),
              SizedBox(
                height: 15,
              ),
              ModernTextField(
                title: "Longitudes & Latitudes",
                controller: TextEditingController(text: dashboardController.longLat.value),
                enable: false,
              ),
              SizedBox(
                height: 15,
              ),
              // Text("Keamanan Akun", style: AppTextStyle.titlePage),
              // SizedBox(
              //   height: 15,
              // ),
              // PasswordFieldWithButton(
              //   controller: _controller,
              //   onButtonPressed: () {
              //     Get.to(
              //       SettingPassword()
              //     );
              //   },
              // ),
              // SizedBox(
              //   height: 15,
              // ),
             ButtonPrimary(
                 tipeButton: "danger",
                 ontap: ()=>Alerts.showLogOutDialog(context),
                 title: "Keluar Akun")
            ],
          ),
        )
      ],
    ));
  }
}

