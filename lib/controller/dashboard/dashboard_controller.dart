import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../widget/calendar_dialog.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;
  var currentDate = DateTime.now().obs;
  final List<String> imageUrls = [
    'assets/carousel1.png',
    'assets/carousel1.png',
    'assets/carousel1.png',
    'assets/carousel1.png',
  ];
  
  @override
  void onInit() {
    super.onInit();
    // Initialize Indonesian locale
    initializeDateFormatting('id_ID');
    // Update date every second
    ever(currentDate, (_) {}); // Setup reaction
    updateDate();
  }

  void updateDate() {
    // Update date every second
    Future.delayed(const Duration(seconds: 1), () {
      currentDate.value = DateTime.now();
      updateDate();
    });
  }

  String getIndonesianDay() {
    final day = DateFormat('EEEE', 'id_ID').format(currentDate.value);
    return day[0].toUpperCase() + day.substring(1);
  }

  String getIndonesianMonth() {
    final month = DateFormat('MMMM', 'id_ID').format(currentDate.value);
    return month[0].toUpperCase() + month.substring(1);
  }

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
