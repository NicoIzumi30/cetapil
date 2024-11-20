// outlet_controller.dart
import 'dart:convert';

import 'package:cetapil_mobile/api/api.dart';
import 'package:cetapil_mobile/controller/gps_controller.dart';
import 'package:cetapil_mobile/model/form_outlet_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../database/database_instance.dart';
import '../../model/get_city_response.dart';
import '../../model/list_city.dart';
import '../../model/outlet_example.dart';

class OutletController extends GetxController {
  // RxList<Outlet> outlets = <Outlet>[].obs;
  final GPSLocationController gpsController = Get.find<GPSLocationController>();
  var salesName = TextEditingController().obs;
  var outletName = TextEditingController().obs;
  var outletAddress = TextEditingController().obs;
  final api = Api();
  RxString searchQuery = ''.obs;
  RxDouble longitude = 0.0.obs;
  RxDouble latitude = 0.0.obs;
  var controllers = <TextEditingController>[].obs;
  var questions = <FormOutletResponse>[].obs;

  ///controller



  ///Database
  final uuid = Uuid();
  final db = DatabaseHelper.instance;
  var outlets = <Outlet>[].obs;
  // var forms = <OutletForm>[].obs;
  var isLoading = false.obs;



  @override
  void onInit() {
    super.onInit();
    loadOutlets();
    ///for testing
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
    //
    // ]);
    initializeFormData();


  }

  /// GET Function
  Future<List<String>> getDataCity() async {
    final value = await Api.getListCity();
    if (value.status == "OK") {
      return value.data!.map((city) => city.name!).toList();
    }
    return [];
  }

  Future<void> loadOutlets() async {
    final example = await db.getAllOutletWithAnswers();
    print("example $example");
    try {
      final results = await db.getAllOutletWithAnswers();

      outlets.assignAll(
          results.map((data) {
            return Outlet(id: data['id'] ?? "",
                salesName: data["salesName"] ?? "",
                outletName: data['outletName'] ?? "",
                category: data['category'] ?? "",
                longitude: data['category'] ?? "",
                latitude: data['latitude'] ?? "",
                address: data['address'] ?? "",
                status: data['status'] ?? "",
                createdAt: DateTime.parse(data['created_at']),
                updatedAt: DateTime.parse(data['updated_at'])
            );
          }).toList()
      );

    } catch (e) {
      print('Error loading outlets: $e');
    }
  }

  List<Outlet> get filteredOutlets => outlets.where((outlet) {
    return outlet.outletName
        .toLowerCase()
        .contains(searchQuery.value.toLowerCase());
  }).toList();
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }








  /// Store Function
  Future<void> initializeFormData() async {
    try {
      isLoading.value = true;

      final isEmpty = await db.isOutletFormsEmpty();

      if (isEmpty) {
        // Get data from API
        final response = await Api.getFormOutlet();
        print("response form = $response");

        if (response.isNotEmpty) {
          // Insert to database
          await db.insertOutletFormBatch(response);

          // Update questions list
          questions.value = response.map((json) =>
              FormOutletResponse.fromJson(json)
          ).toList();
          generateControllers();
        }
      }
      questions.value = await db.getAllForms();
      generateControllers();
    } catch (e) {
      print('Error initializing form data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveOutlet(Map<String, dynamic> data) async {
    try {
      EasyLoading.show();
      await db.insertOutletWithAnswers(data: data);
      EasyLoading.dismiss();
      Get.snackbar(
        'Success',
        'Outlet saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      EasyLoading.dismiss();
      print('Error saving outlet: $e');
      Get.snackbar(
        'Error',
        'Failed to save outlet: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void saveDraftOutlet() {
    print("jalan");
    final data = {
      'id': const Uuid().v4(),
      'salesName': salesName.value.text,
      'outletName': outletName.value.text,
      'category': 'MT',
      'longitude': gpsController.longController.value.text,
      'latitude': gpsController.latController.value.text,
      'address': outletAddress.value.text,
      'status': 'APPROVED',

      for (int i = 0; i < questions.length; i++)
        'form_id_${i + 1}': controllers[i].value.text,

      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    saveOutlet(data);
  }




  /// Utils Function
  void generateControllers() {
    // Dispose existing controllers first
    for (var controller in controllers) {
      controller.dispose();
    }

    controllers.assignAll(
      List.generate(
        questions.length,
            (index) => TextEditingController(),
      ),
    );
  }








  // getFormOutlet() async {
  //   try {
  //     FormOutletResponse response = await Api.getFormOutlet();
  //
  //     questions.assignAll([response]);
  //
  //     print("Data loaded successfully!");
  //   } catch (e) {
  //     print("Error loading form outlet: $e");
  //   }
  // }





  @override
  void onClose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.onClose();
  }
  }




