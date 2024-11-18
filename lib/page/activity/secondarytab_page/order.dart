import 'package:cetapil_mobile/widget/dropdown_textfield.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDropdown(
            hint: "-- Pilih kategori visibility --",
            items: [],
            onChanged: (String) {},
            title: "Jenis Visibility")
      ],
    );
  }
}
