import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../model/visibility.dart' as VisibilityModel;
import '../../model/dropdown_model.dart' as Model;
import '../../api/api.dart';

class TambahVisibilityController extends GetxController {
  final api = Api();

  // POSM related variables
  var itemsPOSM = <Model.Data>[].obs;
  final selectedPOSM = ''.obs;
  final selectedIdPOSM = ''.obs;

  // Visual related variables
  var itemsVisual = <Model.Data>[].obs;
  final selectedVisual = ''.obs;
  final selectedIdVisual = ''.obs;

  // Other visibility properties
  final selectedCondition = ''.obs;
  final RxList<File?> visibilityImages = RxList([null, null]); // [frontView, banner]
  final RxList<String> imageUrls = RxList(['', '']);
  final RxList<String> imagePath = RxList(['', '']);
  final RxList<String> imageFilename = RxList(['', '']);
  final RxList<bool> isImageUploading = RxList([false, false]);
  var listVisibility = <VisibilityModel.Visibility>[].obs;

  // Loading and error states
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initListPosm();
    initListVisual();
  }

  void setLoadingState(bool loading) {
    isLoading.value = loading;
  }

  void setErrorState(bool error, [String? message]) {
    hasError.value = error;
    errorMessage.value = message ?? '';
  }

  Future<void> initListPosm() async {
    try {
      setLoadingState(true);
      setErrorState(false);

      final response = await Api.getItemPOSMList();
      if (response.status == "OK") {
        itemsPOSM.value = response.data!;
      } else {
        setErrorState(true, 'Failed to load POSM data');
      }
    } catch (e) {
      setErrorState(true, 'Connection error. Please check your internet connection and try again.');
      print('Error initializing POSM list: $e');
    } finally {
      setLoadingState(false);
    }
  }

  Future<void> initListVisual() async {
    try {
      setLoadingState(true);
      setErrorState(false);

      final response = await Api.getItemVisualList();
      if (response.status == "OK") {
        itemsVisual.value = response.data!;
      } else {
        setErrorState(true, 'Failed to load Visual data');
      }
    } catch (e) {
      setErrorState(true, 'Connection error. Please check your internet connection and try again.');
      print('Error initializing Visual list: $e');
    } finally {
      setLoadingState(false);
    }
  }

  void updateImage(int index, File? file) {
    visibilityImages[index] = file;
    update();
  }

  void insertVisibility() {
    final data = VisibilityModel.Visibility(
      typeVisibility:
          VisibilityModel.TypeVisibility(id: selectedIdPOSM.value, type: selectedPOSM.value),
      typeVisual:
          VisibilityModel.TypeVisual(id: selectedIdVisual.value, type: selectedVisual.value),
      condition: selectedCondition.value,
      image1: visibilityImages[0],
      image2: visibilityImages[1],
    );

    listVisibility.add(data);
    clearForm();
    Get.back();
  }

  void clearForm() {
    selectedPOSM.value = "";
    selectedIdPOSM.value = "";
    selectedVisual.value = "";
    selectedIdVisual.value = "";
    selectedCondition.value = "";
    imagePath.value = ['', ''];
    isImageUploading.value = [false, false];
    visibilityImages.value = [null, null];
  }

  void editVisibilityItem(VisibilityModel.Visibility item) {
    selectedPOSM.value = item.typeVisibility!.type!;
    selectedIdPOSM.value = item.typeVisibility!.id!;
    selectedVisual.value = item.typeVisual!.type!;
    selectedIdVisual.value = item.typeVisual!.id!;
    selectedCondition.value = item.condition!;
    visibilityImages[0] = item.image1;
    visibilityImages[1] = item.image2;
    update();
  }

  void removeVisibilityItem(int index) {
    listVisibility.removeAt(index);
    update();
  }

  @override
  void onClose() {
    // Clean up any controllers or resources if needed
    super.onClose();
  }
}
