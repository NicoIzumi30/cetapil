import 'dart:io';

import 'package:cetapil_mobile/controller/activity/knowledge_controller.dart';
import 'package:cetapil_mobile/controller/pdf_controller.dart';
import 'package:cetapil_mobile/widget/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../../controller/video_controller/video_controller.dart';

class KnowledgePage extends GetView<KnowledgeController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomVideoPlayer(),
        PDFViewerPage(),
      ],
    );
  }
}

class PDFViewerPage extends StatelessWidget {
  const PDFViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PdfController>(
        init: PdfController(),
        builder: (controller) {
          return
            Obx((){
              return controller.isLoading.value
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  :SizedBox(
                  height: 400,
                  child: PDFView(
                    filePath: "/data/user/0/com.example.cetapil_mobile/cache/cetaphil_pdf.pdf",
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: true,
                    pageFling: true,
                    pageSnap: true,
                    // onRender: (pages) {
                    //   setState(() => totalPages = pages!);
                    // },
                    // onPageChanged: (page, _) {
                    //   setState(() => currentPage = page!);
                    // },
                    onError: (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.toString())),
                      );
                    },
                  )
              );
            });

        });
  }
}

// class PDFViewerPage extends StatefulWidget {
//   final String pdfUrl; // URL of the PDF file
//
//   const PDFViewerPage({Key? key, required this.pdfUrl}) : super(key: key);
//
//   @override
//   _PDFViewerPageState createState() => _PDFViewerPageState();
// }
//
// class _PDFViewerPageState extends State<PDFViewerPage> {
//   String? localPath;
//   bool isLoading = true;
//   int totalPages = 0;
//   int currentPage = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     loadPDF();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PDF Viewer'),
//         actions: [
//           Text('$currentPage/$totalPages'),
//           const SizedBox(width: 20),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : localPath != null
//               ? PDFView(
//                   filePath: localPath!,
//                   enableSwipe: true,
//                   swipeHorizontal: true,
//                   autoSpacing: false,
//                   pageFling: false,
//                   pageSnap: true,
//                   defaultPage: currentPage,
//                   onRender: (pages) {
//                     setState(() => totalPages = pages!);
//                   },
//                   onPageChanged: (page, _) {
//                     setState(() => currentPage = page!);
//                   },
//                   onError: (error) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(error.toString())),
//                     );
//                   },
//                 )
//               : const Center(
//                   child: Text('Failed to load PDF'),
//                 ),
//     );
//   }
// }
