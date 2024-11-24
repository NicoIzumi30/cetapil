import 'package:cetapil_mobile/controller/outlet/outlet_controller.dart';
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
  final OutletController outletController = Get.find<OutletController>();
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

  }


  initGetRouting()async {
    try{
      await db.deleteAllRouting();
      routing.clear();

      EasyLoading.show(status: 'Saving data...');
      final response = await Api.getRoutingList();

      if (response.status == "OK" && response.data!.isNotEmpty) {
        for(int i = 0; i< response.data!.length; i++){ /// looping response Api
          final result = response.data![i];
          print("cekin : ${result.salesActivity?.checkedIn}");
          Map<String, dynamic> data = {
            'id': result.id,
            'outletName': result.name ?? "",
            'salesName': result.user?.name ?? "",
            'category': result.category ?? "",
            'city_id': result.city?.id ?? "",
            'city_name': result.city?.name ?? "",
            'longitude': result.longitude ?? "",
            'latitude': result.latitude ?? "",
            'address': result.address ?? "",
            'status_outlet': result.status ?? "",
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          };
          if (result.salesActivity != null) {
            data.addAll({
              'activities_id': const Uuid().v4(),
              'outlet_id': result.salesActivity?.outletId ?? "",
              'user_id': result.user!.id ?? "",
              'checked_in': result.salesActivity?.checkedIn ?? "",
              'checked_out': result.salesActivity?.checkedOut ?? "",
              'views_knowledge': result.salesActivity?.viewsKnowledge ?? "",
              'time_availability': result.salesActivity?.timeAvailability ?? "",
              'time_visibility': result.salesActivity?.timeVisibility ?? "",
              'time_knowledge': result.salesActivity?.timeKnowledge ?? "",
              'time_survey': result.salesActivity?.timeSurvey ?? "",
              'time_order': result.salesActivity?.timeOrder ?? "",
              'status_activities': result.salesActivity?.status ?? "",
            });
          }
          if (result.images != null && result.images!.isNotEmpty) {
            for (int imgIndex = 0; imgIndex < 3; imgIndex++) {
              data['image_path_${imgIndex + 1}'] =
              imgIndex < result.images!.length ? result.images![imgIndex].image ?? "" : "";
            }
          }
          // if (result.images != null && result.images!.isNotEmpty) {
          //   for (int imgIndex = 0; imgIndex < 3; imgIndex++) {
          //     data['image_path_${imgIndex + 1}'] =
          //     imgIndex < result.images!.length ? result.images![imgIndex].image ?? "" : "";
          //   }
          // }
          // Add forms data if exists
          if (result.forms != null && result.forms!.isNotEmpty) {
            final formAnswers = Map.fromEntries(
                result.forms!.map((form) => MapEntry(
                    form.outletForm?.id ?? "",
                    form.answer ?? ""
                ))
            );

            // Add answers for each question
            for (int j = 0; j < outletController.questions.length; j++) {
              final questionId = outletController.questions[j].id;
              data['form_id_$questionId'] = formAnswers[questionId] ?? "";
            }
          }
          print("aaa");
          await db.insertRoutingWithAnswers(
              data: data);

        }


        /// Skema  GET API AND UPDATE DATA LOKAL
          // final listRoutingLokal = await db.getAllRouting(); /// Get data dari lokal
          //
          // final newItems = response.data!.where((newItem) =>
          // !listRoutingLokal.any((existingItem) => existingItem.id == newItem.id)
          // ).toList();/// compare apakah listRoutingLokal dan Response Api ada data baru
          //
          // if (newItems.isNotEmpty) {
          //   for(int i = 0; i< newItems.length; i++){ /// looping response Api
          //       final result = newItems[i];
          //       Map<String, dynamic> data = {
          //         'id': result.id,
          //         'outletName': result.name ?? "",
          //         'salesName': result.user?.name ?? "",
          //         'category': result.category ?? "",
          //         'city_id': result.city?.id ?? "",
          //         'city_name': result.city?.name ?? "",
          //         'longitude': result.longitude ?? "",
          //         'latitude': result.latitude ?? "",
          //         'address': result.address ?? "",
          //         'status_outlet': result.status ?? "",
          //         'created_at': DateTime.now().toIso8601String(),
          //         'updated_at': DateTime.now().toIso8601String(),
          //       };
          //       if (result.salesActivity != null) {
          //         data.addAll({
          //           'activities_id': const Uuid().v4(),
          //           'outlet_id': result.salesActivity?.outletId ?? "",
          //           'user_id': result.user!.id ?? "",
          //           'checked_in': result.salesActivity?.checkedIn ?? "",
          //           'checked_out': result.salesActivity?.checkedOut ?? "",
          //           'views_knowledge': result.salesActivity?.viewsKnowledge ?? "",
          //           'time_availability': result.salesActivity?.timeAvailability ?? "",
          //           'time_visibility': result.salesActivity?.timeVisibility ?? "",
          //           'time_knowledge': result.salesActivity?.timeKnowledge ?? "",
          //           'time_survey': result.salesActivity?.timeSurvey ?? "",
          //           'time_order': result.salesActivity?.timeOrder ?? "",
          //           'status_activities': result.salesActivity?.status ?? "",
          //         });
          //       }
          //       if (result.images != null && result.images!.isNotEmpty) {
          //         for (int imgIndex = 0; imgIndex < 3; imgIndex++) {
          //           data['image_path_${imgIndex + 1}'] =
          //           imgIndex < result.images!.length ? result.images![imgIndex].image ?? "" : "";
          //         }
          //       }
          //       if (result.images != null && result.images!.isNotEmpty) {
          //         for (int imgIndex = 0; imgIndex < 3; imgIndex++) {
          //           data['image_path_${imgIndex + 1}'] =
          //           imgIndex < result.images!.length ? result.images![imgIndex].image ?? "" : "";
          //         }
          //       }
          //       // Add forms data if exists
          //       if (result.forms != null && result.forms!.isNotEmpty) {
          //         final formAnswers = Map.fromEntries(
          //             result.forms!.map((form) => MapEntry(
          //                 form.outletForm?.id ?? "",
          //                 form.answer ?? ""
          //             ))
          //         );
          //
          //         // Add answers for each question
          //         for (int j = 0; j < outletController.questions.length; j++) {
          //           final questionId = outletController.questions[j].id;
          //           data['form_id_$questionId'] = formAnswers[questionId] ?? "";
          //         }
          //       }
          //       print("aaa");
          //       await db.insertRoutingWithAnswers(
          //           data: data);
          //
          //   }
          // }
        final results = await db.getAllRouting();
        routing.addAll(results);
      }



    }catch (e) {
      print('Error saving Routing: $e');
      Get.snackbar(
        'Error',
        'Gagal Simpan Data: Periksa Koneksi Anda dan Coba Lagi',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      EasyLoading.dismiss();
    }

  }

  submitCheckin(String outlet_id)async{
    try{
      EasyLoading.show(status: 'Submit data...');
      final data = {
        'outlet_id' : outlet_id,
        'checked_in' : DateTime.now().toIso8601String(),
      };
      final response = await Api.submitCheckin(data);
      
      if (response.status == "OK") {
        Get.back();
        initGetRouting();
      }
    }catch (e) {
      print('Error saving Routing: $e');
      Get.snackbar(
        'Error',
        'Gagal Simpan Data: Periksa Koneksi Anda dan Coba Lagi',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      EasyLoading.dismiss();
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
