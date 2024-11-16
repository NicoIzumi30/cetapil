import 'package:flutter/material.dart';


class ButtonPrimary extends StatelessWidget {
  final VoidCallback ontap;
  final double? width;
  final String title;
  const ButtonPrimary({
    super.key,
    required this.ontap, this.width, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                offset: const Offset(0, 0),
                blurRadius: 6,
              ),
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF53A2D2),
                  Color(0xFF0077BD),
                ])),
        child: Center(
            child: Text(
              title,
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}