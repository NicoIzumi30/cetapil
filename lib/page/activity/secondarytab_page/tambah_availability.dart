import 'package:cetapil_mobile/page/activity/secondarytab_page/tambah_visibility.dart';
import 'package:cetapil_mobile/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/activity/support_activity_controller.dart';
import '../../../controller/activity/tambah_availibility_controller.dart';
import '../../../model/list_product_sku_response.dart';
import '../../../model/list_category_response.dart' as Category;
import '../../../widget/back_button.dart';

class TambahAvailability extends GetView<TambahAvailabilityController> {
  SupportActivityController supportController = Get.find<SupportActivityController>();

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
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EnhancedBackButton(
                        onPressed: () => Alerts.showConfirmDialog(context),
                        backgroundColor: Colors.white,
                        iconColor: Colors.blue,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: ListView(children: [
                        Obx(() {
                          if (controller.isLoading.value) {
                            return CircularProgressIndicator();
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Kategori",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: DropdownButtonFormField<Category.Data>(
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF0077BD),
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFE8F3FF),
                                    ),
                                    hint: Text(
                                      "-- Pilih Kategori --",
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 14,
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.blue, // Match your theme color
                                    ),
                                    items:
                                    controller.categoryLokal.map((item) {
                                      print("length = ${controller.categoryLokal.length}");
                                      return DropdownMenuItem<Category.Data>(
                                        value: item, // Use the ID as the value
                                        child: Text(item.name ?? ''), // Display the name
                                      );
                                    }).toList(),
                                    onChanged:
                                        (value) {
                                      // if (!controller.selectedItems.contains(value)) {
                                      //   controller.selectedItems.add(value!);
                                      // }
                                    },
                                    isExpanded: true,
                                  ),
                                ),
                              ],
                            );
                          }
                        }),
                            Obx(() {
                              if (controller.isLoading.value) {
                                return CircularProgressIndicator();
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "SKU",
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: DropdownButtonFormField<Data>(
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF0077BD),
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: const Color(0xFFE8F3FF),
                                        ),
                                        hint: Text(
                                          "-- Pilih SKU --",
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 14,
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: Colors.blue, // Match your theme color
                                        ),
                                        items:
                                        controller.produkSkuLocal.map((item) {
                                          return DropdownMenuItem<Data>(
                                            value: item, // Use the ID as the value
                                            child: Text(item.sku ?? ''), // Display the name
                                          );
                                        }).toList(),
                                        onChanged:
                                            (value) {
                                          // if (!controller.selectedItems.contains(value)) {
                                          //   controller.selectedItems.add(value!);
                                          // }
                                        },
                                        isExpanded: true,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }),
                      ]))
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
