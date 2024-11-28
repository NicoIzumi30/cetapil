import 'package:flutter/material.dart';

class SearchableGroupedDropdown extends StatefulWidget {
  final String title;
  final Map<String, List<String>> categories;
  final Function(String) onSelect;
  final Function(String)? onDeselect;

  const SearchableGroupedDropdown({
    Key? key,
    required this.title,
    required this.categories,
    required this.onSelect,
    this.onDeselect,
  }) : super(key: key);

  @override
  State<SearchableGroupedDropdown> createState() => _SearchableGroupedDropdownState();
}

class _SearchableGroupedDropdownState extends State<SearchableGroupedDropdown> {
  final _layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  bool _isOpen = false;
  final _selectedItems = <String>{};
  String _searchQuery = '';

  void _toggleDropdown() {
    if (_isOpen) {
      _overlayEntry.remove();
    } else {
      final overlay = Overlay.of(context);
      _overlayEntry = _createOverlayEntry();
      overlay.insert(_overlayEntry);
    }
    setState(() => _isOpen = !_isOpen);
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _toggleDropdown,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: offset.dy + size.height,
                width: size.width,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0, size.height),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: Container(
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
                                onChanged: (value) => setState(() => _searchQuery = value),
                                decoration: const InputDecoration(
                                  hintText: 'Search...',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Flexible(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.categories.length,
                                itemBuilder: (context, index) {
                                  final category = widget.categories.keys.elementAt(index);
                                  final items = widget.categories[category]!
                                      .where((item) =>
                                          item.toLowerCase().contains(_searchQuery.toLowerCase()))
                                      .toList();
                                  if (items.isEmpty) return const SizedBox();

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: Colors.grey[50],
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          category,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF023B5E),
                                          ),
                                        ),
                                      ),
                                      ...items.map((item) => CheckboxListTile(
                                            value: _selectedItems.contains(item),
                                            onChanged: (checked) {
                                              setState(() {
                                                if (checked!) {
                                                  _selectedItems.add(item);
                                                  widget.onSelect(item);
                                                } else {
                                                  _selectedItems.remove(item);
                                                  widget.onDeselect?.call(item);
                                                }
                                              });
                                              _overlayEntry.markNeedsBuild();
                                            },
                                            title: Text(item),
                                            dense: true,
                                            controlAffinity: ListTileControlAffinity.leading,
                                          )),
                                    ],
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
              ),
            ],
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
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        CompositedTransformTarget(
          link: _layerLink,
          child: InkWell(
            onTap: _toggleDropdown,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF64B5F6)),
                color: const Color(0xFFE8F3FF),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedItems.isEmpty
                          ? '-- Pilih ${widget.title} --'
                          : _selectedItems.join(', '),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _selectedItems.isEmpty ? Colors.grey[400] : const Color(0xFF0077BD),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Icon(
                    _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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
