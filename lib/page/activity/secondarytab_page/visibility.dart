import 'dart:io';

import 'package:cetapil_mobile/page/activity/secondarytab_page/tambah_visibility.dart';
import 'package:cetapil_mobile/widget/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/activity/tambah_activity_controller.dart';
import '../../../utils/colors.dart';

class VisibilityPage extends GetView<TambahActivityController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          return Column(
            children: controller.listVisibility.map((data) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0x80FFFFFF),
                    ],
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Jenis Visual :",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          data.typeVisibility!.type!,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Jenis Visibility :",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          data.typeVisual!.type!,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        data.image1!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }),
        // Obx(() {
        //   return ListView.builder(
        //       itemCount: controller.listVisibility.length,
        //       itemBuilder: (context, index) {
        //         final data = controller.listVisibility[index];
        //         return Container(
        //           margin: const EdgeInsets.only(bottom: 16),
        //           padding: const EdgeInsets.all(16),
        //           decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(10),
        //               gradient: LinearGradient(
        //                   begin: Alignment.topCenter,
        //                   end: Alignment.bottomCenter,
        //                   colors: [
        //                     Color(0xFFFFFFFF),
        //                     Color(0x80FFFFFF),
        //                   ])),
        //           child: Row(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //                     Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         Text(
        //                           "Jenis Visual :",
        //                           style: const TextStyle(
        //                             fontSize: 13,
        //                             fontWeight: FontWeight.bold,
        //                           ),
        //                         ),
        //                         Text(
        //                           data.typeVisibility!.type!,
        //                           style: const TextStyle(
        //                             fontSize: 13,
        //                             fontWeight: FontWeight.bold,
        //                           ),
        //                         ),
        //                         const SizedBox(height: 8),
        //                         Text(
        //                           "Jenis Visibility :",
        //                           style: const TextStyle(
        //                             fontSize: 13,
        //                             fontWeight: FontWeight.bold,
        //                           ),
        //                         ),
        //                         Text(
        //                           data.typeVisual!.type!,
        //                           style: const TextStyle(
        //                             fontSize: 13,
        //                             fontWeight: FontWeight.bold,
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //               ClipRRect(
        //                   borderRadius: BorderRadius.circular(10),
        //                   child: Image.file(
        //                     data.image1!,
        //                     width: 120,
        //                     height: 120,
        //                     fit: BoxFit.cover,
        //                   ))
        //             ],
        //           ),
        //         );
        //       });
        // }),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: AppColors.primary),
              ),
            ),
            onPressed: () => Get.to(() => TambahVisibility()),
            child: Text(
              " Tambah Visibility",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
