import 'package:flutter/material.dart';

class CustomSegmentedSwitch extends StatefulWidget {
  final bool value;
  final bool enable;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final double width;
  final double height;

  const CustomSegmentedSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.white,
    this.width = 120,
    this.height = 45,
    this.enable = true,
  }) : super(key: key);

  @override
  State<CustomSegmentedSwitch> createState() => _CustomSegmentedSwitchState();
}

class _CustomSegmentedSwitchState extends State<CustomSegmentedSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Animated background
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: widget.value ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: widget.width / 2,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.activeColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          // Text labels
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.enable ? widget.onChanged(true) : null,
                  child: Center(
                    child: Text(
                      'Ada',
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.value ? Colors.white : Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.enable ? widget.onChanged(false) : null,
                  child: Center(
                    child: Text(
                      'Tidak',
                      style: TextStyle(
                        fontSize: 12,
                        color: !widget.value ? Colors.white : Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
