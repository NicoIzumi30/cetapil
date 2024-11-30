import 'package:cetapil_mobile/controller/selling/tambah_produk_selling_controller.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/availability.dart';
import 'package:cetapil_mobile/utils/colors.dart';
import 'package:cetapil_mobile/widget/back_button.dart';
import 'package:flutter/material.dart';
import '../../../model/list_category_response.dart' as Category;
import '../../../model/list_product_sku_response.dart' as SKU;
import 'package:get/get.dart';

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
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EnhancedBackButton(
                  onPressed: () => Get.back(),
                  backgroundColor: Colors.white,
                  iconColor: Colors.blue,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Dropdown
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
                            print("categories $categories");
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

                        // SKU Dropdown
                        SizedBox(height: 10),
                        Text(
                          "SKU",
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
                              onChanged: controller.selectedCategory.value != null
                                  ? controller.onSkuSelected
                                  : null,
                              isExpanded: true,
                            );
                          }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Selected SKU",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Obx(() => controller.selectedSkuData != null
                            ? SumAmountProduct(
                                productName: controller.selectedSkuData!['sku'] ?? '',
                                stockController: controller.stockController.value,
                                sellingController: controller.sellingController.value,
                                balanceController: controller.balanceController.value,
                                priceController: controller.priceController.value,
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
                              )),
                      ],
                    ),
                  ),
                ),
                Padding(
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
                            controller.addProductItems();
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
                            controller.addProductItems();
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
                ),
              ],
            ),
          )
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
            Text("Stock"),
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
            Text("Selling"),
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
            Text("Balance"),
            NumberField(
              controller: balanceController,
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
            Text("Price"),
            NumberField(
              controller: priceController,
            ),
          ],
        ),
      ),
    ]);
  }
}
