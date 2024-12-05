import 'package:cetapil_mobile/controller/routing/routing_controller.dart';
import 'package:cetapil_mobile/model/list_routing_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart' as getstorage;

import '../../utils/colors.dart';
import '../../widget/back_button.dart';
import '../../widget/clipped_maps.dart';
import '../outlet/detail_outlet.dart';

class DetailRouting extends GetView<RoutingController> {
  DetailRouting(
    this.routing, {
    super.key,
  });
  final Data routing;
  final storage = getstorage.GetStorage();

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
                            Text("Detail Routing", style: AppTextStyle.titlePage),
                            SizedBox(
                              height: 20,
                            ),
                            UnderlineTextField.readOnly(
                              title: "Nama Sales",
                              value: username,
                            ),
                            UnderlineTextField.readOnly(
                              title: "Nama Outlet",
                              value: routing.name,
                            ),
                            UnderlineTextField.readOnly(
                              title: "Kategori Outlet",
                              value: routing.category,
                            ),
                            UnderlineTextField.readOnly(
                              title: "Alamat Outlet",
                              value: routing.address,
                              maxlines: 2,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: UnderlineTextField.readOnly(
                                    title: "Latitude",
                                    value: routing.latitude,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: UnderlineTextField.readOnly(
                                    title: "Longitude",
                                    value: routing.longitude,
                                  ),
                                ),
                              ],
                            ),
                            MapPreviewWidget(
                              latitude: double.tryParse(routing!.latitude!) ?? 0,
                              longitude: double.tryParse(routing!.longitude!) ?? 0,
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
                                ClipImage(url: routing.images![0].image!),
                                SizedBox(
                                  width: 8,
                                ),
                                ClipImage(url: routing.images![1].image!),
                                SizedBox(
                                  width: 8,
                                ),
                                ClipImage(url: routing.images![2].image!),
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

                              if (routing.forms!.isEmpty) {
                                return const Center(child: Text("No Form"));
                              }
                              return Column(
                                children: List<Widget>.generate(
                                  routing.forms!.length,
                                  (index) {
                                    final question = routing.forms![index].outletForm!.question;
                                    final answer = routing.forms![index].answer;

                                    return UnderlineTextField.readOnly(
                                      title: question!,
                                      value: answer,
                                    );
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (routing.salesActivity?.checkedIn == null) // Only show if not checked in
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Row(
                    children: [
                      _buildButton(
                        true,
                        "Check-in",
                        () => controller.submitCheckin(routing.id!),
                      ),
                    ],
                  ),
                ),
              ),
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
