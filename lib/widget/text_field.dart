import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernTextField extends StatefulWidget {
  final String title;
  final int? maxlines;
  final TextEditingController? controller;
  bool obscureText = false;
  final bool? enable;
  final bool? suffixIcon;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;

  ModernTextField({
    Key? key,
    // required this.hintText,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.validator,
    required this.title,
    this.enable,
    this.readOnly = false,
    this.suffixIcon = false,
    this.maxlines,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<ModernTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            enabled: widget.enable,
            validator: widget.validator,
            maxLines: widget.maxlines,
            readOnly: widget.readOnly,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0077BD),
            ),
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              hintText: widget.title,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              suffixIcon: widget.suffixIcon!
                  ? IconButton(
                      icon: Icon(
                        widget.obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.blue[600],
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.obscureText = !widget.obscureText;
                        });
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 13,
              ),
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
            ),
          ),
        ),
      ],
    );
  }
}
