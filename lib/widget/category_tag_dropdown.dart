import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryTagDropdown<T> extends StatelessWidget {
  final RxList<T> selectedItems;
  final List<T> items;
  final Function(T?) onChanged;
  final Function(T) onRemove;
  final Function() onSelectionComplete;
  final String Function(T) getDisplayName;

  const CategoryTagDropdown({
    Key? key,
    required this.selectedItems,
    required this.items,
    required this.onChanged,
    required this.onRemove,
    required this.onSelectionComplete,
    required this.getDisplayName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Kategori Produk",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<T>(
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0077BD),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFFE8F3FF),
            ),
            hint: Text(
              "-- Pilih kategori produk --",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.blue,
            ),
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  getDisplayName(item),
                  style: const TextStyle(color: Colors.black87),
                ),
              );
            }).toList(),
            onChanged: (value) {
              onChanged(value);
              onSelectionComplete();
            },
            isExpanded: true,
          ),
        ),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedItems
                  .map((item) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              getDisplayName(item),
                              style: const TextStyle(color: Colors.blue),
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () {
                                onRemove(item);
                                onSelectionComplete();
                              },
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            )),
      ],
    );
  }
}
