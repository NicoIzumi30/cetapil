import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_availibility_controller.dart';
import 'package:cetapil_mobile/model/survey_question_response.dart';
import 'package:cetapil_mobile/widget/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controller/support_data_controller.dart';
import '../../../utils/price_formatter.dart';

class SurveyPage extends GetView<TambahActivityController> {
  final SupportDataController supportController = Get.find<SupportDataController>();

  SurveyPage({super.key}) {
    // Initialize controllers in constructor
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   initializeControllers();
    // });
  }

  void initializeControllers() {
    final questionGroups = supportController.getSurvey();
    for (var group in questionGroups) {
      for (var survey in (group['surveys'] as List<dynamic>? ?? [])) {
        final id = survey['id']?.toString() ?? '';
        if (survey['type'] == 'text' && !controller.priceControllers.containsKey(id)) {
          controller.priceControllers[id] = TextEditingController();
        }
        if (survey['type'] == 'bool' && !controller.switchStates.containsKey(id)) {
          controller.switchStates[id] = true.obs;
        }
      }
    }
  }

  Widget _buildSectionTitle(Map<String, dynamic> questionGroup) {
    if (questionGroup['title'] != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            questionGroup['title']!,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
        ],
      );
    }

    String? sectionTitle;
    if (questionGroup['name'] == 'Visibility') {
      sectionTitle = "Survey Visibility";
    } else if (questionGroup['name'] == 'Recommndation') {
      sectionTitle = "Survey Recommendation";
    }

    if (sectionTitle != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionTitle,
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xff0077BD),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  List<Widget> buildSurveyQuestions(Map<String, dynamic> questionGroup) {
    var question = (questionGroup['surveys'] as List<dynamic>? ?? []).map((survey) {
      final id = survey['id']?.toString() ?? '';

      if (survey['type'] == 'bool') {
        if (questionGroup['title'] == "Apakah POWER SKU tersedia di toko?") {
          return BooleanQuestion(
            title: survey['question'] ?? '',
            surveyId: id,
            controller: controller,
            enable: false,
          );
        }
        return BooleanQuestion(
          title: survey['question'] ?? '',
          surveyId: id,
          controller: controller,
        );
      } else if (survey['type'] == 'text') {
        final textController = controller.priceControllers[id];
        if (textController == null) return const SizedBox.shrink();

        if (survey['question'] ==
            'Berapa kali di Kuartal ini pernah dijalankan product detailing di toko ini?') {
          return TextQuestion(
            title: survey['question'] ?? '',
            controller: textController,
            enable: false,
          );
        }
        return PriceQuestion(
          title: survey['question'] ?? '',
          controller: textController,
        );
      }
      return const SizedBox.shrink();
    }).toList();
    print(question);
    return question;
  }

  @override
  Widget build(BuildContext context) {
    // Run the initialization after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeControllers();
    });
    return Obx(() {
      var questionGroup = <Map<String, dynamic>>[];
      if (controller.detailDraft.isNotEmpty) {
        final data = controller.detailDraft['surveyItems'];

        questionGroup = supportController.getSurvey().map((entry) {
          var surveys = entry['surveys'] as List;
          var filteredSurveys = surveys.where((survey) {
            return data.any((d) => d['survey_id'] == survey['id']);
          }).toList();

          return {
            'id': entry['id'],
            'title': entry['title'],
            'name': entry['name'],
            'surveys': filteredSurveys
          };
        }).toList();
      } else {
        questionGroup = supportController.getSurvey();
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: questionGroup.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(questionGroup[index]),
              ...buildSurveyQuestions(questionGroup[index]),
              const SizedBox(height: 20),
            ],
          );
        },
      );
    });
  }
}

class BooleanQuestion extends StatelessWidget {
  final String title;
  final String surveyId;
  final TambahActivityController controller;
  final bool enable;

  const BooleanQuestion({
    super.key,
    required this.title,
    required this.surveyId,
    required this.controller,
    this.enable = true,
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
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 10),
            Obx(() => CustomSegmentedSwitch(
                  value: !controller.getSwitchValue(surveyId),
                  onChanged: (value) {
                    controller.toggleSwitch(surveyId, value);
                  },
                  activeColor: Colors.blue,
                  inactiveColor: Colors.white,
                  enable: enable,
                )),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class PriceQuestion extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool enable;

  const PriceQuestion({
    super.key,
    required this.title,
    required this.controller,
    this.enable = true,
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
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 40,
              width: 140,
              child: TextFormField(
                controller: controller,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0077BD),
                ),
                onChanged: (_) => Get.find<TambahActivityController>().priceControllers.refresh(),
                keyboardType: const TextInputType.numberWithOptions(decimal: false), // Only numbers
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                  // Custom formatter to add thousand separators
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    if (newValue.text.isEmpty) {
                      return newValue;
                    }
                    final number = int.tryParse(newValue.text.replaceAll(',', ''));
                    if (number != null) {
                      final formatted = number.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
                      return TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(offset: formatted.length),
                      );
                    }
                    return oldValue;
                  }),
                ],
                enabled: enable,
                decoration: InputDecoration(
                  prefixText: 'Rp ', // Add currency prefix
                  prefixStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0077BD),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  alignLabelWithHint: true,
                  hintText: "Masukan Harga",
                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                textAlign: TextAlign.right, // Align numbers to the right
                textAlignVertical: TextAlignVertical.center,
              ),
            )
          ],
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}

