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
        initProductListData();
        initCategoryListData();
        initChannelListData();
      }
    });
  }



  initProductListData() async {
    try {
      isLoading.value = true;
      final responseProduct = await Api.getAllProductSKU();
      if (responseProduct.status == "OK") {
        for (int i = 0; i < responseProduct.data!.length; i++) {
          supportDB.insertProduct(responseProduct.data![i]);
        }
      }
      else {
        print("error = ${responseProduct.message}");
      }
    } catch (e) {
      print("error = $e");
    } finally {
      isLoading.value = false;
    }
  }

  initCategoryListData() async {
    try {
      isLoading.value = true;
      final responseCategory = await Api.getCategoryList();
      if (responseCategory.status == "OK") {
        for (int i = 0; i < responseCategory.data!.length; i++) {
          supportDB.insertCategory(responseCategory.data![i]);
        }
      }else {
        print("error = ${responseCategory.message}");
      }
    } catch (e) {
      print("error = $e");
    } finally {
      isLoading.value = false;
    }
  }

  initChannelListData() async {
    try {
      isLoading.value = true;
      final responseChannel = await Api.getAllChannel();
      if (responseChannel.status == "OK") {
        for (int i = 0; i < responseChannel.data!.length; i++) {
          supportDB.insertChannel(responseChannel.data![i]);
        }
      }else {
        print("error = ${responseChannel.message}");
      }
    } catch (e) {
      print("error = $e");
    } finally {
      isLoading.value = false;
    }
  }
}
