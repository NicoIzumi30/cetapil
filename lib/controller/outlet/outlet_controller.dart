// outlet_controller.dart
import 'dart:convert';

import 'package:cetapil_mobile/api/api.dart';
import 'package:cetapil_mobile/controller/gps_controller.dart';
import 'package:cetapil_mobile/model/form_outlet_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../database/database_instance.dart';
import '../../model/get_city_response.dart';
import '../../model/list_city.dart';
import '../../model/outlet_example.dart';

class OutletController extends GetxController {
  // RxList<Outlet> outlets = <Outlet>[].obs;
  final api = Api();
  RxString searchQuery = ''.obs;
  RxDouble longitude = 0.0.obs;
  RxDouble latitude = 0.0.obs;
  var controllers = <TextEditingController>[].obs;
  RxList<FormOutletResponse> questions = <FormOutletResponse>[].obs;

  ///controller



  ///Database
  final uuid = Uuid();
  final db = DatabaseHelper.instance;
  var outlets = <Outlet>[].obs;
  var forms = <OutletForm>[].obs;
  final formsExample = [
    OutletForm(
      id: '1',
      question: "Apakah outlet sudah menjual produk GIH",
      type: "bool",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    OutletForm(
      id: '2',
      question: "Berapa SKU GIH yang dijual",
      type: "text",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;



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
    initializeData();
    loadForms();
    // loadOutlets();
    // getFormOutlet();

    controllers.value = List.generate(
      questions.length,
      (index) => TextEditingController(),
    );

  }

  Future<List<String>> getData() async {
    final value = await Api.getListCity();
    if (value.status == "OK") {
      return value.data!.map((city) => city.name!).toList();
    }
    return [];
  }

  Future<void> initializeData() async {
    try {
      final existingForms = await db.getAllOutletForms();

      if (existingForms.isEmpty) {
        // Only insert initial data if table is empty
        final uuid = Uuid();
        final initialForms = [
          OutletForm(
            id: uuid.v4(),
            question: "Apakah outlet sudah menjual produk GIH",
            type: "bool",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          OutletForm(
            id: uuid.v4(),
            question: "Berapa SKU GIH yang dijual",
            type: "text",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];

        await addFormBatch(initialForms);
      }
    } catch (e) {
      print('Error initializing data: $e');
    }
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

  List<Outlet> get filteredOutlets => outlets.where((outlet) {
        return outlet.outletName
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase());
      }).toList();

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  Future<void> loadOutlets() async {
    isLoading.value = true;
    try {
      final result = await db.getAllOutlets();
      outlets.value = result;
    } catch (e) {
      print('Error loading outlets: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveOutletWithAnswers({
    required Outlet outlet,
    required List<OutletFormAnswer> answers,
  }) async {
    try {
      final database = await db.database;
      await database.transaction((txn) async {
        // Insert outlet
        await txn.insert('outlets', outlet.toJson());

        // Insert answers
        for (var answer in answers) {
          await txn.insert('outlet_form_answers', answer.toJson());
        }
      });

      await loadOutlets();
    } catch (e) {
      print('Error saving outlet with answers: $e');
      rethrow;
    }
  }


  /// CRUD FORM OUTLET
  Future<void> initializeDatabase() async {
    try {
      await db.database; // Ensure database is initialized
      await loadForms();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('Database initialization error: $e');
    }
  }
  Future<void> loadForms() async {
    isLoading.value = true;
    try {
      final result = await db.getAllOutletForms();
      forms.value = result;
      hasError.value = false;
      errorMessage.value = '';
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('Error loading forms: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addForm(OutletForm form) async {
    try {
      await db.insertOutletForm(form);
      await loadForms();
    } catch (e) {
      print('Error adding form: $e');
      rethrow;
    }
  }

  Future<void> addFormBatch(List<OutletForm> newForms) async {
    try {
      isLoading.value = true;

      // Option 1: Skip existing records
      await db.insertOutletFormBatch(newForms);

      // Option 2: Replace existing records
      // await db.upsertOutletFormBatch(newForms);

      // Option 3: Clear and insert new data
      // await db.clearAndInsertOutletFormBatch(newForms);

      await loadForms();
    } catch (e) {
      print('Error adding forms batch: $e');
      Get.snackbar(
        'Error',
        'Failed to add forms: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }




  @override
  void onClose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
