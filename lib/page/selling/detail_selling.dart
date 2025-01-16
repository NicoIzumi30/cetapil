import 'dart:io';

import 'package:cetapil_mobile/controller/bottom_nav_controller.dart';
import 'package:cetapil_mobile/page/selling/tambah_selling.dart';
import 'package:cetapil_mobile/utils/image_upload.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../controller/outlet/outlet_controller.dart';
import '../../controller/selling/selling_controller.dart';
import '../../utils/colors.dart';
import '../../widget/back_button.dart';
import '../../widget/clipped_maps.dart';
import '../../widget/dropdown_textfield.dart';
import '../../widget/text_field.dart';
import '../outlet/detail_outlet.dart';
import '../../model/list_selling_response.dart';

class DetailSelling extends GetView<SellingController> {
  DetailSelling(
    this.selling, {
    super.key,
  });
  final Data selling;

  @override
  Widget build(BuildContext context) {
    int totalQty = 0;
    double totalPrice = 0.0;
    final groupedItems = <String, List<Map<String, dynamic>>>{};
    for (var item in selling.products!) {
      final category = item.category;
      totalQty += (item.qty as num).toInt();
      totalPrice += (item.total as num).toDouble();
      if (groupedItems[category!.name!] == null) {
        groupedItems[category.name!] = [];
      }
      groupedItems[category.name!]!.add(item.toMap());
    }

    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: "Rp ", decimalDigits: 0);

    // for (var data in selling.products!) {
    //
    //   totalQty += (data.qty as num).toInt();
    //   totalPrice += (data.total as num).toDouble();
    // }
    return SafeArea(
        child: Stack(children: [
      Image.asset(
        'assets/background.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EnhancedBackButton(
                onPressed: () {
                  Get.back();
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
                      UnderlineTextField.readOnly(
                        title: "Nama Outlet",
                        value: selling.outlet!.name,
                      ),
                      // UnderlineTextField.readOnly(
                      //   title: "Kategori Outlet",
                      //   value: controller.filteredOutlets
                      //       .where(
                      //           (element) => element.id == selling.outlet!.id)
                      //       .first
                      //       .category,
                      // ),
                      // Column(
                      //   children: selling.products!.map((product) {
                      //
                      //     // final sortedProducts = selling.products!.toList()
                      //     //   ..sort((a, b) => (a.category?.name ?? '').compareTo(b.category?.name ?? ''));
                      //     // print( " ---${sortedProducts}");
                      //     return Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(product.category?.name ?? "-",
                      //             style: TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Color(0xFF023B5E))),
                      //         SumAmountProduct(
                      //           productName: product.productName!,
                      //           stockController: TextEditingController(text: product.stock!.toString()),
                      //           sellingController: TextEditingController(text: product.selling!.toString()),
                      //           balanceController: TextEditingController(text: product.balance!.toString()),
                      //           priceController: TextEditingController(text: product.price!.toString()),
                      //         ),
                      //       ],
                      //     ); // Replace with your widget
                      //   }).toList(),
                      // ),
                      // Column(
                      //   children: [
                      //     ...groupedByCategory.entries.map((entry) {
                      //       final category = entry.key;
                      //       final products = entry.value;
                      //
                      //       return Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Padding(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: Text(
                      //               category,
                      //               style: TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //           ),
                      //           ...products.map(
                      //             (product) => SumAmountProduct(
                      //               productName: product.productName!,
                      //               stockController:
                      //                   TextEditingController(text: product.qty!.toString()),
                      //               sellingController:
                      //                   TextEditingController(text: "product.selling!".toString()),
                      //               balanceController:
                      //                   TextEditingController(text: "product.balance!".toString()),
                      //               priceController:
                      //                   TextEditingController(text: product.price!.toString()),
                      //             ),
                      //           )
                      //         ],
                      //       );
                      //     }).toList(),
                      //   ],
                      // ),
                      Text(
                        "Produk",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF023B5E)),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFEDF8FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color(0xFF64B5F6),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ...selling.products!.fold<Map<String, List<Map<String, dynamic>>>>({}, (map, item) {
                              final category = item.category!.name as String? ?? 'Other';
                              map.putIfAbsent(category, () => []).add(item.toMap());
                              return map;
                            })
                                .entries
                                .map((entry) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xFFEEEEEE),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    entry.key,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF0077BD),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                ...entry.value
                                    .where((item) => item['qty'] != 0 && item['price'] != 0)
                                    .map((item) => Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xFFF5F5F5),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 30,
                                        child: Text(
                                          item['qty']?.toString() ?? '0',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item['sku'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          formatter
                                              .format((item['qty'] ?? 0) * (item['price'] ?? 0)),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                const SizedBox(height: 8),
                              ],
                            )),
                            Container(
                              padding: const EdgeInsets.only(top: 8),
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Color(0xFFEEEEEE),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Total Quantity',
                                        style: TextStyle(fontSize: 12, color: Colors.black54),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        totalQty.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0077BD),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'Total Price',
                                        style: TextStyle(fontSize: 12, color: Colors.black54),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        formatter.format(totalPrice),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0077BD),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
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
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: UnderlineTextField.readOnly(
                              title: "Longitude",
                              value: selling.longitude,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: UnderlineTextField.readOnly(
                              title: "Latitude",
                              value: selling.latitude,
                            ),
                          ),
                        ],
                      ),
                      MapPreviewWidget(
                        latitude: double.parse(selling.latitude!),
                        longitude: double.parse(selling.longitude!),
                        zoom: 14.0,
                        height: 250,
                        borderRadius: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ClipImage(url: selling.image!),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ))
    ]));
  }
}

class ClipImage extends StatelessWidget {
  final String? url;
  final double? size;
  final BoxFit fit;

  const ClipImage({
    super.key,
    required this.url,
    this.size,
    this.fit = BoxFit.cover,
  });

  String _sanitizeUrl(String url) {
    print("https://cetaphil.id${url}");
    return "https://cetaphil.id${url}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Foto",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10),
        GestureDetector(
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
          child: SizedBox(
            height: 150,
            width: double.infinity,
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
      ],
    );
  }

  Widget _buildErrorWidget(
      BuildContext context, Object? error, StackTrace? stackTrace) {
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

class SumAmountProduct extends StatelessWidget {
  final String productName;
  final TextEditingController stockController;
  final TextEditingController sellingController;
  final TextEditingController balanceController;
  final TextEditingController priceController;

  const SumAmountProduct({
    super.key,
    required this.productName,
    required this.stockController,
    required this.sellingController,
    required this.balanceController,
    required this.priceController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 2,
          child: Text(
            productName,
            style: TextStyle(fontSize: 10),
          )),
      SizedBox(
        width: 10,
      ),
      Expanded(
        child: Column(
          children: [
            Text(
              "Stock",
              style: TextStyle(fontSize: 12),
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
              "Selling",
              style: TextStyle(fontSize: 12),
            ),
            NumberField(
              controller: sellingController,
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
              "Balance",
              style: TextStyle(fontSize: 12),
            ),
            NumberField(
              controller: balanceController,
            ),
          ],
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        child: Column(
          children: [
            Text(
              "Price",
              style: TextStyle(fontSize: 12),
            ),
            NumberField(
              controller: priceController,
            ),
          ],
        ),
      ),
    ]);
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
        readOnly: true,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF0077BD),
        ),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          // hintText: widget.title,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          contentPadding: EdgeInsets.symmetric(
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
          fillColor: const Color(0xFFE8F3FF), // Light blue background
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
