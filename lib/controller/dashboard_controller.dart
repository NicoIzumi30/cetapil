

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../widget/calendar_dialog.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;
  final List<String> imageUrls = [
    'assets/carousel1.png',
    'assets/carousel1.png',
    'assets/carousel1.png',
    'assets/carousel1.png',
  ];


  void showCustomCalendarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomCalendarDialog(
        initialDate: DateTime.now(),
        onDateSelected: (date) {
          print('Selected date: ${DateFormat('yyyy-MM-dd').format(date)}');
          Navigator.pop(context);
        },
      ),
    );
  }
}