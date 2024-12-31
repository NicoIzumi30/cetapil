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
      if (mounted) {
        // Check if widget is still mounted
        setState(() => _calendarData = response);
      }
    } catch (e) {
      if (mounted) {
        // Check if widget is still mounted before showing SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading calendar data: $e')),
        );
      }
    } finally {
      if (mounted) {
        // Check if widget is still mounted
        setState(() => _isLoading = false);
      }
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
            child: ConstrainedBox(
              // Add constraint to prevent full-screen dialog
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              child: SingleChildScrollView(
                // Make content scrollable
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
                          overflow: TextOverflow.ellipsis, // Handle text overflow
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Activities
                      Flexible(
                        // Make activities section flexible
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                          ],
                        ),
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
                              calendarDate.hasAnyActivity == true
                                  ? Icons.check_circle
                                  : Icons.error,
                              color:
                                  calendarDate.hasAnyActivity == true ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              // Wrap text in Expanded
                              child: Text(
                                calendarDate.hasAnyActivity == true
                                    ? 'Activities recorded for this date'
                                    : 'No activities on this date',
                                style: TextStyle(
                                  color: calendarDate.hasAnyActivity == true
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis, // Handle text overflow
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
              ),
            ),
          );
        },
      );
    }
  }

// You'll also need to update the _buildActivityItem method to handle overflow
  Widget _buildActivityItem(String title, int total, bool hasActivity, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF0277BD),
        ),
        const SizedBox(width: 12),
        Expanded(
          // Wrap text in Expanded
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis, // Handle text overflow
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: hasActivity ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            total.toString(),
            style: TextStyle(
              color: hasActivity ? Colors.green : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;
    final maxDialogWidth = screenSize.width * 0.9; // 90% of screen width
    final maxDialogHeight = screenSize.height * 0.8; // 80% of screen height

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxDialogWidth,
          maxHeight: maxDialogHeight,
        ),
        child: SingleChildScrollView(
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
                padding: EdgeInsets.all(screenSize.width * 0.03), // Responsive padding
                child: Column(
                  children: [
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
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        DateFormat('EEEE', 'id_ID').format(_selectedDate).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _selectedDate.day.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${_monthFormat.format(_selectedDate).toUpperCase()}, ${_yearFormat.format(_selectedDate)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Month navigation
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.02,
                  vertical: screenSize.height * 0.01,
                ),
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
                padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']
                      .map((day) => Expanded(
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
                padding: EdgeInsets.all(screenSize.width * 0.02),
                child: AspectRatio(
                  aspectRatio: 7 / 6, // Maintains the grid's aspect ratio
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
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
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF0277BD) : _getDateColor(date),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding: const EdgeInsets.all(2),
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
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
