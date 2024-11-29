


import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../api/api.dart';
import '../../database/database_instance.dart';
import '../../model/outlet.dart';
import '../outlet/outlet_controller.dart';

class TambahRoutingController extends GetxController {
  final OutletController outletController = Get.find<OutletController>();
  final db = DatabaseHelper.instance;
  var outlets = <Outlet>[].obs;
  var isLoading = false.obs;
  var isSyncing = false.obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadOutlets(); // Only load from SQLite initially
  }

  List<Outlet> get filteredOutlets {
    if (searchQuery.value.isEmpty) {
      return outlets;
    }

    final filtered = outlets.where((outlet) {
      return outlet.name?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false;
    }).toList();

    // Keep drafts at top in filtered results
    // filtered.sort((a, b) {
    //   if (a.dataSource == 'DRAFT' && b.dataSource != 'DRAFT') {
    //     return -1;
    //   }
    //   if (a.dataSource != 'DRAFT' && b.dataSource == 'DRAFT') {
    //     return 1;
    //   }
    //   return 0;
    // });

    return filtered;
  }

  bool _hasChanges(Outlet local, Outlet api) {
    // Always skip sync for drafts
    if (local.dataSource == 'DRAFT') {
      return false;
    }

    return local.name != api.name ||
        local.address != api.address ||
        local.latitude != api.latitude ||
        local.longitude != api.longitude ||
        local.city?.id != api.city?.id ||
        local.city?.name != api.city?.name ||
        local.category != api.category;
  }

  Future<void> _batchDelete(List<String> ids) async {
    const batchSize = 100;
    for (var i = 0; i < ids.length; i += batchSize) {
      final end = (i + batchSize < ids.length) ? i + batchSize : ids.length;
      final batch = ids.sublist(i, end);
      await Future.wait(batch.map((id) => db.deleteOutlet(id)));
    }
  }

  Future<void> _batchUpsert(List<Outlet> outlets) async {
    const batchSize = 100;
    for (var i = 0; i < outlets.length; i += batchSize) {
      final end = (i + batchSize < outlets.length) ? i + batchSize : outlets.length;
      final batch = outlets.sublist(i, end);

      // Get existing outlets to check draft status
      final existingOutlets =
      await Future.wait(batch.map((outlet) => db.getOutletById(outlet.id!)));

      // Create a list of futures for upsert operations
      final futures = batch.asMap().entries.map((entry) {
        final index = entry.key;
        final outlet = entry.value;

        // If the existing outlet is a draft, preserve its draft status
        if (existingOutlets[index]?.dataSource == 'DRAFT') {
          final modifiedOutlet = Outlet(
              id: outlet.id,
              name: outlet.name,
              address: outlet.address,
              latitude: outlet.latitude,
              longitude: outlet.longitude,
              category: outlet.category,
              channel_id: outlet.channel_id,
              channel_name: outlet.channel_name,
              city: outlet.city, // Use the city object directly
              images: outlet.images,
              forms: outlet.forms,
              user: outlet.user,
              dataSource: 'DRAFT', // Preserve draft status
              status: outlet.status,
              visitDay: outlet.visitDay,
              weekType: outlet.weekType,
              cycle: outlet.cycle,
              salesActivity: outlet.salesActivity,
              isSynced: false);
          return db.upsertOutletFromApi(modifiedOutlet);
        }

        return db.upsertOutletFromApi(outlet);
      });

      await Future.wait(futures);
    }
  }

  Future<void> refreshOutlets() async {
    try {
      isSyncing.value = true;
      EasyLoading.show(status: 'Syncing data...');

      final apiResponse = await Api.getOutletList();
      if (apiResponse.status != "OK") {
        throw Exception('Failed to get outlets from API');
      }

      final apiOutlets = apiResponse.data ?? [];
      final localOutlets = await db.getAllOutlets();

      // Create maps for efficient lookup
      final Map<String, Outlet> apiOutletMap = {for (var outlet in apiOutlets) outlet.id!: outlet};
      final Map<String, Outlet> localOutletMap = {
        for (var outlet in localOutlets) outlet.id!: outlet
      };

      final List<Future> operations = [];
      final List<String> toDelete = [];
      final List<Outlet> toUpsert = [];

      // Handle existing outlets
      for (final localOutlet in localOutlets) {
        final id = localOutlet.id!;

        // Skip if it's a draft
        if (localOutlet.dataSource == 'DRAFT') {
          continue;
        }

        if (apiOutletMap.containsKey(id)) {
          final apiOutlet = apiOutletMap[id]!;
          if (_hasChanges(localOutlet, apiOutlet)) {
            toUpsert.add(apiOutlet);
          }
        } else if (localOutlet.dataSource == 'API') {
          toDelete.add(id);
        }
      }

      // Add new outlets from API
      for (final apiOutlet in apiOutlets) {
        if (!localOutletMap.containsKey(apiOutlet.id)) {
          toUpsert.add(apiOutlet);
        }
      }

      // Execute operations
      if (toDelete.isNotEmpty) {
        await _batchDelete(toDelete);
      }

      if (toUpsert.isNotEmpty) {
        await _batchUpsert(toUpsert);
      }

      await loadOutlets();

      Get.snackbar(
        'Sync Complete',
        'Outlets synchronized successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error syncing outlets: $e');
      Get.snackbar(
        'Sync Error',
        'Failed to sync outlets: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSyncing.value = false;
      EasyLoading.dismiss();
    }
  }

  Future<void> loadOutlets() async {
    try {
      isLoading.value = true;
      final results = await db.getAllOutlets(dataSource: "API");

      // Simple sort - drafts always on top
      // results.sort((a, b) {
      //   if (a.dataSource == 'DRAFT' && b.dataSource != 'DRAFT') {
      //     return -1;
      //   }
      //   if (a.dataSource != 'DRAFT' && b.dataSource == 'DRAFT') {
      //     return 1;
      //   }
      //   return 0; // Keep original order for same type
      // });

      outlets.assignAll(results);
    } catch (e) {
      print('Error loading outlets: $e');
      Get.snackbar(
        'Error',
        'Failed to load outlets',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

}

class TambahRoutingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TambahRoutingController());
  }
}
