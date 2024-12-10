import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/activity/tambah_availibility_controller.dart';
import '../../../widget/back_button.dart';
import '../../../widget/dialog.dart';
import '../../../widget/text_field.dart';
import '../secondarytab_page/tambah_availability.dart';

class DetailItemAvailability extends GetView<TambahAvailabilityController> {
  const DetailItemAvailability(this.detailItem, {super.key});

  final Map<String, dynamic> detailItem;

  @override
  Widget build(BuildContext context) {
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            EnhancedBackButton(),
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
            )
          ]))
    ]));
  }

  Widget _buildSelectedSkuDetails() {
    return detailItem.isNotEmpty
        ? Container(
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
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Stock On Hand",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF023B5E),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              detailItem['sku'],
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
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildDetailField(
                          "Stock",
                          TextEditingController(
                              text: detailItem['stock'].toString()),
                          readOnly: true),
                      SizedBox(width: 12),
                      _buildDetailField(
                          "AV3M(Pcs)",
                          TextEditingController(
                              text: detailItem['av3m'].toString()),
                          readOnly: true),
                      SizedBox(width: 12),
                      _buildDetailField(
                          "Recommend",
                          TextEditingController(
                              text: detailItem['recommend'].toString()),
                          readOnly: true),
                    ],
                  ),
                ),
              ],
            ),
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

  Widget _buildDetailField(String label, TextEditingController controller,
      {bool readOnly = false}) {
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
            readOnly: readOnly,
          ),
        ],
      ),
    );
  }
}
