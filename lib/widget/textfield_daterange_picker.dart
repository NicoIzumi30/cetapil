import 'package:flutter/material.dart';

class DateRangePickerField extends StatefulWidget {
  final String title;
  // final TextEditingController controller;
  late DateTimeRange? selectedDateRange;
  DateRangePickerField({
    Key? key,
    // required this.controller,
    required this.title, this.selectedDateRange,
  }) : super(key: key);
  @override
  _DateRangePickerFieldState createState() => _DateRangePickerFieldState();
}

class _DateRangePickerFieldState extends State<DateRangePickerField> {
  late TextEditingController _controller;

  void _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: widget.selectedDateRange ?? DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(Duration(days: 7)),
      ),
    );

    if (picked != null) {
      setState(() {
        widget.selectedDateRange = picked;
        print(widget.selectedDateRange);
        _controller.text =
            '${picked.start.toString().split(' ')[0]} - ${picked.end.toString().split(' ')[0]}';
      });
    }
  }

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
          child: TextField(
            controller: _controller,
            readOnly: true,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0077BD),
            ),
            onTap: _showDateRangePicker,
            decoration: InputDecoration(
              hintText: 'Select date range',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
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
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF64B5F6),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF64B5F6),
                  width: 1,
                ),
              ),
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = TextEditingController();
    if (widget.selectedDateRange != null) {
      _controller.text = widget.selectedDateRange.toString();
    }

    super.initState();
  }
}
