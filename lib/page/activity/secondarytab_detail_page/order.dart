import 'package:cetapil_mobile/controller/activity/detail_activity_controller.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_detail_page/detail_item_availability.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controller/activity/tambah_availibility_controller.dart';
import '../../selling/tambah_selling.dart';

class DetailOrderPage extends GetView<DetailActivityController> {
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final groupedItems = <String, List<Map<String, dynamic>>>{};
          for (var item in controller.availabilityDetailItems) {
            final category = item['category'];
            if (groupedItems[category] == null) {
              groupedItems[category] = [];
            }
            groupedItems[category]!.add(item);
          }

          return Column(
            children: [
              ...groupedItems.entries.map((entry) {
                final category = entry.key;
                final items = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: CollapsibleCategoryGroup(
                    category: category,
                    items: items,
                    isEdit: false,
                  ),
                );
              }).toList(),
            ],
          );
        }),
        SizedBox(height: 20),
      ],
    );
  }
}

class SumAmountProduct extends StatelessWidget {
  final String productName;
  final TextEditingController stockController;
  final TextEditingController AV3MController;
  final TextEditingController recommendController;
  final bool isReadOnly;
  final Map<String, dynamic> itemData;

  const SumAmountProduct({
    super.key,
    required this.productName,
    required this.stockController,
    required this.AV3MController,
    required this.recommendController,
    required this.itemData,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFFEDF8FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Stock On Hand",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF023B5E),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        productName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (!Get.isRegistered<TambahAvailabilityController>()) {
                          Get.put(TambahAvailabilityController());
                        }
                        // final controller = Get.find<TambahAvailabilityController>();

                        // Pre-fill the form data
                        // controller.editItem(itemData);

                        // Navigate to edit screen
                        await Get.to(() => DetailItemAvailability(itemData));
                      },
                      icon: Icon(Icons.visibility, color: Colors.blue, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      tooltip: 'Edit Product',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                _buildDetailField("Stock", stockController),
                SizedBox(width: 12),
                _buildDetailField("AV3M(Pcs)", AV3MController),
                SizedBox(width: 12),
                _buildDetailField("Recommend", recommendController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailField(String label, TextEditingController controller) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
          SizedBox(height: 4),
          NumberField(
            controller: controller,
            readOnly: isReadOnly,
          ),
        ],
      ),
    );
  }
}

class NumberField extends StatelessWidget {
  final TextEditingController controller;
  final bool readOnly;

  const NumberField({
    super.key,
    required this.controller,
    this.readOnly = false,
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
        readOnly: readOnly,
        style: TextStyle(
          fontSize: 14,
          color: readOnly ? Colors.grey : Color(0xFF0077BD),
        ),
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 3,
            vertical: 3,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Color(0xFF64B5F6),
              width: 2,
            ),
          ),
          filled: true,
          fillColor: readOnly ? Colors.grey[100] : Color(0xFFE8F3FF),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: readOnly ? Colors.grey[300]! : Color(0xFF64B5F6),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
