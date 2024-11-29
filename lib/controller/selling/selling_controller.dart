import 'package:cetapil_mobile/controller/gps_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

// import '../../model/outlet.dart';
import '../../model/outlet_example.dart';

class SellingController extends GetxController {
  final GPSLocationController gpsController = Get.find<GPSLocationController>();
  RxString searchQuery = ''.obs;
  RxList<Outlet> outlets = <Outlet>[].obs;
  final uuid = Uuid();

  var selectedCategory = 'MT'.obs;

  // Form Controllers
  var outletName = TextEditingController().obs;
  final List<String> categories = ['GT', 'MT'];
  // var outletSelling = TextEditingController().obs;
  // var outletAddress = TextEditingController().obs;
  // var controllers = <TextEditingController>[].obs;
  // var questions = <FormOutletResponse>[].obs;

  @override
  void onInit() {
    super.onInit();

    outlets.addAll([
      Outlet(
        id: uuid.v4(),
        outletName: 'Guardian Setiabudi Building',
        salesName: "Andromeda",
        category: 'GT',
        status: "APPROVED",
        address: "WONOGIRI",
        latitude: "123.00",
        longitude: "123.00",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Outlet(
        id: uuid.v4(),
        outletName: 'Guardian Setiabudi Building',
        salesName: "Andromeda",
        category: 'GT',
        status: "APPROVED",
        address: "WONOGIRI",
        latitude: "123.00",
        longitude: "123.00",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ]);
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<Outlet> get filteredOutlets => outlets.where((outlet) {
        return outlet.outletName.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();

  void clearForm() {
    outletName.value.clear();
    // outletSelling.value.clear();
    // outletAddress.value.clear();
  }
}
