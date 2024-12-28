import 'package:cetapil_mobile/controller/selling/tambah_produk_selling_controller.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/availability.dart';
import 'package:cetapil_mobile/utils/colors.dart';
import 'package:cetapil_mobile/widget/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TambahProductSelling extends GetView<TambahProdukSellingController> {
  const TambahProductSelling({super.key});

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
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      EnhancedBackButton(
                        onPressed: () {
                          // Clear the form
                          controller.clearForm();
                          Get.back();
                        },
                        backgroundColor: Colors.white,
                        iconColor: Colors.blue,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onPressed: () {
                          controller.saveAllProducts();
                          Get.back();
                        },
                        child: Text(
                          'Save All',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Add Summary Card here
                  const OrderSummaryCard(),
                  SizedBox(height: 20),
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
                  Expanded(
                    child: Obx(() {
                      final skus = controller.filteredSkus; // Get the filtered SKUs
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        itemCount: skus.length,
                        itemBuilder: (context, index) {
                          final sku = skus[index];
                          return CompactProductCard(
                            sku: sku,
                            onChanged: (values) =>
                                controller.updateProductValues(sku['id'].toString(), values),
                          );
                        },
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderSummaryCard extends GetView<TambahProdukSellingController> {
  const OrderSummaryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: "Rp ", decimalDigits: 0);

    return Obx(() {
      int totalQty = 0;
      double totalPrice = 0.0;

      // Calculate totals using the same data source as CompactProductCard
      controller.productValues.forEach((skuId, values) {
        // Get quantity
        final qty = int.tryParse(values['qty'] ?? '0') ?? 0;

        // Find the corresponding SKU from filtered SKUs
        final sku = controller.filteredSkus.firstWhere(
          (s) => s['id'].toString() == skuId,
          orElse: () => {'price': 0},
        );

        // Calculate price using the same logic as CompactProductCard
        if (qty > 0) {
          final price = sku['price'] ?? 0;
          totalQty += qty;
          totalPrice += price * qty;
        }
      });

      return Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Quantity',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  totalQty.toString(),
                  style: TextStyle(
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
                Text(
                  'Total Price',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  formatter.format(totalPrice),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0077BD),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class CompactProductCard extends StatefulWidget {
  final Map<String, dynamic> sku;
  final Function(Map<String, String>) onChanged;

  const CompactProductCard({
    required this.sku,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<CompactProductCard> createState() => _CompactProductCardState();
}

class _CompactProductCardState extends State<CompactProductCard> {
  late TextEditingController qtyController;
  late TextEditingController hargaController;
  double totalPrice = 0;
  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: "Rp ", decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    initializeControllers();
  }

  @override
  void didUpdateWidget(CompactProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sku['id'] != widget.sku['id']) {
      initializeControllers();
    }
  }

  void initializeControllers() {
    final controller = Get.find<TambahProdukSellingController>();
    final skuId = widget.sku['id'].toString();
    final existingValues = controller.productValues[skuId] ??
        {
          'qty': '0',
          'harga': widget.sku['price'].toString(),
        };

    qtyController = TextEditingController(text: existingValues['qty']);
    hargaController = TextEditingController(text: formatter.format(widget.sku['price']));

    if (qtyController.text.isNotEmpty) {
      try {
        totalPrice = widget.sku['price'] * int.parse(qtyController.text);
      } catch (e) {
        totalPrice = 0.0;
      }
    }

    _setupListeners();
  }

  void _setupListeners() {
    void updateValues() {
      widget.onChanged({
        'qty': qtyController.text.isEmpty ? '0' : qtyController.text,
        'harga': hargaController.text.isEmpty ? '0' : hargaController.text,
      });
    }

    qtyController.addListener(updateValues);
    hargaController.addListener(updateValues);
  }

  @override
  void dispose() {
    qtyController.dispose();
    hargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16, top: 8, right: 8, left: 8),
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
            width: double.infinity,
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
              widget.sku['sku'] ?? '',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023B5E),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Qty',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
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
                            child: TextField(
                              controller: qtyController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF0077BD),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              textAlign: TextAlign.center,
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
                                fillColor: const Color(0xFFE8F3FF),
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
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    totalPrice = 0.0;
                                  } else {
                                    try {
                                      totalPrice = widget.sku['price'] * int.parse(value);
                                    } catch (e) {
                                      totalPrice = 0.0;
                                    }
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Harga',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
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
                            child: TextField(
                              controller: hargaController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF0077BD),
                              ),
                              readOnly: true,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
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
                                fillColor: const Color(0xFFE8F3FF),
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
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Harga",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF0077BD),
                      ),
                    ),
                    Text(
                      "${formatter.format(totalPrice)}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF0077BD),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
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
        ),
      ],
    );
  }
}
