import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class CategoryDropdown<T> extends StatefulWidget {
  final String title;
  final T? controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Rx<String> Function(T) selectedCategoryGetter;
  final List<String> Function(T) categoriesGetter;

  const CategoryDropdown({
    Key? key,
    this.controller,
    this.onChanged,
    this.validator,
    required this.title,
    required this.selectedCategoryGetter,
    required this.categoriesGetter,
  }) : super(key: key);

  @override
  State<CategoryDropdown<T>> createState() => _CategoryDropdownState<T>();
}

class _CategoryDropdownState<T> extends State<CategoryDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
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
          child: DropdownButtonFormField<String>(
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0077BD),
            ),
            decoration: InputDecoration(
              hintText: widget.title,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 13,
              ),
              filled: true,
              fillColor: const Color(0xFFE8F3FF),
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
            value: widget.selectedCategoryGetter(widget.controller!).value,
            items: widget.categoriesGetter(widget.controller!).map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                widget.selectedCategoryGetter(widget.controller!).value = newValue;
                if (widget.onChanged != null) {
                  widget.onChanged!(newValue);
                }
              }
            },
          ),
        ),
      ],
    );
  }
}