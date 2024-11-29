import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/tambah_visibility.dart';
import 'package:cetapil_mobile/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controller/activity/tambah_availibility_controller.dart';
import '../../../model/list_product_sku_response.dart';
import '../../../model/list_category_response.dart' as Category;
import '../../../utils/colors.dart';
import '../../../widget/back_button.dart';

class TambahAvailability extends GetView<TambahAvailabilityController> {
  TambahActivityController activityController =
      Get.find<TambahActivityController>();
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
                        child: ListView(
                          children: [
                            // Category Dropdown
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Kategori",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 10),
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
                                  child: Obx(() {
                                    final categories = controller
                                        .supportDataController
                                        .getCategories();
                                    return DropdownButtonFormField<String>(
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF0077BD),
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                      value: controller.selectedCategory.value,
                                      items: categories.map((category) {
                                        return DropdownMenuItem<String>(
                                          value: category['id'].toString(),
                                          child: Text(category['name'] ?? ''),
                                        );
                                      }).toList(),
                                      onChanged: controller.onCategorySelected,
                                      isExpanded: true,
                                    );
                                  }),
                                ),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "SKU",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 10),
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
                                  child: Obx(() {
                                    final skus = controller.filteredSkus;
                                    return DropdownButtonFormField<
                                        Map<String, dynamic>>(
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF0077BD),
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor:
                                            controller.selectedCategory.value !=
                                                    null
                                                ? const Color(0xFFE8F3FF)
                                                : Colors.grey[200],
                                      ),
                                      hint: Text(
                                        "-- Pilih SKU --",
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                      ),
                                      // value: controller.selectedSku.value,
                                      items: skus.map((sku) {
                                        return DropdownMenuItem<
                                            Map<String, dynamic>>(
                                          value: sku,
                                          child: Text(sku['sku'] ?? ''),
                                        );
                                      }).toList(),
                                      onChanged:
                                          controller.selectedCategory.value !=
                                                  null
                                              ? controller.onSkuSelected
                                              : null,
                                      isExpanded: true,
                                    );
                                  }),
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Obx(() => Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children:
                                        controller.groupSelectedSku.map((item) {
                                      return InputChip(
                                        label: Text(item['sku']),
                                        onDeleted: () => controller.removeItem(item['sku']),
                                      );
                                    }).toList(),
                                  )),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            (controller.groupSelectedSku.isNotEmpty)
                            ? Obx(() {
                              return Column(
                                children: [
                                  Text(controller.selectedCategory.value!,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF023B5E))),
                                  Wrap(
                                    spacing: 8, // Space between widgets
                                    runSpacing: 8, // Space between rows
                                    children: controller.groupSelectedSku.map((sku) {
                                      return SumAmountProduct(
                                        productName: sku['sku'],
                                        stockController: TextEditingController(),
                                        AV3MController: TextEditingController(),
                                        recommendController: TextEditingController(),
                                      );
                                    }).toList(), // Convert the iterable to a list for the children property
                                  ),
                                ],
                              );
                            })
                            : SizedBox()

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: AppColors.primary),
                        ),
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        " Tambah Item",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SumAmountProduct extends StatelessWidget {
  final String productName;
  final TextEditingController stockController;
  final TextEditingController AV3MController;
  final TextEditingController recommendController;

  const SumAmountProduct({
    super.key,
    required this.productName,
    required this.stockController,
    required this.AV3MController,
    required this.recommendController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Stock On Hand",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    productName,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              )),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  "Stock",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                NumberField(
                  controller: stockController,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  "AV3M(Pcs)",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                NumberField(
                  controller: AV3MController,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  "Recommend",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                NumberField(
                  controller: recommendController,
                ),
              ],
            ),
          ),
        ]),
      ],
    );
  }
}

class NumberField extends StatelessWidget {
  final TextEditingController controller;

  const NumberField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF0077BD),
        ),
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
        ],
        decoration: InputDecoration(
          // hintText: widget.title,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 3,
            vertical: 3,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFF64B5F6),
              width: 2,
            ),
          ),
          filled: true,
          fillColor: const Color(0xFFE8F3FF),
          // Light blue background
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
    );
  }
}
