import 'package:cetapil_mobile/page/index.dart';
import 'package:cetapil_mobile/widget/glassmorphic_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset('assets/vector.png',width: double.infinity,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          Text(
                            "Selamat Datang di Aplikasi !",
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Color(0xFF054F7B),
                                fontWeight: FontWeight.bold),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black, // Default text color
                                fontSize: 13, // Set font size as per your design
                              ),
                              children: <TextSpan>[
                                TextSpan(text: 'Silahkan Masukkan '),
                                TextSpan(
                                  text: 'User ID ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: 'dan '),
                                TextSpan(
                                  text: 'Kata Sandi ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: 'untuk melanjutkan'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          GlassmorphicTextField(
                            hintText: 'Masukan User ID',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.blue,
                              // size: 22,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GlassmorphicTextField(
                            hintText: 'Masukan Kata Sandi Anda',
                            obscureText: true,
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors.blue,
                              // size: 22,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.visibility_off_outlined,
                                color: Colors.black54,
                                size: 22,
                              ),
                              onPressed: () {
                                // Toggle password visibility
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.off(
                                      () =>  MainPage(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, // Button color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      13), // Rounded corners
                                ),
                                elevation: 5, // Shadow depth
                                shadowColor: Colors.black, // Shadow color
                              ),
                              child: Text(
                                'Masuk',
                                style: TextStyle(
                                  color: Colors.blue[900], // Text color
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold, // Bold text
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 10,),
                Text("Designed by IGNICE - 2024 All Rights Reserved",style: TextStyle(fontSize: 9),)
              ],
            ),
          )
        ],
      ),
    ));
  }
}
