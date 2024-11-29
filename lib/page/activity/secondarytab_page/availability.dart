import 'package:cetapil_mobile/page/activity/secondarytab_page/tambah_availability.dart';
import 'package:cetapil_mobile/widget/category_tag_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controller/activity/support_activity_controller.dart';
import '../../../controller/activity/tambah_activity_controller.dart';
import '../../../controller/activity/tambah_availibility_controller.dart';
import '../../../model/list_category_response.dart';
import '../../../utils/colors.dart';
import '../../../widget/searchable_grouped_dropdown.dart';

class AvailabilityPage extends GetView<TambahActivityController> {
  AvailabilityPage({super.key});

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
              if (!Get.isRegistered<SupportActivityController>()) {
                Get.put(SupportActivityController());
              }
              if (!Get.isRegistered<TambahAvailabilityController>()) {
                Get.put(TambahAvailabilityController());
              }
              Get.to(() => TambahAvailability());
            },
            child: Text(
              " Tambah Availibility",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Obx(() {
        //   if (controller.isLoadingAvailability.value) {
        //     return Center(child: CircularProgressIndicator());
        //   } else {
        //     return Container(
        //       margin: EdgeInsets.only(bottom: 10),
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(8),
        //         boxShadow: [
        //           BoxShadow(
        //             color: Colors.grey.withOpacity(0.1),
        //             spreadRadius: 1,
        //             blurRadius: 3,
        //             offset: const Offset(0, 2),
        //           ),
        //         ],
        //       ),
        //       child: CategoryTagDropdown<Data>(
        //         selectedItems: controller.selectedItems,
        //         items: controller.itemsCategory,
        //         getDisplayName: (item) => item.name ?? '',
        //         onChanged: (value) {
        //           if (!controller.selectedItems.contains(value)) {
        //             controller.selectedItems.add(value!);
        //           }
        //         },
        //         onRemove: (item) => controller.selectedItems.remove(item),
        //         onSelectionComplete: () => controller.getProductbyCategory(),
        //       ),
        //     );
        //   }
        // }),
        //
        // Obx(() => SearchableGroupedDropdown(
        //       title: "SKU",
        //       categories: controller.products.value,
        //       onSelect: (item) => controller.handleProductSelect(item),
        //       onDeselect: (item) => controller.handleProductDeselect(item),
        //     )),
        //
        // //  DropdownButtonFormField<String>(
        // //   // value: controller.value, // Always set to null to avoid the duplicate value error
        // //   decoration: InputDecoration(
        // //     contentPadding: const EdgeInsets.symmetric(
        // //       horizontal: 16,
        // //       vertical: 12,
        // //     ),
        // //     border: OutlineInputBorder(
        // //       borderRadius: BorderRadius.circular(8),
        // //       borderSide: BorderSide.none,
        // //     ),
        // //     filled: true,
        // //     fillColor: const Color(0xFFE8F3FF),
        // //   ),
        // //   hint: Text(
        // //     "-- Pilih kategori produk --",
        // //     style: TextStyle(
        // //       color: Colors.grey[400],
        // //       fontSize: 14,
        // //     ),
        // //   ),
        // //   items: controller.items.map((String item) {
        // //     return DropdownMenuItem<String>(
        // //       value: item,
        // //       child: Text(item),
        // //     );
        // //   }).toList(),
        // //   onChanged: (value){
        // //     if (!controller.selectedItems.contains(value)) {
        // //
        // //     controller.selectedItems.add(value!);
        // //     }
        // //   },
        // //   isExpanded: true,
        // // ),
        // // SingleChildScrollView(
        // //   scrollDirection: Axis.horizontal,
        // //   child: Obx(() => Wrap(
        // //         spacing: 8,
        // //         runSpacing: 8,
        // //         children: controller.selectedItems.map((item) {
        // //           return InputChip(
        // //             label: Text(item.name!),
        // //             onDeleted: () => controller.removeItem(item.name!),
        // //           );
        // //         }).toList(),
        // //       )),
        // // ),
        //
        // SizedBox(
        //   height: 15,
        // ),
        // // Update the availability page
        // Obx(() => Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: controller.products.value.entries.map((category) {
        //         final productsInCategory =
        //             controller.selectedProducts.value.where((p) => category.value.contains(p));
        //
        //         if (productsInCategory.isEmpty) return SizedBox.shrink();
        //
        //         return Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text(category.key,
        //                 style: TextStyle(
        //                     fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF023B5E))),
        //             ...productsInCategory.map((product) {
        //               controller.initProductController(product);
        //
        //               return SumAmountProduct(
        //                 productName: product,
        //                 stockController: controller.productControllers[product]!['stock']!,
        //                 AV3MController: controller.productControllers[product]!['av3m']!,
        //                 recommendController: controller.productControllers[product]!['recommend']!,
        //               );
        //             }),
        //             Divider(),
        //           ],
        //         );
        //       }).toList(),
        //     ))
      ],
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
