import 'package:cetapil_mobile/controller/activity/activity_controller.dart';
import 'package:cetapil_mobile/widget/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/activity/tambah_activity_controller.dart';
import '../../../model/list_category_response.dart';

class AvailabilityPage extends GetView<TambahActivityController> {
  const AvailabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CustomDropdown(
        //     hint: "-- Pilih kategori produk --",
        //     items: [],
        //     onChanged: (String) {},
        //     title: "Kategori Produk"),
        Obx(() {
          if (controller.isLoadingAvailability.value) {
            return CircularProgressIndicator();
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kategori Produk",
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700),
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
                      "-- Pilih kategori produk --",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.blue, // Match your theme color
                    ),
                    items: controller.itemsCategory.map((item) {
                      return DropdownMenuItem<Data>(
                        value: item, // Use the ID as the value
                        child: Text(item.name ?? ''), // Display the name
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (!controller.selectedItems.contains(value)) {
                        controller.selectedItems.add(value!);
                      }
                    },
                    isExpanded: true,
                  ),
                ),
              ],
            );

            // CustomDropdown(
            //   hint: "-- Pilih kategori produk --",
            //   // items: controller.itemsCategory.map((item)=>item.name as String).toList(),
            //   items: controller.itemsCategory.map((item) {
            //     return DropdownMenuItem<String>(
            //       value: item, // Use the ID as the value
            //       child: Text(item.name ?? ''), // Display the name
            //     );
            //   }).toList(),
            //   onChanged: (value){
            //     if (!controller.selectedItems.contains(value)) {
            //
            //       controller.selectedItems.add(value!);
            //     }
            //   },
            //   title: "Kategori Produk");
          }
        }),

        //  DropdownButtonFormField<String>(
        //   // value: controller.value, // Always set to null to avoid the duplicate value error
        //   decoration: InputDecoration(
        //     contentPadding: const EdgeInsets.symmetric(
        //       horizontal: 16,
        //       vertical: 12,
        //     ),
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(8),
        //       borderSide: BorderSide.none,
        //     ),
        //     filled: true,
        //     fillColor: const Color(0xFFE8F3FF),
        //   ),
        //   hint: Text(
        //     "-- Pilih kategori produk --",
        //     style: TextStyle(
        //       color: Colors.grey[400],
        //       fontSize: 14,
        //     ),
        //   ),
        //   items: controller.items.map((String item) {
        //     return DropdownMenuItem<String>(
        //       value: item,
        //       child: Text(item),
        //     );
        //   }).toList(),
        //   onChanged: (value){
        //     if (!controller.selectedItems.contains(value)) {
        //
        //     controller.selectedItems.add(value!);
        //     }
        //   },
        //   isExpanded: true,
        // ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.selectedItems.map((item) {
                  return InputChip(
                    label: Text(item.name!),
                    onDeleted: () => controller.removeItem(item.name!),
                  );
                }).toList(),
              )),
        ),
        SizedBox(
          height: 10,
        ),

// Display selected items

        Text("Cleanser",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023B5E))),
        SumAmountProduct(
          productName: "Cetaphil Exfoliate Cleanser 500ml",
          stockController: TextEditingController(),
          AV3MController: TextEditingController(),
          recommendController: TextEditingController(),
        ),
        Divider(),
        Text("Baby Treatment",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023B5E))),
        SumAmountProduct(
          productName:
              "Cetaphil Baby Daily Lotion with Organic Calendula 400ml",
          stockController: TextEditingController(),
          AV3MController: TextEditingController(),
          recommendController: TextEditingController(),
        ),
        Divider(),
        SumAmountProduct(
          productName:
              "Cetaphil Baby Daily Lotion with Organic Calendula 200ml",
          stockController: TextEditingController(),
          AV3MController: TextEditingController(),
          recommendController: TextEditingController(),
        ),
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
        decoration: InputDecoration(
          // hintText: widget.title,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
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
