import 'package:flutter/material.dart';


class ButtonPrimary extends StatelessWidget {
  final String tipeButton; // "danger", "primary"
  final VoidCallback ontap;
  final double? width;
  final String title;
  const ButtonPrimary({
    super.key,
    required this.ontap, this.width, required this.title, required this.tipeButton,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: tipeButton == 'danger'
          ?Color(0xD7EA3232)
          : null
          ,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                offset: const Offset(0, 0),
                blurRadius: 6,
              ),
              BoxShadow(
                color: Colors.black54.withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],

            gradient:
            tipeButton == 'primary'
           ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF53A2D2),
                  Color(0xFF0077BD),
                ])
          : null,
        ),
        child: Center(
            child: Text(
              title,
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}