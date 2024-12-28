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
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();
  bool _isOpen = false;
  String _searchQuery = '';
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _searchController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  List<String> get _filteredItems {
    final items = widget.categoriesGetter(widget.controller!);
    if (_searchQuery.isEmpty) return items;
    return items
        .where((item) =>
            item.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _toggleDropdown() {
    setState(() {
      if (_isOpen) {
        _closeDropdown();
      } else {
        _openDropdown();
      }
    });
  }

  void _openDropdown() {
    _isOpen = true;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    _isOpen = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _searchQuery = '';
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height*0.6),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 300,
                minWidth: size.width,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search ${widget.title}...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                          _overlayEntry?.markNeedsBuild();
                        });
                      },
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return ListTile(
                          title: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF0077BD),
                            ),
                          ),
                          selected: widget.selectedCategoryGetter(widget.controller!).value == item,
                          onTap: () {
                            widget.selectedCategoryGetter(widget.controller!).value = item;
                            if (widget.onChanged != null) {
                              widget.onChanged!(item);
                            }
                            _closeDropdown();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF64B5F6),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.selectedCategoryGetter(widget.controller!).value.isEmpty
                        ? widget.title
                        : widget.selectedCategoryGetter(widget.controller!).value,
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.selectedCategoryGetter(widget.controller!).value.isEmpty
                          ? Colors.grey[400]
                          : const Color(0xFF0077BD),
                    ),
                  ),
                  Icon(
                    _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: const Color(0xFF0077BD),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}