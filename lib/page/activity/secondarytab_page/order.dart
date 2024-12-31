import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/tambah_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/activity/tambah_order_controller.dart';
import '../../../utils/colors.dart';

class OrderPage extends GetView<TambahActivityController> {
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
              if (!Get.isRegistered<TambahOrderController>()) {
                Get.put(TambahOrderController());
              }
              Get.to(() => TambahOrder());
            },
            child: Text(
              "Tambah Order",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        OrderSummaryCard(),
        SizedBox(height: 10),
        Obx(() {
          if (controller.orderDraftItems.isEmpty) {
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
          for (var item in controller.orderDraftItems) {
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
                      if (!Get.isRegistered<TambahOrderController>()) {
                        Get.put(TambahOrderController());
                      }
                      final prodController = Get.find<TambahOrderController>();

                      // Find the category ID from the name
                      final categoryId = prodController.supportDataController
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
                          'jumlah': item['jumlah'].toString(),
                          'harga': item['harga'].toString(),
                        };
                      }

                      // Navigate to edit screen
                      await Get.to(() => const TambahOrder());
                    },
                    onDelete: () async {
                      if (!Get.isRegistered<TambahOrderController>()) {
                        Get.put(TambahOrderController());
                      }
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Hapus Item'),
                          content: Text(
                              'Apakah Anda yakin ingin menghapus Item ini?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                final prodController =
                                    Get.find<TambahOrderController>();
                                controller.orderDraftItems.removeWhere(
                                    (item) => item['category'] == category);
                                prodController.productValues.clear();
                                prodController.selectedCategory.value = null;
                              },
                              child: Text('Hapus'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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

class CollapsibleCategoryGroup extends StatefulWidget {
  final String category;
  final List<Map<String, dynamic>> items;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CollapsibleCategoryGroup({
    Key? key,
    required this.category,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<CollapsibleCategoryGroup> createState() =>
      _CollapsibleCategoryGroupState();
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  children: [
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
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
                      icon: Icon(Icons.edit_outlined,
                          color: Colors.blue, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      tooltip: 'Edit Category Products',
                    ),
                    // IconButton(
                    //   onPressed: widget.onDelete,
                    //   icon: Icon(Icons.delete, color: Colors.red, size: 20),
                    //   padding: EdgeInsets.zero,
                    //   constraints: BoxConstraints(),
                    //   tooltip: 'Delete Category Products',
                    // ),
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
                return OrderProductCard(
                  productName: item['sku'] ?? '',
                  jumlahController: TextEditingController(
                      text: item['jumlah']?.toString() ?? ''),
                  hargaController: TextEditingController(
                      text: item['harga']?.toString() ?? ''),
                  isReadOnly: true,
                  itemData: item,
                );
              }).toList(),
            ),
          ),
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
            child: Column(
              children: [
                Row(
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
                      "Rp ${_calculateTotal()}",
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

  String _calculateTotal() {
    final jumlah =
        int.tryParse(jumlahController.text.replaceAll(RegExp(r'[^\d]'), '')) ??
            0;
    final harga =
        int.tryParse(hargaController.text.replaceAll(RegExp(r'[^\d]'), '')) ??
            0;
    final total = jumlah * harga;

    return total.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
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
    String formattedValue = '';
    if (hargaController.text.isNotEmpty) {
      final number =
          int.tryParse(hargaController.text.replaceAll(RegExp(r'[^\d]'), '')) ??
              0;
      formattedValue =
          'Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

      // Update controller with formatted value if it's not already formatted
      if (hargaController.text != formattedValue) {
        hargaController.text = formattedValue;
      }
    }
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
    final formatted = number.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
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
          prefixText: '',
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
          fillColor:
              widget.readOnly ? Colors.grey[200] : const Color(0xFFE8F3FF),
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

class OrderSummaryCard extends GetView<TambahActivityController> {
  const OrderSummaryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID', 
      symbol: "Rp ", 
      decimalDigits: 0
    );

    return Obx(() {
      final ctrl = Get.find<TambahActivityController>();
      var totalQty = 0;
      var totalPrice = 0.0;

      for (final item in ctrl.orderDraftItems) {
        if (item['jumlah'] != null && item['harga'] != null) {
          totalQty += (item['jumlah'] as num).toInt();
          totalPrice += (item['jumlah'] as num) * (item['harga'] as num);
        }
      }

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...ctrl.orderDraftItems.fold<Map<String, List<Map<String, dynamic>>>>(
              {}, 
              (map, item) {
                final category = item['category'] as String? ?? 'Other';
                map.putIfAbsent(category, () => []).add(item);
                return map;
              }
            ).entries.map((entry) => Column(
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
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                ...entry.value.where((item) => 
                  (item['jumlah'] as num?)?.toInt() != 0 && 
                  (item['harga'] as num?)?.toInt() != 0
                ).map((item) => Container(
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
                      // Qty column
                      SizedBox(
                        width: 30,
                        child: Text(
                          item['jumlah'].toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      // Product name column
                      Expanded(
                        child: Text(
                          item['sku'] ?? '',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      // Price column
                      SizedBox(
                        width: 100,
                        child: Text(
                          formatter.format((item['jumlah'] as num) * (item['harga'] as num)),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Jumlah',
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
                      'Total Harga',
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
          ],
        ),
      );
    });
  }
}