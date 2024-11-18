import 'package:cetapil_mobile/widget/dropdown_textfield.dart';
import 'package:flutter/material.dart';

class VisibilityPage extends StatelessWidget {
  const VisibilityPage({super.key});

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
