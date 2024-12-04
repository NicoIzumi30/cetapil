
import 'package:cetapil_mobile/controller/activity/activity_controller.dart';
import 'package:cetapil_mobile/controller/routing/routing_controller.dart';
import 'package:cetapil_mobile/controller/selling/selling_controller.dart';
import 'outlet/outlet_controller.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  final OutletController outletController = Get.find<OutletController>();
  final RoutingController routingController = Get.find<RoutingController>();
  final ActivityController activityController = Get.find<ActivityController>();
  final SellingController sellingController = Get.find<SellingController>();

  var selectedIndex = 0.obs;


  void changeIndex(int index) {
    selectedIndex.value = index;
    outletController.searchQuery.value = "";
    routingController.searchQuery.value = "";
    activityController.searchQuery.value = "";
    sellingController.searchQuery.value = "";
  }
}