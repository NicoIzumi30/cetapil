import 'package:cetapil_mobile/widget/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/colors.dart';
import '../../widget/back_button.dart';
import '../../widget/password_field.dart';
import '../../widget/text_field.dart';

class SettingPassword extends StatelessWidget {
  final TextEditingController _controller =
      TextEditingController(text: "Andromeda Phytagoras Silalahi");
  bool isShow = false;

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
              Text("Ubah Kata Sandi", style: AppTextStyle.titlePage),
              SizedBox(
                height: 20,
              ),
              ModernTextField(
                title: "Kata Sandi Lama",
                controller: _controller,
                suffixIcon: true,
              ),
              ModernTextField(
                title: "Kata Sandi Baru",
                controller: _controller,
                suffixIcon: true,
              ),
              ModernTextField(
                title: "Konfirmasi Kata Sandi Baru",
                controller: _controller,
                suffixIcon: true,
              ),

              SizedBox(
                height: 15,
              ),
              ButtonPrimary(
                tipeButton: "danger",
                ontap: (){}, title: "Simpan Perubahan",width: double.infinity,)
            ],
          ),
        )
      ],
    ));
  }
}

