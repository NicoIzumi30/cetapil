import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/page/activity/secondarytab_page/tambah_primary_visibility.dart';
import 'package:cetapil_mobile/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controller/activity/tambah_availibility_controller.dart';
import '../../../model/list_product_sku_response.dart';
import '../../../model/list_category_response.dart' as Category;
import '../../../utils/colors.dart';
import '../../../widget/back_button.dart';
import '../../../widget/custom_switch.dart';
import '../../../widget/text_field.dart';
import '../../selling/tambah_product_selling.dart';

class TambahAvailability extends GetView<TambahAvailabilityController> {
  const TambahAvailability({super.key});

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
                      useGetBack: false,
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
                controller.selectedCategory.value != null
                ? ModernTextField(
                  enable: false,
                  title: "Kategori",
                  controller:
                  TextEditingController(text: controller.filteredCategory),
                )
                :
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
                ),
                // Expanded(
                //   child: SingleChildScrollView(
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           "Kategori",
                //           style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                //         ),
                //         SizedBox(height: 10),
                //         _buildCategoryDropdown(),
                //         SizedBox(height: 20),
                //         Text(
                //           "SKU",
                //           style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                //         ),
                //         SizedBox(height: 10),
                //         _buildSkuDropdown(),
                //         SizedBox(height: 20),
                //         Text(
                //           "Selected SKU",
                //           style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                //         ),
                //         SizedBox(height: 10),
                //         _buildSelectedSkuDetails(),
                //       ],
                //     ),
                //   ),
                // ),
                // _buildBottomButtons(),
              ],
            ),
          ),
        ],
      ),
    );
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
  late TambahAvailabilityController controller = Get.find<TambahAvailabilityController>();

  late TextEditingController stockOnHandController;
  late TextEditingController stockOnInventoryController;
  late TextEditingController av3mController;
  late TextEditingController recommendController;
  late ValueNotifier<bool> toggleAvailabilityYesNo;

  String checkStatus(String number) {
    int num = int.parse(number);
    if (num < 0) {
      return "Kurang   ";
    } else if (num > 0) {
      return "Over   ";
    } else {
      return "Ideal   ";
    }
  }

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
    final controller = Get.find<TambahAvailabilityController>();
    final skuId = widget.sku['id'].toString();
    final existingValues = controller.productValues[skuId] ??
        {
          'availability_toggle': "false",
          'stock_on_hand': '0',
          'stock_on_inventory': '0',
          'av3m': '0',
          'recommend': '0',
        };

    toggleAvailabilityYesNo = existingValues['availability_toggle'] == "false" ? ValueNotifier(false) : ValueNotifier(true);
    stockOnHandController = TextEditingController(text: existingValues['stock_on_hand']);
    stockOnInventoryController = TextEditingController(text: existingValues['stock_on_inventory']);
    av3mController = TextEditingController(text: existingValues['av3m']);
    recommendController = TextEditingController(text: existingValues['recommend']);
    // priceController = TextEditingController(text: existingValues['price']);

    _setupListeners();
  }

  void _setupListeners() {
    void updateValues() {
      widget.onChanged({
        'availability_toggle': toggleAvailabilityYesNo.value ? 'true' : 'false',
        'stock_on_hand': stockOnHandController.text.isEmpty ? '0' : stockOnHandController.text,
        'stock_on_inventory': stockOnInventoryController.text.isEmpty ? '0' : stockOnInventoryController.text,
        'av3m': av3mController.text.isEmpty ? '0' : av3mController.text,
        'recommend': recommendController.text.isEmpty ? '0' : recommendController.text,
        // 'price': priceController.text.isEmpty ? '0' : priceController.text,
      });
    }

    toggleAvailabilityYesNo.addListener(updateValues);
    stockOnHandController.addListener(updateValues);
    stockOnInventoryController.addListener(updateValues);
    av3mController.addListener(updateValues);
    recommendController.addListener(updateValues);
  }

  @override
  void dispose() {
    toggleAvailabilityYesNo.removeListener(() {});
    toggleAvailabilityYesNo.dispose();
    stockOnHandController.dispose();
    stockOnInventoryController.dispose();
    av3mController.dispose();
    recommendController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
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
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: 24,
                    color: Color(0xFF0077BD),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.sku['sku'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF023B5E),
                        ),
                      ),
                      Text(
                        widget.sku['category']['name'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Availability ?",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
    CustomSegmentedSwitch(
                      value: toggleAvailabilityYesNo.value,
                      onChanged: (value) {
                        setState(() {
                          toggleAvailabilityYesNo.value = !toggleAvailabilityYesNo.value;
                        });
                      },
                      activeColor: Colors.blue,
                      inactiveColor: Colors.white,
                    ),
                  ],
                ),
                Divider(color: Colors.grey,),
                Text("Stock",style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF666666),
                  fontStyle: FontStyle.italic
                ),),
                Row(
                  children: [
                    Expanded(child: _buildInputField('On Hand', stockOnHandController)),
                    SizedBox(width: 8),
                    Expanded(child: buildInputInventory('On Inventory', stockOnInventoryController)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildInputField('AV3M', av3mController)),
                    SizedBox(width: 8),
                    Expanded(child: _buildDetailField('Recommend', recommendController,)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Status",style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF666666),
                        fontStyle: FontStyle.italic
                    ),),
                    Text(checkStatus(recommendController.text),style: TextStyle(
                    fontWeight: FontWeight.bold,
                        color: Colors.blue,
    ),),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputInventory(String label, TextEditingController controller) {
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
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0077BD),
            ),
            onChanged: (value){
              setState(() {
                if (value.isEmpty) {
                  recommendController.text = "0";
                }else{
                  try {
                    recommendController.text = (int.parse(value) - int.parse(av3mController.text)).toString();
                  } catch (e) {
                    recommendController.text = "0";
                  }
                }
              });
            },
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              FilteringTextInputFormatter.digitsOnly, // Only allows digits
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
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF64B5F6),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ],
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

  Widget _buildDetailField(String label, TextEditingController controller) {
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
          readOnly: true,
        ),
      ],
    );
  }
}

class SumAmountProduct extends StatefulWidget {
  final String productName;
  final TextEditingController stockController;
  final TextEditingController AV3MController;
  final TextEditingController recommendController;

  const SumAmountProduct({
    super.key,
    required this.productName,
    required this.stockController,
    required this.AV3MController,
    required this.recommendController,
  });

  @override
  State<SumAmountProduct> createState() => _SumAmountProductState();
}

class _SumAmountProductState extends State<SumAmountProduct> {
  @override
  void initState() {
    super.initState();
    widget.stockController.addListener(_calculateRecommend);
  }

  @override
  void dispose() {
    widget.stockController.removeListener(_calculateRecommend);
    super.dispose();
  }

  void _calculateRecommend() {
    try {
      int stock = int.tryParse(widget.stockController.text) ?? 0;
      int av3m = int.tryParse(widget.AV3MController.text) ?? 0;
      int recommend = stock - av3m;
      widget.recommendController.text = recommend.toString();
    } catch (e) {
      widget.recommendController.text = '0';
    }
  }

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
                        widget.productName,
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
                _buildDetailField("Stock", widget.stockController),
                SizedBox(width: 12),
                _buildDetailField("AV3M(Pcs)", widget.AV3MController, readOnly: true),
                SizedBox(width: 12),
                _buildDetailField("Recommend", widget.recommendController, readOnly: true),
              ],
            ),
          ),
        ],
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
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF0077BD),
        ),
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
          FilteringTextInputFormatter.digitsOnly, // Only allows digits
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
          disabledBorder: OutlineInputBorder(
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
