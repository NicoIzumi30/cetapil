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
  final selectedCity = Rxn<Data>();
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final cities = <Data>[].obs;
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
    try {
      isLoading.value = true;
      hasError.value = false;
      final isEmpty = await citiesDb.isCitiesEmpty();

      if (isEmpty) {
        final response = await Api.getListCity();
        if (response.status == "OK" && response.data != null) {
          await citiesDb.insertCities(response.data!);
          cities.value = response.data!;
        } else {
          throw Exception('Failed to load cities: ${response.message}');
        }
      } else {
        final dbCities = await citiesDb.getAllCities();
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

  Future<List<Data>> _filterCities(String? filter) async {
    if (filter == null || filter.isEmpty) {
      return cities;
    }
    return cities
        .where((city) => city.name?.toLowerCase().contains(filter.toLowerCase()) ?? false)
        .toList();
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

          return DropdownSearch<Data>(
            // onFind: (String? filter) => _filterCities(filter),
            itemAsString: (Data? city) => city?.name ?? '',
            onChanged: (Data? value) {
              selectedCity.value = value;
              if (value != null) {
                widget.controller.cityId.value = value.id ?? '';
                widget.controller.cityName.value = value.name ?? '';
              } else {
                widget.controller.cityId.value = '';
                widget.controller.cityName.value = '';
              }
            },
            compareFn: (item1, item2) => item1?.id == item2?.id,
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: 'Search city...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              loadingBuilder: (context, searchEntry) => Center(
                child: CircularProgressIndicator(),
              ),
              emptyBuilder: (context, searchEntry) => Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    searchEntry?.isEmpty ?? true
                        ? 'No cities available'
                        : 'No cities found for "$searchEntry"',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              showSelectedItems: true,
              constraints: BoxConstraints(maxHeight: 300),
            ),
          );
        }),
        SizedBox(height: 10),
      ],
    );
  }
}
