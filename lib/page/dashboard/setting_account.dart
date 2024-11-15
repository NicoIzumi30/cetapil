import 'package:cetapil_mobile/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widget/back_button.dart';
import '../../widget/password_field.dart';
import '../../widget/text_field.dart';

class SettingProfile extends StatelessWidget {
  final TextEditingController _controller =
      TextEditingController(text: "Andromeda Phytagoras Silalahi");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: [
        SvgPicture.asset(
          'assets/background.svg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
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
                title: "Nama Pengguna",
                controller: _controller,
              ),
              ModernTextField(
                title: "Nomor Telepon Pengguna",
                controller: _controller,
              ),
              ModernTextField(
                title: "Jabatan Pengguna",
                controller: _controller,
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
                controller: _controller,
                enable: false,
              ),
              SizedBox(
                height: 15,
              ),
              Text("Keamanan Akun", style: AppTextStyle.titlePage),
              SizedBox(
                height: 15,
              ),
              PasswordFieldWithButton(
                controller: _controller,
                onButtonPressed: () {
                  // Handle button press
                },
              ),
              SizedBox(
                height: 15,
              ),
              logoutButton(
                ontap: (){},
              )
            ],
          ),
        )
      ],
    ));
  }
}

class logoutButton extends StatelessWidget {
  final VoidCallback ontap;
  const logoutButton({
    super.key, required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                offset: const Offset(0, 0),
                blurRadius: 6,
              ),
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color(0xFF53A2D2),
            Color(0xFF0077BD),
          ])
        ),
        child: Center(child: Text("Keluar Akun",style: TextStyle(color: Colors.white),)),
      ),
    );
  }
}
