import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controller/activity/tambah_visibility_controller.dart';

class DateRangePickerField extends StatefulWidget {
  final String title;
  late TambahVisibilityController controller;
  // final TextEditingController controller;
  DateRangePickerField({
    Key? key,
    // required this.controller,
    required this.title, required this.controller,
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
      initialDateRange: widget.controller.selectedDateRange.value ?? DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(Duration(days: 7)),
      ),
    );

    if (picked != null) {
      setState(() {
        widget.controller.selectedDateRange.value = picked;
        print(widget.controller.selectedDateRange.value);
        _controller.text =
            '${widget.controller.selectedDateRange.value!.start.toString().split(' ')[0]} - ${widget.controller.selectedDateRange.value!.end.toString().split(' ')[0]}';
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
    if (widget.controller.selectedDateRange.value != null) {
      _controller.text =  '${DateFormat('yyyy-MM-dd').format(widget.controller.selectedDateRange.value!.start)} - ${DateFormat('yyyy-MM-dd').format(widget.controller.selectedDateRange.value!.end)}';
      // _controller.text = widget.controller.selectedDateRange.value.toString();
    }

    super.initState();
  }
}
