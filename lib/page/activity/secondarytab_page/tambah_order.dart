import 'package:cetapil_mobile/widget/back_button.dart';
import 'package:cetapil_mobile/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/activity/tambah_order_controller.dart';
import '../../../utils/colors.dart';
import '../../../widget/text_field.dart';

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    EnhancedBackButton(
                      onPressed: () {
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        controller: TextEditingController(
                            text: controller.filteredCategory),
                      )
                    : Container(
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
                          final categories =
                              controller.supportDataController.getCategories();
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
                    final skus =
                        controller.filteredSkus; // Get the filtered SKUs
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      itemCount: skus.length,
                      itemBuilder: (context, index) {
                        final sku = skus[index];
                        return CompactProductCard(
                          sku: sku,
                          onChanged: (values) => controller.updateProductValues(
                              sku['id'].toString(), values),
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

  // Widget _buildCategoryDropdown() {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 10),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(8),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.1),
  //           spreadRadius: 1,
  //           blurRadius: 3,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Obx(() {
  //       final categories = controller.supportDataController.getCategories();
  //       return DropdownButtonFormField<String>(
  //         style: const TextStyle(
  //           fontSize: 14,
  //           color: Color(0xFF0077BD),
  //         ),
  //         decoration: InputDecoration(
  //           contentPadding: const EdgeInsets.symmetric(
  //             horizontal: 16,
  //             vertical: 12,
  //           ),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(8),
  //             borderSide: BorderSide.none,
  //           ),
  //           filled: true,
  //           fillColor: const Color(0xFFE8F3FF),
  //         ),
  //         hint: Text(
  //           "-- Pilih Kategori --",
  //           style: TextStyle(
  //             color: Colors.grey[400],
  //             fontSize: 14,
  //           ),
  //         ),
  //         value: controller.selectedCategory.value,
  //         items: categories.map((category) {
  //           return DropdownMenuItem<String>(
  //             value: category['id'].toString(),
  //             child: Text(category['name'] ?? ''),
  //           );
  //         }).toList(),
  //         onChanged: controller.onCategorySelected,
  //         isExpanded: true,
  //       );
  //     }),
  //   );
  // }
  //
  // Widget _buildSkuDropdown() {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 10),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(8),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.1),
  //           spreadRadius: 1,
  //           blurRadius: 3,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Obx(() {
  //       final skus = controller.filteredSkus;
  //       return DropdownButtonFormField<String>(
  //         style: const TextStyle(
  //           fontSize: 14,
  //           color: Color(0xFF0077BD),
  //         ),
  //         decoration: InputDecoration(
  //           contentPadding: const EdgeInsets.symmetric(
  //             horizontal: 16,
  //             vertical: 12,
  //           ),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(8),
  //             borderSide: BorderSide.none,
  //           ),
  //           filled: true,
  //           fillColor: controller.selectedCategory.value != null
  //               ? const Color(0xFFE8F3FF)
  //               : Colors.grey[200],
  //         ),
  //         hint: Text(
  //           "-- Pilih SKU --",
  //           style: TextStyle(
  //             color: Colors.grey[400],
  //             fontSize: 14,
  //           ),
  //         ),
  //         value: controller.selectedSku.value,
  //         items: skus.map((sku) {
  //           return DropdownMenuItem<String>(
  //             value: sku['id'].toString(),
  //             child: Text(sku['sku'] ?? ''),
  //           );
  //         }).toList(),
  //         onChanged: controller.selectedCategory.value != null ? controller.onSkuSelected : null,
  //         isExpanded: true,
  //       );
  //     }),
  //   );
  // }
  //
  // Widget _buildSelectedSkuDetails() {
  //   return Obx(() => controller.selectedSkuData.value != null
  //       ? OrderDetailCard(
  //           productName: controller.selectedSkuData.value!['sku'] ?? '',
  //           jumlahController: controller.jumlahController.value,
  //           hargaController: controller.hargaController.value,
  //         )
  //       : Container(
  //           padding: EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             color: Colors.grey[100],
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: Center(
  //             child: Text(
  //               "Select a SKU to view product details",
  //               style: TextStyle(
  //                 color: Colors.grey[600],
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ),
  //         ));
  // }
  //
  // Widget _buildBottomButtons() {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: AppColors.primary,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //                 side: BorderSide(color: AppColors.primary),
  //               ),
  //             ),
  //             onPressed: () {
  //               controller.addOrderItem();
  //               controller.clearForm();
  //               Get.back();
  //             },
  //             child: Text(
  //               "Tambah & Kembali",
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ),
  //         SizedBox(width: 10),
  //         Expanded(
  //           child: ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //                 side: BorderSide(color: AppColors.primary),
  //               ),
  //             ),
  //             onPressed: () {
  //               controller.addOrderItem();
  //               controller.clearForm();
  //             },
  //             child: Text(
  //               "Tambah & Lanjut",
  //               style: TextStyle(
  //                 color: AppColors.primary,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
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
  late TextEditingController jumlahController;
  late TextEditingController hargaController;
   double totalPrice = 0;
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: "", decimalDigits: 0);

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
    final controller = Get.find<TambahOrderController>();
    final skuId = widget.sku['id'].toString();
    final existingValues = controller.productValues[skuId] ??
        {
          'jumlah': '0',
          'harga': '0',
        };

    jumlahController = TextEditingController(text: existingValues['jumlah']);
    hargaController = TextEditingController(text: formatter.format(widget.sku['price']));

    _setupListeners();
  }

  void _setupListeners() {
    void updateValues() {
      widget.onChanged({
        'jumlah': jumlahController.text.isEmpty ? '0' : jumlahController.text,
        'harga': formatter.format(widget.sku['price']).toString(),
      });
    }

    jumlahController.addListener(updateValues);
    hargaController.addListener(updateValues);
  }

  @override
  void dispose() {
    jumlahController.dispose();
    hargaController.dispose();
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
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: buildInputField('Jumlah', jumlahController)),
                    SizedBox(width: 8),
                    Expanded(
                        child: _buildDetailField(
                      'Harga',
                     hargaController
                    )),
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
                    Text("Rp. ${formatter.format(totalPrice)}"),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
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
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              setState(() {
                if (value.isEmpty) {
                  totalPrice = 0.0;
                } else{
                  try {
                    totalPrice = widget.sku['price'] * int.parse(value);
                  } catch (e) {
                    totalPrice = 0.0;
                  }
                }
              });


            },
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
          ),
        )
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
        onChanged: (value) {},
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
