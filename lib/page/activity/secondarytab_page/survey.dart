import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/widget/custom_switch.dart';
import 'package:cetapil_mobile/widget/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widget/text_field.dart';

class SurveyPage extends GetView<TambahActivityController> {
  const SurveyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Apakah POWER SKU tersedia di toko ?",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 10,
          ),
          SwitchQuestion(
            title: "CETHAPIL Gentle Skin Cleanser 125ml",
            value: controller.switchValue.value,
            onChanged: (value) {
              controller.setSwitchValue(value);
            },
          ),
          SwitchQuestion(
            title: "CETHAPIL Gentle Skin Cleanser 500ml",
            value: controller.switchValue.value,
            onChanged: (value) {
              controller.setSwitchValue(value);
            },
          ),
          SwitchQuestion(
            title: "CETHAPIL Oily Skin Cleanser 125ml",
            value: controller.switchValue.value,
            onChanged: (value) {
              controller.setSwitchValue(value);
            },
          ),
          SwitchQuestion(
            title: "CETHAPIL Exfoliating Skin Cleanser 178ml",
            value: controller.switchValue.value,
            onChanged: (value) {
              controller.setSwitchValue(value);
            },
          ),
          SwitchQuestion(
            title: "CETHAPIL Moisturizing Lotion 200ml",
            value: controller.switchValue.value,
            onChanged: (value) {
              controller.setSwitchValue(value);
            },
          ),
          SwitchQuestion(
            title: "CETHAPIL Brightness Refresh Toner 150ml",
            value: controller.switchValue.value,
            onChanged: (value) {
              controller.setSwitchValue(value);
            },
          ),
          Text(
            "Berapa harga POWER SKU di toko ?",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 10,
          ),
          priceQuestion(title: "CETHAPIL Gentle Skin Cleanser 125ml",controller: controller.controller,),
          priceQuestion(title: "CETHAPIL Gentle Skin Cleanser 500ml",controller: controller.controller,),
          priceQuestion(title: "CETHAPIL Oily Skin Cleanser 125ml",controller: controller.controller,),
          priceQuestion(title: "CETHAPIL Exfoliating Skin Cleanser 178ml",controller: controller.controller,),
          priceQuestion(title: "CETHAPIL Moisturizing Lotion 200ml",controller: controller.controller,),
          priceQuestion(title: "CETHAPIL Brightness Refresh Toner 150ml",controller: controller.controller,),

          Text(
            "Berapa harga kompetitor di toko ? (masukan 0 jika tidak dijual)",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 10,
          ),
          priceQuestion(title: "Bioderma Sensibio H2O Micellar Water 100ml",controller: controller.controller,),
          priceQuestion(title: "Bioderma Sensibio H2O Micellar Water 500ml Pump",controller: controller.controller,),
          priceQuestion(title: "Bioderma Sensibio Defensive 40ml Antioxidant Soothing Moisturizer",controller: controller.controller,),
          priceQuestion(title: "Bioderma Gel Moussant 200ml Soothing Gentle Cleanser",controller: controller.controller,),

        ],
      );
    });
  }
}

class priceQuestion extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  const priceQuestion({
    super.key, required this.title, required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 40,
              width: 120,
              child: TextFormField(
                controller: controller,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0077BD),
                  ),
                  decoration: InputDecoration(
                    hintText: "Masukan Harga",
                    hintStyle: TextStyle(fontSize: 12,color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                  )),
            )
          ],
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}

class SwitchQuestion extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  SwitchQuestion({
    super.key,
    required this.title,
    required this.onChanged,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Text(
              title,
              style: TextStyle(fontSize: 12),
            )),
            SizedBox(
              width: 10,
            ),
            CustomSegmentedSwitch(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
