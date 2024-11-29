import 'package:cetapil_mobile/controller/selling/selling_controller.dart';
import 'package:cetapil_mobile/widget/back_button.dart';
import 'package:cetapil_mobile/widget/dropdown_textfield.dart';
import 'package:cetapil_mobile/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TambahProductSelling extends GetView<SellingController> {
  const TambahProductSelling({super.key});

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
                      ModernTextField(
                        title: "Nama Outlet",
                        controller: controller.outletName.value,
                      ),
                      CustomDropdown(
                          title: "Kategori Produk",
                          hint: "-- Pilih Kategori Produk --",
                          items: ["asdasd", "asda"].map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item ?? ''), // Display the name
                            );
                          }).toList(),
                          onChanged: (string) {}),
                    ],
                  ),
                ),
              )
            ],
          ))
    ]));
  }
}
