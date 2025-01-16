import 'dart:io';

import 'package:cetapil_mobile/controller/support_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PdfController extends GetxController {
  final SupportDataController supportController = Get.find<SupportDataController>();
  var isInitialized = false.obs;
  var isLoading = false.obs;
  var urlPdf = "".obs;
  var localPath = "".obs;

  @override
  void onInit() {
    super.onInit();
    initPdf();
  }


  initPdf()async{
    print("start");
    try {
      isLoading.value = true;
      urlPdf.value = supportController.getKnowledge().first['path_pdf'];

      if (urlPdf.value.isEmpty) {
        print('Pdf URL is empty');
        return;
      }

      final url = 'https://cetaphil.id/storage${urlPdf.value}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/cetaphil_pdf.pdf');
        await file.writeAsBytes(response.bodyBytes);

          localPath.value = file.path;
          isLoading.value = false;
        print("------ $localPath");
      } else {
        throw Exception('Failed to load PDF');
      }

    }catch (e) {
      isLoading.value = false;
      print('Error PDF: $e');
    }
  }
}


