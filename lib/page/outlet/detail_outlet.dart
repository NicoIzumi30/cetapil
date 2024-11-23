import 'dart:io';

import 'package:cetapil_mobile/controller/outlet/outlet_controller.dart';
import 'package:cetapil_mobile/model/outlet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/colors.dart';
import '../../widget/back_button.dart';
import '../../widget/clipped_maps.dart';

class DetailOutlet extends GetView<OutletController> {
  DetailOutlet({super.key, required this.outlet});
  final Outlet outlet;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(children: [
        Image.asset(
          'assets/background.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EnhancedBackButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                backgroundColor: Colors.white,
                iconColor: Colors.blue,
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Detail Outlet", style: AppTextStyle.titlePage),
                      SizedBox(
                        height: 20,
                      ),
                      UnderlineTextField.readOnly(
                        title: "Nama Outlet",
                        value: outlet.name,
                      ),
                      UnderlineTextField.readOnly(
                        title: "Kategori Outlet",
                        value: outlet.category,
                      ),
                      UnderlineTextField.readOnly(
                        title: "Alamat Outlet",
                        value: outlet.address,
                        maxlines: 2,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: UnderlineTextField.readOnly(
                              title: "Latitude",
                              value: outlet.longitude,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: UnderlineTextField.readOnly(
                              title: "Longitude",
                              value: outlet.latitude,
                            ),
                          ),
                        ],
                      ),
                      MapPreviewWidget(
                        latitude: double.tryParse(outlet.latitude!) ?? 0,
                        longitude: double.tryParse(outlet.longitude!) ?? 0,
                        zoom: 14.0,
                        height: 250,
                        borderRadius: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Foto Outlet",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          ClipImage(url: outlet.images![0].image!),
                          SizedBox(
                            width: 8,
                          ),
                          ClipImage(url: outlet.images![1].image!),
                          SizedBox(
                            width: 8,
                          ),
                          ClipImage(url: outlet.images![2].image!),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Formulir Survey Outlet", style: AppTextStyle.titlePage),
                      SizedBox(
                        height: 20,
                      ),
                      Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (controller.questions.isEmpty) {
                          return const Center(child: Text("No Form"));
                        }
                        return Column(
                          children: List<Widget>.generate(
                            controller.questions.length,
                            (index) {
                              final question = controller.questions[index];

                              // Find matching form element
                              final matchingForms = outlet.forms
                                      ?.where((element) => element.id == question.id)
                                      .toList() ??
                                  [];

                              // print("Api question  = ${outlet.forms![index].outletForm!.id!}");
                              print("Lokal question  = ${controller.questions[index].id}");

                              // int getLokalQuestionIndex(String apiQuestionId) {
                              //   return controller.questions.indexOf(apiQuestionId);
                              // }
                              // print(" get index ${getLokalQuestionIndex(outlet.forms![index].outletForm!.id!)}");

                              // final example = controller.questions.any((question) => question.question == outlet.forms![index].outletForm!.question);

                              String answer = "";
                             //
                             // if (controller.questions[index].id == outlet.forms![index].outletForm!.id!) {
                             //     answer = outlet.forms![index].answer!;
                             //  }  else{
                             //    answer = "";
                             //  }

                              // Get answer value with null safety
                              // final String answer =
                              //     matchingForms.isNotEmpty ? matchingForms.first.answer ?? '' : '';
                              // final String answer =   outlet.forms![index].answer!;

                              return UnderlineTextField.readOnly(
                                title: question.question,
                                value: answer,
                              );
                            },
                          ),
                        );
                      }),
                      // UnderlineTextField.editable(
                      //     title: "Apakah outlet sudah menjual produk GIH ?",
                      //     controller: _controller),
                      // UnderlineTextField.editable(
                      //     title: "Berapa banyak produk GIH yang sudah terjual ?",
                      //     controller: _controller),
                      // UnderlineTextField.editable(
                      //     title: "Selling out GSC500/week (in pcs)", controller: _controller),
                      // UnderlineTextField.editable(
                      //     title: "Selling out GSC1000/week (in pcs)", controller: _controller),
                      // UnderlineTextField.editable(
                      //     title: "Selling out GSC250/week (in pcs)", controller: _controller),
                      // UnderlineTextField.editable(
                      //     title: "Selling out GSC125/week (in pcs)", controller: _controller),
                      // UnderlineTextField.editable(
                      //     title: "Selling out Oily 125/week (in pcs)", controller: _controller),
                      // UnderlineTextField.editable(
                      //     title: "Selling out wash & shampo 400ml/week (in pcs)",
                      //     controller: _controller),
                      // UnderlineTextField.editable(
                      //     title: "Selling out wash & shampo cal 400ml/week (in pcs)",
                      //     controller: _controller),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}

class ClipImage extends StatelessWidget {
  final String url;
  final double? size;
  final BoxFit fit;


  const ClipImage({
    super.key,
    required this.url,
    this.size,
    this.fit = BoxFit.cover,
  });

  String _sanitizeUrl(String url) {
    // Convert localhost/127.0.0.1 URLs to your actual development server IP
    // Replace this with your actual development server IP
    return url
        .replaceAll('http://127.0.0.1:8000', 'https://dev-cetaphil.i-am.host')
        .replaceAll('http://localhost:8000', 'https://dev-cetaphil.i-am.host');
  }

  // Future<Widget> imageFile()async{
  //   final directory = await getApplicationDocumentsDirectory();
  //   final path = '${directory.path}/$url';
  //   return Image.file(
  //     File(path),
  //     errorBuilder: (context, error, stackTrace) {
  //       return const Center(child: Text('Error loading image'));
  //     },
  //   );
  // }
  //
  // Future<File> getImageFile() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final path = '${directory.path}$url';
  //   return File(path);
  // }



  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.blue,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child:
            Image.network(
              _sanitizeUrl(url),

              fit: fit,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Image Error',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (error is NetworkImageLoadException)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            'Network Error',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class UnderlineTextField extends StatelessWidget {
  final String title;
  final bool readOnly;
  final String? value;
  final int? maxlines;
  final TextEditingController? controller;

  // Constructor for read-only mode
  const UnderlineTextField.readOnly({
    super.key,
    required this.title,
    required this.value,
    this.maxlines = 1,
  })  : readOnly = true,
        controller = null;

  // Constructor for editable mode
  const UnderlineTextField.editable({
    super.key,
    required this.title,
    required this.controller,
    this.maxlines = 1,
  })  : readOnly = false,
        value = null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: readOnly ? TextEditingController(text: value) : controller,
          maxLines: maxlines,
          readOnly: readOnly,
          style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
