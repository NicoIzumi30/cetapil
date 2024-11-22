import 'dart:async';

import 'package:cetapil_mobile/database/cities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../controller/outlet/outlet_controller.dart';
import '../model/get_city_response.dart';
import '../api/api.dart';

class CityDropdown extends StatefulWidget {
  final OutletController controller;
  final String title;

  const CityDropdown({
    Key? key,
    required this.controller,
    required this.title,
  }) : super(key: key);

  @override
  State<CityDropdown> createState() => _CityDropdownState();
}

class _CityDropdownState extends State<CityDropdown> {
  final citiesDb = CitiesDatabaseHelper.instance;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final cities = <String>[].obs;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    initializeCities();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> initializeCities() async {
    print("init city");
    try {
      isLoading.value = true;
      hasError.value = false;
      final isEmpty = await citiesDb.isCitiesEmpty();

      if (isEmpty) {
        final response = await Api.getListCity();
        print("response city = $response");
        if (response.status == "OK" && response.data != null) {
          await citiesDb.insertCities(response.data!);
          final dbCities = await citiesDb.getAllCities();
          print("cities from db = $dbCities");
          cities.value = dbCities;
        } else {
          throw Exception('Failed to load cities: ${response.message}');
        }
      } else {
        final dbCities = await citiesDb.getAllCities();
        print("cities from db = ${dbCities}");
        cities.value = dbCities;
      }
    } catch (e) {
      print('Error initializing cities: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load cities: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10),
        Obx(() {
          if (isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (hasError.value) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Failed to load cities. Please try again.',
                          style: TextStyle(color: Colors.red[900]),
                        ),
                      ),
                      TextButton(
                        onPressed: initializeCities,
                        child: Text('Retry'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red[900],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return DropdownSearch<String>(
            items: (String, LoadProps) => cities.value, // Convert RxList to List
            selectedItem: widget.controller.cityName.value.isNotEmpty
                ? widget.controller.cityName.value
                : null,
            onChanged: (String? value) {
              if (value != null) {
                widget.controller.cityName.value = value;
                // You should implement a way to get the proper city ID here
                widget.controller.selectedCity.value = Data(
                  id: widget.controller.cityId.value,
                  name: value,
                );
              }
            },
            decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFE8F3FF), // Light blue background
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF64B5F6),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF64B5F6),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF64B5F6),
                  width: 1,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF64B5F6),
                  width: 1,
                ),
              ),
            )),
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: 'Search city...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFFE8F3FF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFF64B5F6),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFF64B5F6),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFF64B5F6),
                      width: 1,
                    ),
                  ),
                ),
              ),
              constraints: BoxConstraints(maxHeight: 300),
            ),
            // dropdownDecoratorProps: DropDownDecoratorProps(
            //   dropdownSearchDecoration: InputDecoration(
            //     filled: true,
            //     fillColor: const Color(0xFFE8F3FF),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8),
            //       borderSide: const BorderSide(
            //         color: Color(0xFF64B5F6),
            //         width: 2,
            //       ),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8),
            //       borderSide: const BorderSide(
            //         color: Color(0xFF64B5F6),
            //         width: 1,
            //       ),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8),
            //       borderSide: const BorderSide(
            //         color: Color(0xFF64B5F6),
            //         width: 1,
            //       ),
            //     ),
            //   ),
            // ),
          );
        }),
        SizedBox(height: 10),
      ],
    );
  }
}
