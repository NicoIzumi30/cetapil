import 'package:cetapil_mobile/page/activity/secondarytab_page/tambah_availability.dart';
import 'package:cetapil_mobile/widget/category_tag_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controller/activity/tambah_activity_controller.dart';
import '../../../controller/activity/tambah_availibility_controller.dart';
import '../../../controller/support_data_controller.dart';
import '../../../model/list_category_response.dart';
import '../../../utils/colors.dart';
import '../../../widget/searchable_grouped_dropdown.dart';

class AvailabilityPage extends GetView<TambahActivityController> {
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            onPressed: () {
              if (!Get.isRegistered<TambahAvailabilityController>()) {
                Get.put(TambahAvailabilityController());
              }
              final prodController =
              Get.find<TambahAvailabilityController>();
              print(prodController.selectedCategory.value);
              // tambahAvailabilityController.clearForm();
              Get.to(() => TambahAvailability());
            },
            child: Text(
              "Tambah Availability",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Obx(() {
          if (controller.availabilityDraftItems.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Text(
                  "Belum ada produk yang ditambahkan",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }

          final groupedItems = <String, List<Map<String, dynamic>>>{};
          for (var item in controller.availabilityDraftItems) {
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
                    onEdit: () async {
                      // Get the controller
                      if (!Get.isRegistered<
                          TambahAvailabilityController>()) {
                        Get.put(TambahAvailabilityController());
                      }
                      final prodController =
                      Get.find<TambahAvailabilityController>();

                      // Find the category ID from the name
                      final categoryId =
                      prodController.supportDataController
                          .getCategories()
                          .firstWhere(
                            (cat) => cat['name'] == category,
                        orElse: () => {'id': null},
                      )['id']
                          ?.toString();

                      // Set the category and pre-fill the data
                      prodController.selectedCategory.value = categoryId;

                      // Pre-populate the values for all products in this category
                      for (var item in items) {
                        final skuId = item['id'].toString();
                        prodController.productValues[skuId] = {
                          'stock': item['stock'].toString(),
                          'av3m': item['av3m'].toString(),
                          'recommend': item['recommend'].toString(),
                          // 'price': item['price'].toString(),
                        };
                      }

                      // Navigate to edit screen
                      await Get.to(() => const TambahAvailability());
                    },
                    onDelete: () async{
                      if (!Get.isRegistered<
                          TambahAvailabilityController>()) {
                        Get.put(TambahAvailabilityController());
                      }
                      final prodController =
                      Get.find<TambahAvailabilityController>();

                      // Find the category ID from the name
                      final categoryId =
                      prodController.supportDataController
                          .getCategories()
                          .firstWhere(
                            (cat) => cat['name'] == category,
                        orElse: () => {'id': null},
                      )['id']
                          ?.toString();
                    },
                  ),
                );
              }).toList(),
            ],
          );
        }),
        SizedBox(height: 20),
        // Obx(() {
        //   final groupedItemsAvailability = <String, List<Map<String, dynamic>>>{};
        //
        //   for (var item in controller.availabilityDraftItems) {
        //     final category = item['category'];
        //     if (groupedItemsAvailability[category] == null) {
        //       groupedItemsAvailability[category] = [];
        //     }
        //     groupedItemsAvailability[category]!.add(item);
        //   }
        //
        //   return Column(
        //     children: [
        //       ...groupedItemsAvailability.entries.map((entry) {
        //         final category = entry.key;
        //         final items = entry.value;
        //
        //         return Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Padding(
        //               padding: const EdgeInsets.symmetric(vertical: 8.0),
        //               child: Text(
        //                 category,
        //                 style: TextStyle(
        //                   fontSize: 14,
        //                   fontWeight: FontWeight.bold,
        //                   color: Color(0xFF023B5E),
        //                 ),
        //               ),
        //             ),
        //             ...items.map((item) {
        //               return SumAmountProduct(
        //                 productName: item['sku'] ?? '',
        //                 stockController:
        //                     TextEditingController(text: item['stock']?.toString() ?? ''),
        //                 AV3MController: TextEditingController(text: item['av3m']?.toString() ?? ''),
        //                 recommendController:
        //                     TextEditingController(text: item['recommend']?.toString() ?? ''),
        //                 isReadOnly: true,
        //                 itemData: {
        //                   'id': item['id'],
        //                   'sku': item['sku'],
        //                   'category': item['category'],
        //                   'stock': item['stock'],
        //                   'av3m': item['av3m'],
        //                   'recommend': item['recommend']
        //                 },
        //               );
        //             }).toList(),
        //             SizedBox(height: 10),
        //           ],
        //         );
        //       }).toList(),
        //     ],
        //   );
        // }),
      ],
    );
  }
}

class CollapsibleCategoryGroup extends StatefulWidget {
  final String category;
  final List<Map<String, dynamic>> items;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CollapsibleCategoryGroup({
    Key? key,
    required this.category,
    required this.items,
    required this.onEdit, required this.onDelete,
  }) : super(key: key);

  @override
  State<CollapsibleCategoryGroup> createState() => _CollapsibleCategoryGroupState();
}

class _CollapsibleCategoryGroupState extends State<CollapsibleCategoryGroup> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: isExpanded ? 8 : 0),
          decoration: BoxDecoration(
            color: Color(0xFFEDF8FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  children: [
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                      color: Color(0xFF023B5E),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.category,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF023B5E),
                            ),
                          ),
                          Text(
                            '${widget.items.length} products',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onEdit,
                      icon: Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      tooltip: 'Edit Category Products',
                    ),
                    IconButton(
                      onPressed: widget.onDelete,
                      icon: Icon(Icons.delete, color: Colors.red, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      tooltip: 'Delete Category Products',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isExpanded)
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Column(
              children: widget.items.map((item) {
                return SumAmountProduct(
                  productName: item['sku'] ?? '',
                  stockController: TextEditingController(
                    text: item['stock'].toString(),
                  ),
                  av3mController: TextEditingController(
                    text: item['av3m'].toString(),
                  ),
                  recommendController: TextEditingController(
                    text: item['recommend'].toString(),
                  ),
                  // priceController: TextEditingController(
                  //   text: item['price'].toString(),
                  // ),
                  isReadOnly: true,
                  itemData: item,
                  onDelete: () {},
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class SumAmountProduct extends StatelessWidget {
  final String productName;
  final TextEditingController stockController;
  final TextEditingController av3mController;
  final TextEditingController recommendController;
  // final TextEditingController priceController;
  final bool isReadOnly;
  final VoidCallback onDelete;
  final Map<String, dynamic> itemData;

  const SumAmountProduct({
    super.key,
    required this.productName,
    required this.stockController,
    required this.av3mController,
    required this.recommendController,
    required this.onDelete,
    required this.itemData,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16, top: 8, right: 8),
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
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFEEEEEE),
                  width: 1,
                ),
              ),
            ),
            child: Text(
              productName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023B5E),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                _buildDetailField("Stock", stockController),
                SizedBox(width: 12),
                _buildDetailField("Av3m", av3mController),
                SizedBox(width: 12),
                _buildDetailField("Recommend", recommendController),
              //   SizedBox(width: 12),
              //   _buildDetailField("Price", priceController),
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
