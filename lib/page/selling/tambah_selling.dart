import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/selling/selling_controller.dart';
import '../../controller/selling/tambah_produk_selling_controller.dart';
import '../../widget/back_button.dart';
import '../../widget/dialog.dart';
import '../../widget/category_dropdown.dart';
import '../../widget/text_field.dart';
import '../../widget/clipped_maps.dart';
import '../../utils/colors.dart';
import 'tambah_product_selling.dart';

class TambahSelling extends GetView<SellingController> {
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
                  EnhancedBackButton(
                    onPressed: () => Alerts.showConfirmDialog(context),
                    backgroundColor: Colors.white,
                    iconColor: Colors.blue,
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ModernTextField(
                            title: "Nama Outlet",
                            controller: controller.outletName.value,
                          ),
                          CategoryDropdown<SellingController>(
                            title: "Kategori Outlet",
                            controller: controller,
                            selectedCategoryGetter: (controller) => controller.selectedCategory,
                            categoriesGetter: (controller) => controller.categories,
                          ),
                          Text(
                            "Produk",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF023B5E)),
                          ),
                          Obx(() {
                            final items = controller.draftItems;
                            return Column(
                              children: [
                                ...items.map((item) => Container(
                                      margin: EdgeInsets.only(bottom: 15),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.blue.shade100),
                                      ),
                                      child: SumAmountProduct(
                                        productName: item['sku'] ?? '',
                                        stockController:
                                            TextEditingController(text: item['stock'].toString()),
                                        sellingController:
                                            TextEditingController(text: item['selling'].toString()),
                                        balanceController:
                                            TextEditingController(text: item['balance'].toString()),
                                        priceController:
                                            TextEditingController(text: item['price'].toString()),
                                        isReadOnly: true,
                                      ),
                                    )),
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
                                    onPressed: () async {
                                      if (!Get.isRegistered<TambahProdukSellingController>()) {
                                        Get.put(TambahProdukSellingController());
                                      }
                                      await Get.to(() => TambahProductSelling());
                                    },
                                    child: Text(
                                      "Tambah Product Selling",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Obx(() => TextField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text: controller
                                                  .gpsController.currentPosition.value?.longitude
                                                  .toString() ??
                                              '-'),
                                      decoration: InputDecoration(
                                        labelText: 'Longitude',
                                        border: OutlineInputBorder(),
                                      ),
                                    )),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Obx(() => TextField(
                                      readOnly: true,
                                      controller: TextEditingController(
                                          text: controller
                                                  .gpsController.currentPosition.value?.latitude
                                                  .toString() ??
                                              '-'),
                                      decoration: InputDecoration(
                                        labelText: 'Latitude',
                                        border: OutlineInputBorder(),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Obx(() => MapPreviewWidget(
                                latitude: double.tryParse(controller
                                        .gpsController.currentPosition.value!.latitude
                                        .toString()) ??
                                    -6.2088,
                                longitude: double.tryParse(controller
                                        .gpsController.currentPosition.value!.longitude
                                        .toString()) ??
                                    106.8456,
                                zoom: 14.0,
                                height: 250,
                                borderRadius: 10,
                              )),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: Obx(() => ElevatedButton(
                                  onPressed: controller.isSaving.value
                                      ? null
                                      : controller.saveDraftSelling,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: controller.isSaving.value
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          'Simpan Draft',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                )),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
  final bool isReadOnly;

  const SumAmountProduct({
    super.key,
    required this.productName,
    required this.stockController,
    required this.sellingController,
    required this.balanceController,
    required this.priceController,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            productName,
            style: TextStyle(fontSize: 10),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              Text("Stock"),
              NumberField(
                controller: stockController,
                readOnly: isReadOnly,
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              Text("Selling"),
              NumberField(
                controller: sellingController,
                readOnly: isReadOnly,
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              Text("Balance"),
              NumberField(
                controller: balanceController,
                readOnly: isReadOnly,
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              Text("Price"),
              NumberField(
                controller: priceController,
                readOnly: isReadOnly,
              ),
            ],
          ),
        ),
      ],
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
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
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
