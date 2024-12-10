
import '../../model/list_activity_response.dart' as Activity;
import 'package:get/get.dart';


class DetailActivityController extends GetxController {
  Rx<Activity.Data?> detailOutlet = Rx<Activity.Data?>(null);
  final selectedTab = 0.obs;

  void changeTab(int index) {
    selectedTab.value = index;
    update();
  }

  setDetailOutlet(Activity.Data data) {
    detailOutlet.value = data;
  }

  final availabilityDraftItems = <Map<String, dynamic>>[].obs;
  final orderDraftItems = <Map<String, dynamic>>[].obs;
  final visibilityDraftItems = <Map<String, dynamic>>[].obs;
}