import 'package:cetapil_mobile/controller/activity/tambah_activity_controller.dart';
import 'package:cetapil_mobile/controller/activity/tambah_availibility_controller.dart';
import 'package:cetapil_mobile/model/survey_question_response.dart';
import 'package:cetapil_mobile/widget/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controller/activity/detail_activity_controller.dart';
import '../../../controller/support_data_controller.dart';
import '../../../utils/price_formatter.dart';

class DetailSurveyPage extends GetView<DetailActivityController> {
  final SupportDataController supportController = Get.find<SupportDataController>();

  _buildSectionTitle(Map<String, dynamic> questionGroup) {
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

    // Handle special section titles
    String? sectionTitle;
    if (questionGroup['name'] == 'Visibility') {
      sectionTitle = "Survey Visibility";
    } else if (questionGroup['name'] == 'Recommendation') {
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

  buildSurveyQuestions(Map<String, dynamic> questionGroup) {
    return (questionGroup['surveys'] ?? []).map((survey) {
      final id = survey['id'] ?? '';
      if (survey['type'] == 'bool') {
        if (!controller.switchStates.containsKey(id)) {
          controller.switchStates[id] = true.obs; // Initialize with true for 'Ada'
        }
        return BooleanQuestion(
          title: survey['question'] ?? '',
          answer: survey['answer'],
          surveyId: id,
          controller: controller,
        );
      } else if (survey['type'] == 'text') {
        return PriceQuestion(
          title: survey['question'] ?? '',
          controller:  TextEditingController(text: survey['answer']),
        );
      }
      return const SizedBox.shrink();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var questionGroup = <Map<String, dynamic>>[];


      questionGroup = supportController.getSurvey().map((entry) {
        var surveys = entry['surveys'] as List;
        // var filteredSurveys = surveys.where((survey) {
        //   return controller.surveyItems.any((d) => d['survey_question_id'] == survey['id']);
        // }).toList();

        var filteredSurveys = surveys
            .where((survey) {
          return controller.surveyItems.any((d) => d['survey_question_id'] == survey['id']);
        })
            .map((survey) {
          var matchingItem = controller.surveyItems.firstWhere(
                  (d) => d['survey_question_id'] == survey['id']
          );
          return {
            ...survey,
            'answer': matchingItem['answer']
          };
        })
            .toList();

        // print(filteredSurveys);

        return {
          'id': entry['id'],
          'title': entry['title'],
          'name': entry['name'],
          'surveys': filteredSurveys
        };
      }).toList();

      // questionGroup = supportController.getSurvey();



      return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: questionGroup.length,
      itemBuilder: (context, index) {
        // print(questionGroup[5]);
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
  final String answer;
  final String surveyId;
  final DetailActivityController controller;

  const BooleanQuestion({
    super.key,
    required this.title,
    required this.surveyId,
    required this.controller, required this.answer,
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
           CustomSegmentedSwitch(
              value: answer.toLowerCase() == 'true',
              onChanged: (value) {
                // controller.toggleSwitch(surveyId, value);
              },
              activeColor: Colors.blue,
              inactiveColor: Colors.white,
            )
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

  const PriceQuestion({
    super.key,
    required this.title,
    required this.controller,
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
                readOnly: true,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0077BD),
                ),
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
