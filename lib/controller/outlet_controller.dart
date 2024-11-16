// outlet_controller.dart
import 'package:get/get.dart';

import '../model/outlet.dart';

class OutletController extends GetxController {
  RxList<Outlet> outlets = <Outlet>[].obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with dummy data
    outlets.addAll([
      Outlet(
        name: 'Guardian Setiabudi Building',
        category: 'GT',
        image: 'assets/carousel1.png',
      ),
      Outlet(
        name: 'CV Jaya Makmur Sentosa',
        category: 'MT',
        image: 'assets/carousel1.png',
      ),
      Outlet(
        name: 'Alfamart Senen Raya',
        category: 'GT',
        image: 'assets/carousel1.png',
      ),
      Outlet(
        name: 'Alfamart Thamrin City',
        category: 'GT',
        image: 'assets/carousel1.png',
      ),
      Outlet(
        name: 'Guardian Setiabudi Building',
        category: 'MT',
        image: 'assets/carousel1.png',
      ),
    ]);
  }

  List<Outlet> get filteredOutlets => outlets.where((outlet) {
    return outlet.name.toLowerCase().contains(searchQuery.value.toLowerCase());
  }).toList();

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}