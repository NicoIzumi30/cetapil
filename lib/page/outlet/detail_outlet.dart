import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/colors.dart';
import '../../widget/back_button.dart';
import '../../widget/clipped_maps.dart';

class DetailOutlet extends StatelessWidget {
  final TextEditingController _controller =
      TextEditingController(text: "Guardian Setiabudi Building");
  final LatLng _targetLocation = LatLng(37.7749, -122.4194); // San Francisco
  late GoogleMapController _controllerMaps;

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
                          title: "Nama Outlet",value: "Guardian Setiabudi Building",),
                      UnderlineTextField.readOnly(
                          title: "Kategori Outlet", value: "MT",),
                      UnderlineTextField.readOnly(
                        title: "Alamat Outlet",
                        value: "Mega Plaza, Jl. H. R. Rasuna Said, RT.18/RW.1 Kuningan, Karet, Setiabudi, Jakarta Selatan",
                        maxlines: 2,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: UnderlineTextField.readOnly(
                                title: "Latitude", value: "-7.89231",),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: UnderlineTextField.readOnly(
                                title: "Longitude", value: "621.27382",),
                          ),
                        ],
                      ),
                      const MapPreviewWidget(
                        latitude: -6.2088,
                        longitude: 106.8456,
                        zoom: 14.0,
                        height: 250,
                        borderRadius: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Foto Outlet",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          ClipImage(
                              url:
                                  'https://goalkes-images.s3.ap-southeast-1.amazonaws.com/media/4938/boWCVZ4RqOc87vb62KE1ryS2wiXdFIOSdDkHDFna.jpg'),
                          SizedBox(
                            width: 8,
                          ),
                          ClipImage(
                            url:
                                'https://goalkes-images.s3.ap-southeast-1.amazonaws.com/media/4938/boWCVZ4RqOc87vb62KE1ryS2wiXdFIOSdDkHDFna.jpg',
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          ClipImage(
                              url:
                                  'https://goalkes-images.s3.ap-southeast-1.amazonaws.com/media/4938/boWCVZ4RqOc87vb62KE1ryS2wiXdFIOSdDkHDFna.jpg')
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Formulir Survey Outlet", style: AppTextStyle.titlePage),
                      SizedBox(
                        height: 20,
                      ),
                      UnderlineTextField.editable(
                          title: "Apakah outlet sudah menjual produk GIH ?", controller: _controller),
                      UnderlineTextField.editable(
                          title: "Berapa banyak produk GIH yang sudah terjual ?", controller: _controller),
                      UnderlineTextField.editable(
                          title: "Selling out GSC500/week (in pcs)", controller: _controller),
                      UnderlineTextField.editable(
                          title: "Selling out GSC1000/week (in pcs)", controller: _controller),
                      UnderlineTextField.editable(
                          title: "Selling out GSC250/week (in pcs)", controller: _controller),
                      UnderlineTextField.editable(
                          title: "Selling out GSC125/week (in pcs)", controller: _controller),
                      UnderlineTextField.editable(
                          title: "Selling out Oily 125/week (in pcs)", controller: _controller),
                      UnderlineTextField.editable(
                          title: "Selling out wash & shampo 400ml/week (in pcs)", controller: _controller),
                      UnderlineTextField.editable(
                          title: "Selling out wash & shampo cal 400ml/week (in pcs)", controller: _controller),
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
  const ClipImage({
    super.key,
    required this.url,
  });

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
            child: Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.error_outline, color: Colors.red),
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
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: readOnly ? TextEditingController(text: value) : controller,
          maxLines: maxlines,
          readOnly: readOnly,
          style: TextStyle(
              fontSize: 13,
              color: AppColors.primary,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white))),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
