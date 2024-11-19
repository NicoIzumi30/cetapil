import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../model/outlet.dart';
import '../../model/outlet_example.dart';

class SellingController extends GetxController {
  RxString searchQuery = ''.obs;
  RxList<Outlet> outlets = <Outlet>[].obs;
  final uuid = Uuid();

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
    return outlet.outletName
        .toLowerCase()
        .contains(searchQuery.value.toLowerCase());
  }).toList();

}