class TextQuestion extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool enable;

  const TextQuestion({
    super.key,
    required this.title,
    required this.controller,
    this.enable = true,
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
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 40,
              width: 140,
              child: TextFormField(
                controller: controller,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0077BD),
                ),
                enabled: enable,
                onChanged: (_) => Get.find<TambahActivityController>().priceControllers.refresh(),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  alignLabelWithHint: true,
                  hintText: "",
                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                textAlign: TextAlign.right, // Align numbers to the right
                textAlignVertical: TextAlignVertical.center,
              ),
            )
          ],
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}

// import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
// import 'package:cetapil_mobile/widget/custom_switch.dart';
// import 'package:cetapil_mobile/widget/dropdown_textfield.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../utils/price_formatter.dart';
// import '../../../widget/text_field.dart';

// class SurveyPage extends GetView<TambahActivityController> {
//   const SurveyPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Apakah POWER SKU tersedia di toko ?",
//             style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           SwitchQuestion(
//             title: "CETHAPIL Gentle Skin Cleanser 125ml",
//             value: controller.switchValue.value,
//             onChanged: (value) {
//               controller.setSwitchValue(value);
//             },
//           ),
//           SwitchQuestion(
//             title: "CETHAPIL Gentle Skin Cleanser 500ml",
//             value: controller.switchValue.value,
//             onChanged: (value) {
//               controller.setSwitchValue(value);
//             },
//           ),
//           SwitchQuestion(
//             title: "CETHAPIL Oily Skin Cleanser 125ml",
//             value: controller.switchValue.value,
//             onChanged: (value) {
//               controller.setSwitchValue(value);
//             },
//           ),
//           SwitchQuestion(
//             title: "CETHAPIL Exfoliating Skin Cleanser 178ml",
//             value: controller.switchValue.value,
//             onChanged: (value) {
//               controller.setSwitchValue(value);
//             },
//           ),
//           SwitchQuestion(
//             title: "CETHAPIL Moisturizing Lotion 200ml",
//             value: controller.switchValue.value,
//             onChanged: (value) {
//               controller.setSwitchValue(value);
//             },
//           ),
//           SwitchQuestion(
//             title: "CETHAPIL Brightness Refresh Toner 150ml",
//             value: controller.switchValue.value,
//             onChanged: (value) {
//               controller.setSwitchValue(value);
//             },
//           ),
//           Text(
//             "Berapa harga POWER SKU di toko ?",
//             style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           priceQuestion(title: "CETHAPIL Gentle Skin Cleanser 125ml",controller: controller.controller,),
//           priceQuestion(title: "CETHAPIL Gentle Skin Cleanser 500ml",controller: controller.controller,),
//           priceQuestion(title: "CETHAPIL Oily Skin Cleanser 125ml",controller: controller.controller,),
//           priceQuestion(title: "CETHAPIL Exfoliating Skin Cleanser 178ml",controller: controller.controller,),
//           priceQuestion(title: "CETHAPIL Moisturizing Lotion 200ml",controller: controller.controller,),
//           priceQuestion(title: "CETHAPIL Brightness Refresh Toner 150ml",controller: controller.controller,),

//           Text(
//             "Berapa harga kompetitor di toko ? (masukan 0 jika tidak dijual)",
//             style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           priceQuestion(title: "Bioderma Sensibio H2O Micellar Water 100ml",controller: controller.controller,),
//           priceQuestion(title: "Bioderma Sensibio H2O Micellar Water 500ml Pump",controller: controller.controller,),
//           priceQuestion(title: "Bioderma Sensibio Defensive 40ml Antioxidant Soothing Moisturizer",controller: controller.controller,),
//           priceQuestion(title: "Bioderma Gel Moussant 200ml Soothing Gentle Cleanser",controller: controller.controller,),

//         ],
//       );
//     });
//   }
// }

// class priceQuestion extends StatelessWidget {
//   final String title;
//   final TextEditingController controller;
//   const priceQuestion({
//     super.key, required this.title, required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 title,
//                 style: TextStyle(fontSize: 12),
//               ),
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             SizedBox(
//               height: 40,
//               width: 120,
//               child: TextFormField(
//                 controller: controller,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF0077BD),
//                   ),
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [NumberInputFormatter()],
//                   decoration: InputDecoration(
//                     hintText: "Masukan Harga",
//                     hintStyle: TextStyle(fontSize: 12,color: Colors.grey[400]),
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide.none),
//                   )),
//             )
//           ],
//         ),
//         SizedBox(height: 10,)
//       ],
//     );
//   }
// }

// class SwitchQuestion extends StatelessWidget {
//   final String title;
//   final bool value;
//   final Function(bool) onChanged;

//   SwitchQuestion({
//     super.key,
//     required this.title,
//     required this.onChanged,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//                 child: Text(
//               title,
//               style: TextStyle(fontSize: 12),
//             )),
//             SizedBox(
//               width: 10,
//             ),
//             CustomSegmentedSwitch(
//               value: value,
//               onChanged: onChanged,
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 10,
//         )
//       ],
//     );
//   }
// }
