import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_detail_page/detail_item_order.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/tambah_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controller/activity/detail_activity_controller.dart';
import '../../../controller/activity/tambah_order_controller.dart';
import '../../../utils/colors.dart';

class DetailOrderPage extends GetView<DetailActivityController> {
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final groupedItems = <String, List<Map<String, dynamic>>>{};

          // if (controller.detailDraft.isNotEmpty) {
          //   for (var data in controller.detailDraft["orderItems"]) {
          //
          //     final item = tambahAvailabilityController.getSkuByDataApi(data['product_id']);
          //     final newItem = {
          //       'id': data['product_id'],
          //       'category': item!['category']['name'],
          //       'sku': item['sku'],
          //       'jumlah': data['jumlah'],
          //       'harga': data['harga'],
          //     };
          //     controller.addOrderItem(newItem);
          //     tambahOrderController.clearForm();
          //   }
          // }

          // Use orderDraftItems from TambahActivityController
          for (var item in controller.orderItems) {
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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF023B5E),
                        ),
                      ),
                    ),
                    ...items.map((item) {
                      return OrderProductCard(
                        productName: item['sku'] ?? '',
                        jumlahController:
                        TextEditingController(text: item['jumlah']?.toString() ?? ''),
                        hargaController:
                        TextEditingController(text: item['harga']?.toString() ?? ''),
                        isReadOnly: true,
                        itemData: item,
                      );
                    }).toList(),
                    SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ],
          );
        }),

      ],
    );
  }
}

class OrderProductCard extends StatelessWidget {
  final String productName;
  final TextEditingController jumlahController;
  final TextEditingController hargaController;
  final bool isReadOnly;
  final Map<String, dynamic> itemData;

  const OrderProductCard({
    super.key,
    required this.productName,
    required this.jumlahController,
    required this.hargaController,
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
                        "Order Detail",
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
                        // orderController.editItem(itemData);
                        await Get.to(() => DetailItemOrder(itemData));
                      },
                      icon: Icon(Icons.visibility, color: Colors.blue, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      tooltip: 'Show Product',
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
                Expanded(
                  flex: 2,
                  child: _buildJumlahField(),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 5,
                  child: _buildHargaField(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJumlahField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Jumlah",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF666666),
          ),
        ),
        SizedBox(height: 4),
        NumberField(
          controller: jumlahController,
          readOnly: isReadOnly,
          isSmall: true,
        ),
      ],
    );
  }

  Widget _buildHargaField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Harga",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF666666),
          ),
        ),
        SizedBox(height: 4),
        PriceField(
          controller: hargaController,
          readOnly: isReadOnly,
        ),
      ],
    );
  }
}

class NumberField extends StatelessWidget {
  final TextEditingController controller;
  final bool readOnly;
  final bool isSmall;

  const NumberField({
    super.key,
    required this.controller,
    this.readOnly = false,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 5),
      width: isSmall ? 100 : null,
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
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF0077BD),
        ),
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
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
          fillColor: readOnly ? Colors.grey[200] : const Color(0xFFE8F3FF),
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
        ),
      ),
    );
  }
}

class PriceField extends StatefulWidget {
  final TextEditingController controller;
  final bool readOnly;

  const PriceField({
    super.key,
    required this.controller,
    this.readOnly = false,
  });

  @override
  State<PriceField> createState() => _PriceFieldState();
}

class _PriceFieldState extends State<PriceField> {
  String _formatCurrency(String value) {
    if (value.isEmpty) return '';
    final number = int.parse(value.replaceAll(RegExp(r'[^\d]'), ''));
    final formatted = number
        .toString()
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    return 'Rp $formatted';
  }

  String _removeCurrencyFormat(String value) {
    return value.replaceAll(RegExp(r'[^\d]'), '');
  }

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
        controller: widget.controller,
        keyboardType: TextInputType.number,
        readOnly: widget.readOnly,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF0077BD),
        ),
        textAlign: TextAlign.left,
        onChanged: (value) {
          final raw = _removeCurrencyFormat(value);
          if (raw.isNotEmpty) {
            final formatted = _formatCurrency(raw);
            widget.controller.value = TextEditingValue(
              text: formatted,
              selection: TextSelection.collapsed(offset: formatted.length),
            );
          }
        },
        decoration: InputDecoration(
          prefixText: 'Rp ',
          prefixStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0077BD),
          ),
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFF64B5F6),
              width: 2,
            ),
          ),
          filled: true,
          fillColor: widget.readOnly ? Colors.grey[200] : const Color(0xFFE8F3FF),
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
        ),
      ),
    );
  }
}
