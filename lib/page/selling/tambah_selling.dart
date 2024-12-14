import 'dart:io';

import 'package:cetapil_mobile/utils/image_upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await Alerts.showConfirmDialog(context);
        return shouldPop ?? false;
      },
      child: SafeArea(
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
              body: Stack(
                children: [
                  Padding(
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
                                  selectedCategoryGetter: (controller) =>
                                      controller.selectedCategory,
                                  categoriesGetter: (controller) => controller.categories,
                                ),
                                Text(
                                  "Produk",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF023B5E)),
                                ),
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
                                SizedBox(height: 20),
                                Obx(() {
                                  if (controller.draftItems.isEmpty) {
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
                                  for (var item in controller.draftItems) {
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
                                              if (!Get.isRegistered<
                                                  TambahProdukSellingController>()) {
                                                Get.put(TambahProdukSellingController());
                                              }
                                              final prodController =
                                                  Get.find<TambahProdukSellingController>();

                                              // Find the category ID from the name
                                              final categoryId =
                                                  prodController.supportDataController
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
                                                  'stock': item['stock'].toString(),
                                                  'selling': item['selling'].toString(),
                                                  'balance': item['balance'].toString(),
                                                  'price': item['price'].toString(),
                                                };
                                              }

                                              // Navigate to edit screen
                                              await Get.to(() => TambahProductSelling());
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  );
                                }),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Obx(() => TextField(
                                            readOnly: true,
                                            controller: TextEditingController(
                                                text: controller.gpsController.currentPosition.value
                                                        ?.longitude
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
                                                text: controller.gpsController.currentPosition.value
                                                        ?.latitude
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
                                _buildImageUploader(
                                  context,
                                  "Foto",
                                  controller,
                                ),
                                SizedBox(height: 70),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(() => ElevatedButton(
                                      onPressed: controller.isSaving.value
                                          ? null
                                          : controller.saveDraftSelling,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          side: BorderSide(color: AppColors.primary),
                                        ),
                                      ),
                                      child: controller.isSaving.value
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: AppColors.primary,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(
                                              'Simpan Draft',
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    )),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => controller.submitApiSelling(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide.none,
                                    ),
                                  ),
                                  child: Text(
                                    'Kirim',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploader(
    BuildContext context,
    String title,
    SellingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Obx(() {
          final image = controller.sellingImage.value;
          final isUploading = controller.isImageUploading.value;

          return GestureDetector(
            onTap: isUploading
                ? null
                : () async {
                    final File? result = await ImageUploadUtils.showImageSourceSelection(context,
                        currentImage: image);

                    if (result != null) {
                      controller.updateImage(result);
                    }
                  },
            child: Container(
              width: double.infinity,
              height: 200,
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Color(0xFFEDF8FF),
                border: Border.all(
                  color: Colors.blue,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
                image: image != null
                    ? DecorationImage(
                        image: FileImage(image),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: isUploading
                  ? Center(child: CircularProgressIndicator())
                  : image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, color: Colors.black),
                            Text(
                              "Klik disini untuk ambil foto dengan kamera",
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              "Kualitas foto harus jelas dan tidak blur",
                              style: TextStyle(fontSize: 7, color: Colors.blue),
                            ),
                          ],
                        )
                      : Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Positioned(
                              right: 4,
                              top: 4,
                              child: GestureDetector(
                                onTap: () => controller.updateImage(null),
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
          );
        }),
      ],
    );
  }
}

class CollapsibleCategoryGroup extends StatefulWidget {
  final String category;
  final List<Map<String, dynamic>> items;
  final VoidCallback onEdit;

  const CollapsibleCategoryGroup({
    Key? key,
    required this.category,
    required this.items,
    required this.onEdit,
  }) : super(key: key);

  @override
  State<CollapsibleCategoryGroup> createState() => _CollapsibleCategoryGroupState();
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
                    IconButton(
                      onPressed: widget.onEdit,
                      icon: Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      tooltip: 'Edit Category Products',
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
                  stockController: TextEditingController(
                    text: item['stock'].toString(),
                  ),
                  sellingController: TextEditingController(
                    text: item['selling'].toString(),
                  ),
                  balanceController: TextEditingController(
                    text: item['balance'].toString(),
                  ),
                  priceController: TextEditingController(
                    text: item['price'].toString(),
                  ),
                  isReadOnly: true,
                  itemData: item,
                  onDelete: () {},
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
  final TextEditingController stockController;
  final TextEditingController sellingController;
  final TextEditingController balanceController;
  final TextEditingController priceController;
  final bool isReadOnly;
  final VoidCallback onDelete;
  final Map<String, dynamic> itemData;

  const SumAmountProduct({
    super.key,
    required this.productName,
    required this.stockController,
    required this.sellingController,
    required this.balanceController,
    required this.priceController,
    required this.onDelete,
    required this.itemData,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16, top: 8, right: 8),
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
            child: Row(
              children: [
                _buildDetailField("Stock", stockController),
                SizedBox(width: 12),
                _buildDetailField("Selling", sellingController),
                SizedBox(width: 12),
                _buildDetailField("Balance", balanceController),
                SizedBox(width: 12),
                _buildDetailField("Price", priceController),
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
              fontSize: 12,
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
