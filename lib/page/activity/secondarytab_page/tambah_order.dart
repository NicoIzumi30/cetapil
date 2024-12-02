import 'package:cetapil_mobile/widget/back_button.dart';
import 'package:cetapil_mobile/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controller/activity/tambah_order_controller.dart';
import '../../../utils/colors.dart';

class TambahOrder extends GetView<TambahOrderController> {
  const TambahOrder({super.key});

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
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EnhancedBackButton(
                  onPressed: () => Alerts.showConfirmDialog(context,useGetBack: false),
                  backgroundColor: Colors.white,
                  iconColor: Colors.blue,
                        useGetBack: false,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kategori",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 10),
                        _buildCategoryDropdown(),
                        SizedBox(height: 20),
                        Text(
                          "SKU",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 10),
                        _buildSkuDropdown(),
                        SizedBox(height: 20),
                        Text(
                          "Selected SKU",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 10),
                        _buildSelectedSkuDetails(),
                      ],
                    ),
                  ),
                ),
                _buildBottomButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
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
    );
  }

  Widget _buildSkuDropdown() {
    return Container(
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
          onChanged: controller.selectedCategory.value != null ? controller.onSkuSelected : null,
          isExpanded: true,
        );
      }),
    );
  }

  Widget _buildSelectedSkuDetails() {
    return Obx(() => controller.selectedSkuData.value != null
        ? OrderDetailCard(
            productName: controller.selectedSkuData.value!['sku'] ?? '',
            jumlahController: controller.jumlahController.value,
            hargaController: controller.hargaController.value,
          )
        : Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                "Select a SKU to view product details",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ));
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: AppColors.primary),
                ),
              ),
              onPressed: () {
                controller.addOrderItem();
                controller.clearForm();
                Get.back();
              },
              child: Text(
                "Tambah & Kembali",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: AppColors.primary),
                ),
              ),
              onPressed: () {
                controller.addOrderItem();
                controller.clearForm();
              },
              child: Text(
                "Tambah & Lanjut",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailCard extends StatefulWidget {
  final String productName;
  final TextEditingController jumlahController;
  final TextEditingController hargaController;

  const OrderDetailCard({
    super.key,
    required this.productName,
    required this.jumlahController,
    required this.hargaController,
  });

  @override
  State<OrderDetailCard> createState() => _OrderDetailCardState();
}

class _OrderDetailCardState extends State<OrderDetailCard> {
  String _formatCurrency(String value) {
    if (value.isEmpty) return '';
    final number = int.parse(value.replaceAll(RegExp(r'[^\d]'), ''));
    final formatted = number
        .toString()
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    return formatted;
  }

  String _removeCurrencyFormat(String value) {
    return value.replaceAll(RegExp(r'[^\d]'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Detail Order",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF023B5E),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.productName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
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
                          Container(
                            height: 40,
                            child: TextFormField(
                              controller: widget.jumlahController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF0077BD),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                filled: true,
                                fillColor: Color(0xFFE8F3FF),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Color(0xFF64B5F6)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Color(0xFF64B5F6)),
                                ),
                              ),
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
                            "Harga",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF666666),
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            height: 40,
                            child: TextFormField(
                              controller: widget.hargaController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF0077BD),
                              ),
                              textAlign: TextAlign.left,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  String cleanValue = _removeCurrencyFormat(value);
                                  String formatted = _formatCurrency(cleanValue);
                                  widget.hargaController.value = TextEditingValue(
                                    text: formatted,
                                    selection: TextSelection.collapsed(offset: formatted.length),
                                  );
                                }
                              },
                              decoration: InputDecoration(
                                prefixText: "Rp ",
                                prefixStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF0077BD),
                                ),
                                hintText: "0",
                                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                filled: true,
                                fillColor: Color(0xFFE8F3FF),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Color(0xFF64B5F6)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Color(0xFF64B5F6)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
