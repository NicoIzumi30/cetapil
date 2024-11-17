// outlet_controller.dart
import 'dart:convert';

import 'package:cetapil_mobile/model/form_outlet_response.dart';
import 'package:cetapil_mobile/model/question_outlet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/api.dart';
import '../model/outlet.dart';

class OutletController extends GetxController {
  RxList<Outlet> outlets = <Outlet>[].obs;
  RxString searchQuery = ''.obs;
  RxDouble longitude = 0.0.obs;
  RxDouble latitude = 0.0.obs;
  var controllers = <TextEditingController>[].obs;

  var jsonExample = '''
  [{
    "id": "9d7cc874-0604-40c5-9537-1c7a9bc68eb8",
    "question": "Apakah outlet sudah menjual produk GIH",
    "type": "bool"
  },
  {
    "id": "9d7cc874-0748-49c1-ae92-99ccbd0c690a",
    "question": "Berapa SKU GIH yang dijual",
    "type": "text"
  },
  {
    "id": "9d7cc874-07e9-4776-8b95-cea69cdd4245",
    "question": "Selling out GSC500 / week (in pcs)",
    "type": "text"
  },
  {
    "id": "9d7cc874-08a3-4d80-9eb5-740c584993f8",
    "question": "Selling out GSC1000 / week (in pcs)",
    "type": "text"
  },
  {
    "id": "9d7cc874-094f-49e3-a2f8-1eee8a2c2ed2",
    "question": "Selling out GSC 250 / week (in pcs)",
    "type": "text"
  },
  {
    "id": "9d7cc874-09f4-4ee4-af9d-8ebab2572a54",
    "question": "Selling out GSC 125 / week (in pcs)",
    "type": "text"
  },
  {
    "id": "9d7cc874-0a8d-4d75-b764-e17f969a25fd",
    "question": "Selling out Oily 125 / week (in pcs)",
    "type": "text"
  },
  {
    "id": "9d7cc874-02bd-493a-b017-e77c76bbfd94",
    "question": "Selling out Wash & Shampoo 400 ml / week (in pcs)",
    "type": "text"
  },
  {
    "id": "9d7cc874-0bc3-4ec1-9058-9292e52150f8",
    "question": "Selling out Wash & Shampoo Cal 400 ml / week (in pcs)",
    "type": "text"
  }]
  ''';

  // var parsedJson = <dynamic>[].obs;
  var questions = <FormOutletResponse>[].obs;

  @override
  void onInit() {
    super.onInit();
    getFormOutlet();
    // parsedJson.value = jsonDecode(jsonExample);
    // questions.value =
    //     parsedJson.map((json) => Question.fromJson(json)).toList();

    controllers.value = List.generate(
      questions.length,
      (index) => TextEditingController(),
    );
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

  getFormOutlet() async {
    await Api.getFormOutlet().then((value) {
      questions.add(value);
    });
  }

  List<Outlet> get filteredOutlets => outlets.where((outlet) {
        return outlet.name
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase());
      }).toList();

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  @override
  void onClose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
