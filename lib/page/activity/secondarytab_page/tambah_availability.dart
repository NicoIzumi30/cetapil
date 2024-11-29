import 'package:cetapil_mobile/page/activity/secondarytab_page/tambah_visibility.dart';
import 'package:cetapil_mobile/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/activity/tambah_availibility_controller.dart';
import '../../../model/list_product_sku_response.dart';
import '../../../model/list_category_response.dart' as Category;
import '../../../widget/back_button.dart';

class TambahAvailability extends GetView<TambahAvailabilityController> {
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
                        // Category Dropdown
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Kategori",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
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
                                final categories = controller.supportDataController.getCategories();
                                return DropdownButtonFormField<String>(
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

// SKU Dropdown
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "SKU",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
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
                                return DropdownButtonFormField<String>(
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
                                    fillColor: controller.selectedCategory.value != null
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
                                  value: controller.selectedSku.value,
                                  items: skus.map((sku) {
                                    return DropdownMenuItem<String>(
                                      value: sku['id'].toString(),
                                      child: Text(sku['sku'] ?? ''),
                                    );
                                  }).toList(),
                                  onChanged: controller.selectedCategory.value != null
                                      ? controller.onSkuSelected
                                      : null,
                                  isExpanded: true,
                                );
                              }),
                            ),
                          ],
                        ),
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
