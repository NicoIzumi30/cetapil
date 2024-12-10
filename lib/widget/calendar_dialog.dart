import 'package:cetapil_mobile/api/api.dart';
import 'package:cetapil_mobile/model/calendar_response.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class CustomCalendarDialog extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CustomCalendarDialog({
    Key? key,
    required this.initialDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<CustomCalendarDialog> createState() => _CustomCalendarDialogState();
}

class _CustomCalendarDialogState extends State<CustomCalendarDialog> {
  late DateTime _selectedDate;
  late DateTime _currentMonth;
  final DateFormat _monthFormat = DateFormat('MMMM');
  final DateFormat _yearFormat = DateFormat('yyyy');
  CalendarResponse? _calendarData;
  bool _isLoading = false;
  bool _showYearPicker = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID');
    _selectedDate = widget.initialDate;
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
    _fetchCalendarData();
  }

  Future<void> _fetchCalendarData() async {
    setState(() => _isLoading = true);
    try {
      final response = await Api.getCalendarDashboard(_currentMonth.month, _currentMonth.year);
      setState(() => _calendarData = response);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading calendar data: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
    _fetchCalendarData();
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
    _fetchCalendarData();
  }

  void _showYearSelection() {
    setState(() => _showYearPicker = true);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color(0xFF0277BD),
                  onPrimary: Colors.white,
                ),
          ),
          child: AlertDialog(
            title: const Text(
              'Select Year',
              style: TextStyle(color: Color(0xFF0277BD)),
            ),
            content: SizedBox(
              width: 300,
              height: 300,
              child: YearPicker(
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                selectedDate: _currentMonth,
                onChanged: (DateTime dateTime) {
                  setState(() {
                    _currentMonth = DateTime(dateTime.year, _currentMonth.month);
                    _showYearPicker = false;
                  });
                  Navigator.pop(context);
                  _fetchCalendarData();
                },
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }

  Color _getDateColor(DateTime date) {
    if (_calendarData == null) return Colors.transparent;

    final calendarDate = _calendarData!.data?.calendarData?.firstWhere(
      (d) => d.date == DateFormat('yyyy-MM-dd').format(date),
      orElse: () => CalendarData(),
    );

    if (calendarDate?.hasAnyActivity == true) {
      return Colors.green.withOpacity(0.2);
    } else if (date.month == _currentMonth.month) {
      return Colors.red.withOpacity(0.2);
    }

    return Colors.transparent;
  }

  void _showActivityDetails(DateTime date) {
    final calendarDate = _calendarData?.data?.calendarData?.firstWhere(
      (d) => d.date == DateFormat('yyyy-MM-dd').format(date),
      orElse: () => CalendarData(),
    );

    if (calendarDate != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFF0277BD),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0277BD),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Activities
                  _buildActivityItem(
                    'Sales Activities',
                    calendarDate.activities?.sales?.total ?? 0,
                    calendarDate.activities?.sales?.hasActivity ?? false,
                    Icons.shopping_cart,
                  ),
                  const SizedBox(height: 12),
                  _buildActivityItem(
                    'Outlet Activities',
                    calendarDate.activities?.outlets?.total ?? 0,
                    calendarDate.activities?.outlets?.hasActivity ?? false,
                    Icons.store,
                  ),
                  const SizedBox(height: 12),
                  _buildActivityItem(
                    'Selling Activities',
                    calendarDate.activities?.selling?.total ?? 0,
                    calendarDate.activities?.selling?.hasActivity ?? false,
                    Icons.sell,
                  ),
                  const SizedBox(height: 20),

                  // Total activities
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: calendarDate.hasAnyActivity == true
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          calendarDate.hasAnyActivity == true ? Icons.check_circle : Icons.error,
                          color: calendarDate.hasAnyActivity == true ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          calendarDate.hasAnyActivity == true
                              ? 'Activities recorded for this date'
                              : 'No activities on this date',
                          style: TextStyle(
                            color: calendarDate.hasAnyActivity == true ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Close button
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF0277BD),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

// Helper method to build activity items
  Widget _buildActivityItem(String title, int total, bool hasActivity, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0277BD).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF0277BD),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              Text(
                hasActivity ? '$total activities' : 'No activities',
                style: TextStyle(
                  color: hasActivity ? Colors.green : Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with selected date
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0277BD),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('EEEE', 'id_ID').format(_selectedDate).toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500, height: 1),
                ),
                Text(
                  _selectedDate.day.toString(),
                  style: const TextStyle(
                      color: Colors.white, fontSize: 80, fontWeight: FontWeight.bold, height: 1.2),
                ),
                Text(
                  '${_monthFormat.format(_selectedDate).toUpperCase()}, ${_yearFormat.format(_selectedDate)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Month navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: const Icon(Icons.chevron_left),
                  color: Colors.grey,
                ),
                if (_isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  GestureDetector(
                    onTap: _showYearSelection,
                    child: Text(
                      '${_monthFormat.format(_currentMonth)} ${_yearFormat.format(_currentMonth)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.chevron_right),
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          // Weekday headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']
                  .map((day) => SizedBox(
                        width: 40,
                        child: Text(
                          day,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ))
                  .toList(),
            ),
          ),
          // Calendar grid
          Container(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: 42,
              itemBuilder: (context, index) {
                final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
                final firstDayWeekday = firstDayOfMonth.weekday;
                final day = index - (firstDayWeekday - 1);
                final date = DateTime(_currentMonth.year, _currentMonth.month, day);

                final isCurrentMonth = date.month == _currentMonth.month;
                final isSelected = date.year == _selectedDate.year &&
                    date.month == _selectedDate.month &&
                    date.day == _selectedDate.day;

                return GestureDetector(
                  onTap: () => _showActivityDetails(date),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF0277BD) : _getDateColor(date),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: !isCurrentMonth
                              ? Colors.grey[300]
                              : isSelected
                                  ? Colors.white
                                  : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
