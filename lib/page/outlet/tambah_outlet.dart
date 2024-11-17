import 'package:cetapil_mobile/controller/bottom_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/outlet_controller.dart';
import '../../utils/colors.dart';
import '../../widget/back_button.dart';
import '../../widget/clipped_maps.dart';
import '../../widget/text_field.dart';

class TambahOutlet extends GetView<OutletController> {
  final TextEditingController _controller =
  TextEditingController(text: "Andromeda");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(children: [
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
                      Get.back();
                    },
                    backgroundColor: Colors.white,
                    iconColor: Colors.blue,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tambah Outlet", style: AppTextStyle.titlePage),
                          SizedBox(
                            height: 20,
                          ),
                          ModernTextField(
                            title: "Nama Sales",
                            controller: _controller,
                          ),
                          ModernTextField(
                            title: "Nama Outlet",
                            controller: _controller,
                          ),
                          ModernTextField(
                            title: "Kabupaten/Kota",
                            controller: _controller,
                          ),
                          ModernTextField(
                            // enable: false,
                            title: "Alamat Outlet",
                            controller: _controller,
                            maxlines: 4,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ModernTextField(
                                  title: "Longitude",
                                  controller: _controller,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: ModernTextField(
                                  title: "Latitude",
                                  controller: _controller,
                                ),
                              ),
                            ],
                          ),
                          (controller.latitude.value != 0.0 ||
                              controller.longitude.value != 0.0)
                              ? MapPreviewWidget(
                            latitude: -6.2088,
                            longitude: 106.8456,
                            zoom: 14.0,
                            height: 250,
                            borderRadius: 10,
                          )
                              : Container(
                            height: 250,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Foto Outlet",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UploadImage(
                                onTap: () {},
                                title: "Foto Tampak Depan Outlet",
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              UploadImage(
                                onTap: () {},
                                title: "Foto Banner/Neon Box Outlet",
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              UploadImage(
                                onTap: () {},
                                title: "Foto Patokan Jalan Outlet",
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Formulir Survey Outlet",
                              style: AppTextStyle.titlePage),
                          SizedBox(
                            height: 20,
                          ),
                          Obx(() {
                            return Column(
                              children: List<Widget>.generate(
                                controller.questions.length,
                                    (index) {
                                  final question = controller.questions[index];
                                  print("Question ${question.question}");
                                  return ModernTextField(
                                    title: question.question ?? "",
                                    controller: controller.controllers[index],
                                  );
                                },
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  )
                ],
              ))
        ]));
  }
}

class UploadImage extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const UploadImage({
    super.key,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFEDF8FF),
                  border: Border.all(
                    color: Colors.blue,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.file_upload_outlined, color: Colors.blue),
                    Text(
                      "Klik disini untuk unggah",
                      style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    Text(
                      "Ukuran maksimal foto 2MB",
                      style: TextStyle(fontSize: 7, color: Colors.blue),
                    )
                  ],
                ),
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
