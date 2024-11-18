import 'package:cetapil_mobile/controller/bottom_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/outlet/outlet_controller.dart';
import '../../controller/selling/selling_controller.dart';
import '../../utils/colors.dart';
import '../../widget/back_button.dart';
import '../../widget/clipped_maps.dart';
import '../../widget/dropdown_textfield.dart';
import '../../widget/text_field.dart';
import '../outlet/detail_outlet.dart';

class TambahSelling extends GetView<SellingController> {
  final TextEditingController _controller =
      TextEditingController(text: "asdasdas");

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EnhancedBackButton(
                onPressed: () {
                  Get.back();
                },
                backgroundColor: Colors.white,
                iconColor: Colors.blue,
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UnderlineTextField.readOnly(
                        title: "Nama Outlet",
                        value: "Guardian Setiabudi Building",
                      ),
                      CustomDropdown(
                          title: "Kategori Produk",
                          hint: "-- Pilih Kategori Produk --",
                          items: [
                            "asd",
                            "sdas",
                            "adsa",
                          ],
                          onChanged: (string) {}),
                      Text("Cleanser",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF023B5E))),
                      SumAmountProduct(
                        productName: "Cetaphil Exfoliate Cleanser 500ml",
                        stockController: TextEditingController(),
                        sellingController: TextEditingController(),
                        balanceController: TextEditingController(),
                      ),
                      Text("Baby Treatment",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF023B5E))),
                      SumAmountProduct(
                        productName:
                            "Cetaphil Baby Daily Lotion with Organic Calendula 400ml",
                        stockController: TextEditingController(),
                        sellingController: TextEditingController(),
                        balanceController: TextEditingController(),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      SumAmountProduct(
                        productName:
                            "Cetaphil Baby Daily Lotion with Organic Calendula 200ml",
                        stockController: TextEditingController(),
                        sellingController: TextEditingController(),
                        balanceController: TextEditingController(),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ModernTextField(
                              title: "Longitude",
                              controller: _controller,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ModernTextField(
                              title: "Latitude",
                              controller: _controller,
                            ),
                          ),
                        ],
                      ),
                      MapPreviewWidget(
                        latitude: -6.2088,
                        longitude: 106.8456,
                        zoom: 14.0,
                        height: 250,
                        borderRadius: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.blue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt),
                            SizedBox(height: 10,),
                            Text("Kualitas foto harus jelas dan tidak blur",style: TextStyle(fontSize: 9,color: Colors.blue),)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ))
    ]));
  }
}

class SumAmountProduct extends StatelessWidget {
  final String productName;
  final TextEditingController stockController;
  final TextEditingController sellingController;
  final TextEditingController balanceController;

  const SumAmountProduct({
    super.key,
    required this.productName,
    required this.stockController,
    required this.sellingController,
    required this.balanceController,
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
    ]);
  }
}

class NumberField extends StatelessWidget {
  final TextEditingController controller;
  const NumberField({
    super.key,
    required this.controller,
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
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF0077BD),
        ),
        decoration: InputDecoration(
          // hintText: widget.title,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFF64B5F6),
              width: 2,
            ),
          ),
          filled: true,
          fillColor: const Color(0xFFE8F3FF), // Light blue background
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
