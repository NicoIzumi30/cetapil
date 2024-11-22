import 'package:cetapil_mobile/model/list_routing_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// import '../../model/outlet.dart';
import '../../api/api.dart';
import '../../database/database_instance.dart';
import '../../model/outlet_example.dart';

class RoutingController extends GetxController {
  RxString searchQuery = ''.obs;
  final db = DatabaseHelper.instance;
  RxList<Data> routing = <Data>[].obs;
  var isLoading = false.obs;
  var isSyncing = false.obs;
  final uuid = Uuid();

  @override
  void onInit() {
    super.onInit();
    initGetRouting();
    // outlets.addAll([
    //   Outlet(
    //     id: uuid.v4(),
    //     outletName: 'Guardian Setiabudi Building',
    //     salesName: "Andromeda",
    //     category: 'GT',
    //     status: "APPROVED",
    //     address: "WONOGIRI",
    //     latitude: "123.00",
    //     longitude: "123.00",
    //     createdAt: DateTime.now(),
    //     updatedAt: DateTime.now(),
    //   ),
    //   Outlet(
    //     id: uuid.v4(),
    //     outletName: 'Guardian Setiabudi Building',
    //     salesName: "Andromeda",
    //     category: 'GT',
    //     status: "APPROVED",
    //     address: "WONOGIRI",
    //     latitude: "123.00",
    //     longitude: "123.00",
    //     createdAt: DateTime.now(),
    //     updatedAt: DateTime.now(),
    //   ),
    // ]);
  }

  Future<void> syncOutlets() async {
    // try {
    //   isSyncing.value = true;
    //   EasyLoading.show(status: 'Syncing data...');
    //
    //   final apiResponse = await Api.getRoutingList();
    //   if (apiResponse.status != "OK") {
    //     throw Exception('Failed to get outlets from API');
    //   }
    //
    //   final apiOutlets = apiResponse.data ?? [];
    //   final localRouting = await db.getAllOutlets();
    //   final apiIds = apiOutlets.map((o) => o.id).toSet();
    //   final localIds = localRouting.map((o) => o.id).toSet();
    //   final idsToAdd = apiIds.difference(localIds);
    //   final idsToUpdate = apiIds.intersection(localIds);
    //   final idsToDelete = localIds
    //       .difference(apiIds)
    //       .where((id) => localRouting.firstWhere((o) => o.id == id).dataSource == 'API');
    //
    //   for (var id in idsToDelete) {
    //     await db.deleteOutlet(id!);
    //   }
    //
    //   for (var outlet in apiOutlets) {
    //     if (idsToAdd.contains(outlet.id) || idsToUpdate.contains(outlet.id)) {
    //       await db.upsertOutletFromApi(outlet);
    //     }
    //   }
    //
    //   final drafts = await db.getUnsyncedDraftOutlets();
    //   for (var draft in drafts) {
    //     try {
    //       await db.markOutletAsSynced(draft.id!);
    //     } catch (e) {
    //       print('Failed to sync draft outlet ${draft.id}: $e');
    //     }
    //   }
    //
    //   await loadOutlets();
    //
    //   Get.snackbar(
    //     'Sync Complete',
    //     'Outlets have been synchronized successfully',
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    // } catch (e) {
    //   print('Error syncing outlets: $e');
    //   Get.snackbar(
    //     'Sync Error',
    //     'Failed to sync outlets: $e',
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    // } finally {
    //   isSyncing.value = false;
    //   EasyLoading.dismiss();
    // }
  }

  initGetRouting()async {
    final response = await Api.getRoutingList();
    if (response.status == "OK" && response.data!.isNotEmpty) {
      routing.addAll(response.data!);
      db.insertRoutingWithAnswers(data: {});
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  String formatDate(DateTime now) {
    return DateFormat('EEEE, dd/MM/yyyy').format(now);
  }

  List<Data> get filteredOutlets => routing.where((routing) {
        return routing.name!
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase());
      }).toList();
}
