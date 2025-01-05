import 'package:cetapil_mobile/controller/activity/detail_activity_controller.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_detail_page/detail_item_availability.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/activity/tambah_availibility_controller.dart';

class DetailAvailabilityPage extends GetView<DetailActivityController> {
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

class CollapsibleCategoryGroup extends StatefulWidget {
  final String category;
  final List<Map<String, dynamic>> items;
  final VoidCallback? onEdit;
  final bool isEdit;

  const CollapsibleCategoryGroup({
    Key? key,
    required this.category,
    required this.items,
    this.onEdit, required this.isEdit,
  }) : super(key: key);

  @override
  State<CollapsibleCategoryGroup> createState() => _CollapsibleCategoryGroupState();
}

class _CollapsibleCategoryGroupState extends State<CollapsibleCategoryGroup> {
  bool isExpanded = false;
  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: "Rp ", decimalDigits: 0);

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
                  availabilityYesNoController: TextEditingController(
                    text: item['availability_exist'].toString() == "true" ? "Ada" : "Tidak",
                  ),
                  stockOnHandController: TextEditingController(
                    text: item['stock_on_hand'].toString(),
                  ),
                  stockOnInventoryController: TextEditingController(
                    text: item['stock_on_inventory'].toString(),
                  ),
                  av3mController: TextEditingController(
                    text: item['av3m'].toString(),
                  ),
                  recommendController: TextEditingController(
                    text: item['recommend'].toString(),
                  ),
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
class SumAmountProduct extends StatelessWidget {
  final String productName;
  final TextEditingController availabilityYesNoController;
  final TextEditingController stockOnHandController;
  final TextEditingController stockOnInventoryController;
  final TextEditingController av3mController;
  final TextEditingController recommendController;
  // final TextEditingController priceController;
  final bool isReadOnly;
  final Map<String, dynamic> itemData;

  String checkStatus(String number) {
    int num = int.parse(number);
    if (num < 0) {
      return "ORDER";
    } else if (num > 0) {
      return "OVER";
    } else {
      return "IDEAL";
    }
  }

  statusColor(String value) {
    switch (value) {
      case "OVER":
        return Color(0xffff7171);
      case "ORDER":
        return Color(0xff52c667);
      case "IDEAL":
        return Color(0xff0177be);
      default:
    }
  }

  const SumAmountProduct({
    super.key,
    required this.productName,
    required this.stockOnHandController,
    required this.av3mController,
    required this.recommendController,
    required this.itemData,
    this.isReadOnly = false, required this.availabilityYesNoController, required this.stockOnInventoryController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16, top: 8, right: 8,left: 8),
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
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text("Availability",style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF666666),
                        ),)),
                    Expanded(
                      flex: 1,
                      child: NumberField(
                        controller: availabilityYesNoController,
                        readOnly: isReadOnly,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildDetailField("Stock On Shelf", stockOnHandController),
                    SizedBox(width: 12),
                    _buildDetailField("Stock On Inventory", stockOnInventoryController),
                    SizedBox(width: 12),
                    _buildDetailField("Av3m", av3mController),
                  ],
                ),
                Row(
                  children: [
                    _buildDetailField("Recommend", recommendController),
                    SizedBox(width: 12),
                    _buildDetailStatus("Status", checkStatus(recommendController.text)),
                  ],
                ),
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
              fontSize: 10,
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

  Widget _buildDetailStatus(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
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
            child: TextFormField(
              controller: TextEditingController(text: value),
              keyboardType: TextInputType.number,
              readOnly: true,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
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
                  borderSide: BorderSide(
                    color: statusColor(value),
                    width: 1,
                  ),
                ),
                filled: true,
                fillColor: statusColor(value),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: statusColor(value),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:  BorderSide(
                    color: statusColor(value),
                    width: 1,
                  ),
                ),
              ),
            ),
          )
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