import 'package:flutter/services.dart';

class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll('.', ''); // Remove existing dots
    String formatted = '';
    int counter = 0;

    for (int i = text.length - 1; i >= 0; i--) {
      counter++;
      formatted = text[i] + formatted;
      if (counter % 3 == 0 && i != 0) {
        formatted = '.' + formatted;
      }
    }

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
