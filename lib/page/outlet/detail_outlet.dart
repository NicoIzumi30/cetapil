import 'dart:io';

import 'package:cetapil_mobile/controller/login_controller.dart';
import 'package:cetapil_mobile/controller/outlet/outlet_controller.dart';
import 'package:cetapil_mobile/model/outlet.dart';
import 'package:cetapil_mobile/utils/image_upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../controller/routing/routing_controller.dart';
import '../../controller/support_data_controller.dart';
import '../../utils/colors.dart';
import '../../widget/back_button.dart';
import '../../widget/clipped_maps.dart';

class DetailOutlet extends GetView<OutletController> {
  RoutingController routingController = Get.find<RoutingController>();
  SupportDataController supportController = Get.find<SupportDataController>();
  DetailOutlet({super.key, required this.isCheckin, required this.outlet});
  final storage = GetStorage();
  final Outlet outlet;
  final bool isCheckin;

  @override
  Widget build(BuildContext context) {
    final username = storage.read('username') ?? '-';
    return SafeArea(
      child: Stack(children: [
        Image.asset(
          'assets/background.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Column(
          children: [
            Expanded(
              child: Padding(
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Detail Outlet", style: AppTextStyle.titlePage),
                            SizedBox(
                              height: 20,
                            ),
                            UnderlineTextField.readOnly(
                              title: "Nama Sales",
                              value: username,
                            ),
                            UnderlineTextField.readOnly(
                              title: "Nama Outlet",
                              value: outlet.name,
                            ),
                            UnderlineTextField.readOnly(
                              title: "Channel Outlet",
                              value: outlet.channel?.name ?? '-',
                            ),
                            UnderlineTextField.readOnly(
                              title: "Kategori Outlet",
                              value: outlet.category,
                            ),
                            UnderlineTextField.readOnly(
                              title: "Alamat Outlet",
                              value: outlet.address,
                              maxlines: 2,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: UnderlineTextField.readOnly(
                                    title: "Latitude",
                                    value: outlet.longitude,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: UnderlineTextField.readOnly(
                                    title: "Longitude",
                                    value: outlet.latitude,
                                  ),
                                ),
                              ],
                            ),
                            MapPreviewWidget(
                              latitude: double.tryParse(outlet.latitude!) ?? 0,
                              longitude: double.tryParse(outlet.longitude!) ?? 0,
                              zoom: 14.0,
                              height: 250,
                              borderRadius: 10,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Foto Outlet",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                ClipImage(url: outlet.images![0].image!),
                                SizedBox(
                                  width: 8,
                                ),
                                ClipImage(url: outlet.images![1].image!),
                                SizedBox(
                                  width: 8,
                                ),
                                ClipImage(url: outlet.images![2].image!),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Formulir Survey Outlet", style: AppTextStyle.titlePage),
                            SizedBox(
                              height: 20,
                            ),
                            Obx(() {
                              if (controller.isLoading.value) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              if (supportController.getFormOutlet().isEmpty) {
                                return const Center(child: Text("No Form"));
                              }
                              return Column(
                                children: List<Widget>.generate(
                                  supportController.getFormOutlet().length,
                                  (index) {
                                    final localQuestion = supportController.getFormOutlet()[index];
                                    String answer = "";

                                    // Method 1: Try to match by index first
                                    if (index < (outlet.forms?.length ?? 0)) {
                                      final apiForm = outlet.forms![index];
                                      if (apiForm.outletForm?.id == localQuestion['id']) {
                                        answer = apiForm.answer ?? "";
                                      }
                                    }

                                    // Method 2: If no match by index, search through all forms
                                    if (answer.isEmpty) {
                                      answer = outlet.forms
                                              ?.firstWhereOrNull((form) =>
                                                  form.outletForm?.id == localQuestion['id'])
                                              ?.answer ??
                                          "";
                                    }

                                    return UnderlineTextField.readOnly(
                                      title: localQuestion['question'],
                                      value: answer,
                                    );
                                  },
                                ),
                              );
                            }),
                            // UnderlineTextField.editable(
                            //     title: "Apakah outlet sudah menjual produk GIH ?",
                            //     controller: _controller),
                            // UnderlineTextField.editable(
                            //     title: "Berapa banyak produk GIH yang sudah terjual ?",
                            //     controller: _controller),
                            // UnderlineTextField.editable(
                            //     title: "Selling out GSC500/week (in pcs)", controller: _controller),
                            // UnderlineTextField.editable(
                            //     title: "Selling out GSC1000/week (in pcs)", controller: _controller),
                            // UnderlineTextField.editable(
                            //     title: "Selling out GSC250/week (in pcs)", controller: _controller),
                            // UnderlineTextField.editable(
                            //     title: "Selling out GSC125/week (in pcs)", controller: _controller),
                            // UnderlineTextField.editable(
                            //     title: "Selling out Oily 125/week (in pcs)", controller: _controller),
                            // UnderlineTextField.editable(
                            //     title: "Selling out wash & shampo 400ml/week (in pcs)",
                            //     controller: _controller),
                            // UnderlineTextField.editable(
                            //     title: "Selling out wash & shampo cal 400ml/week (in pcs)",
                            //     controller: _controller),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Obx(() {
              print(routingController.isRoutingActive(outlet.id!));
              return (isCheckin && !routingController.isRoutingActive(outlet.id!))
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Row(
                            children: [
                              _buildButton(
                                true,
                                "Check-in",
                                () => routingController.submitCheckin(outlet.id!),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox();
            }),
          ],
        ),
      ]),
    );
  }

  Expanded _buildButton(bool isSubmit, String title, VoidCallback onTap) {
    return Expanded(
      child: Container(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSubmit ? AppColors.primary : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: isSubmit ? BorderSide.none : BorderSide(color: AppColors.primary),
            ),
          ),
          onPressed: onTap,
          child: Text(
            title,
            style: TextStyle(
              color: isSubmit ? Colors.white : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ClipImage extends StatelessWidget {
  final String? url;
  final double? size;
  final BoxFit fit;

  const ClipImage({
    super.key,
    this.url,
    this.size,
    this.fit = BoxFit.cover,
  });

  String _sanitizeUrl(String url) {
    return "https://dev-cetaphil.i-am.host${url}";
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: url != null
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageViewerScreen(
                      image: _sanitizeUrl(url!),
                    ),
                  ),
                );
              }
            : null,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.blue,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: url != null
                  ? Image.network(
                      _sanitizeUrl(url!),
                      fit: fit,
                      errorBuilder: _buildErrorWidget,
                    )
                  : _buildErrorWidget(context, null, null),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, Object? error, StackTrace? stackTrace) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, color: Colors.grey[400], size: 24),
          SizedBox(height: 8),
          Text(
            'No Image',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class UnderlineTextField extends StatelessWidget {
  final String title;
  final bool readOnly;
  final String? value;
  final int? maxlines;
  final TextEditingController? controller;

  // Constructor for read-only mode
  const UnderlineTextField.readOnly({
    super.key,
    required this.title,
    required this.value,
    this.maxlines = 1,
  })  : readOnly = true,
        controller = null;

  // Constructor for editable mode
  const UnderlineTextField.editable({
    super.key,
    required this.title,
    required this.controller,
    this.maxlines = 1,
  })  : readOnly = false,
        value = null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: readOnly ? TextEditingController(text: value) : controller,
          maxLines: maxlines,
          readOnly: readOnly,
          style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
