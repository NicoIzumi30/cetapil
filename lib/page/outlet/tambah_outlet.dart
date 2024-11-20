import 'package:cetapil_mobile/controller/bottom_nav_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/gps_controller.dart';
import '../../controller/outlet/outlet_controller.dart';
import '../../utils/colors.dart';
import '../../widget/back_button.dart';
import '../../widget/clipped_maps.dart';
import '../../widget/text_field.dart';

class TambahOutlet extends GetView<OutletController> {
  final TextEditingController _controller =
  TextEditingController(text: "Andromeda");
  final GPSLocationController gpsController = Get.find<GPSLocationController>();

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
                          CityDropdown(
                              title: "Kabupaten/Kota",
                              controller: controller),
                          ModernTextField(
                            // enable: false,
                            title: "Alamat Outlet",
                            controller: _controller,
                            maxlines: 4,
                          ),
                          Row(
                            children: [
                              Obx(() {
                                return Expanded(
                                  child: ModernTextField(
                                    enable: false,
                                    title: "Longitude",
                                    controller: gpsController.longController
                                        .value,
                                  ),
                                );
                              }),
                              SizedBox(
                                width: 10,
                              ),
                              Obx(() {
                                return Expanded(
                                  child: ModernTextField(
                                    enable: false,
                                    title: "Latitude",
                                    controller: gpsController.latController
                                        .value,
                                  ),
                                );
                              }),
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
                              _buildUploadImage(
                                  "Foto Tampak Depan Outlet", () {}),
                              SizedBox(
                                width: 8,
                              ),
                              _buildUploadImage(
                                  "Foto Banner/Neon Box Outlet", () {}),
                              SizedBox(
                                width: 8,
                              ),
                              _buildUploadImage(
                                  "Foto Patokan Jalan Outlet", () {}),
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
                                controller.forms.length,
                                    (index) {
                                  final question = controller.forms[index];
                                  print("Question ${question.question}");
                                  return ModernTextField(
                                    title: question.question ?? "",
                                    controller: TextEditingController(),
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

class CityDropdown extends StatelessWidget {
  final OutletController controller;
  final String title;

  const CityDropdown({
    super.key,
    required this.controller, required this.title,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 10,
        ),
        DropdownSearch<String>(
          suffixProps: DropdownSuffixProps(
              clearButtonProps: ClearButtonProps()
          ),
          items: (filter, infiniteScrollProps) => controller.getData(),
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFE8F3FF),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF64B5F6),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF64B5F6),
                  width: 1,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF64B5F6),
                  width: 1,
                ),
              ),
            ),
          ),
          popupProps: PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
            cacheItems: true,

          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}


Widget _buildUploadImage(String title, VoidCallback onTap) {
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