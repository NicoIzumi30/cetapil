import 'package:cetapil_mobile/widget/back_button.dart';
import 'package:cetapil_mobile/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controller/activity/tambah_order_controller.dart';
import '../../../utils/colors.dart';
import '../../../widget/text_field.dart';

class DetailItemOrder extends StatelessWidget {
  const DetailItemOrder(this.detailItem, {super.key});
  final Map<String, dynamic> detailItem;
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
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ModernTextField(
                          enable: false,
                          title: "Kategori",
                          controller:
                          TextEditingController(text: detailItem['category']),
                        ),
                        ModernTextField(
                          enable: false,
                          title: "SKU",
                          controller:
                          TextEditingController(text: detailItem['sku']),
                        ),
                        Text(
                          "Selected SKU",
                          style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 10),
                        _buildSelectedSkuDetails(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSelectedSkuDetails() {
    return detailItem.isNotEmpty
        ? OrderDetailCard(
      productName: detailItem['sku'] ?? '',
      jumlahController: TextEditingController(text: detailItem['jumlah'].toString()),
      hargaController: TextEditingController(text: detailItem['harga'].toString()),
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
                              readOnly: true,
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
                              readOnly: true,
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
