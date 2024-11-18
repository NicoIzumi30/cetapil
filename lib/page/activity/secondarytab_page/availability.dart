import 'package:cetapil_mobile/widget/dropdown_textfield.dart';
import 'package:flutter/material.dart';

class AvailabilityPage extends StatelessWidget {
  const AvailabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDropdown(
            hint: "-- Pilih kategori produk --",
            items: [],
            onChanged: (String) {},
            title: "Kategori Produk")
      ],
    );
  }
}
