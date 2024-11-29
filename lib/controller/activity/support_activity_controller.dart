import 'dart:async';

import 'package:cetapil_mobile/database/support_database.dart';
import 'package:get/get.dart';

import '../../api/api.dart';

class SupportActivityController extends GetxController {
  final supportDB = SupportDatabaseHelper.instance;
  Timer? _timer;
  var isLoading = false.obs;
  var data = [].obs;

  @override
  void onInit() {
    super.onInit();
    startTimeCheck();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startTimeCheck() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      if (now.hour == 0 && now.minute == 0) {
        initTemporaryData();
      }
    });
  }

  initTemporaryData() async {
    try {
      isLoading.value = true;
      final response = await Api.getAllProductSKU();
      if (response.status == "OK") {
        for (int i = 0; i < response.data!.length; i++) {
          supportDB.insertProduct(response.data![i]);
        }
      }
    } catch (e) {
      print("error = $e");
    } finally {
      isLoading.value = false;
    }
  }
}
