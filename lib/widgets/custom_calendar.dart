import 'package:flutter/material.dart';
// Note: You might need to add intl to your pubspec.yaml if you haven't already
// flutter pub add intl
import 'package:intl/intl.dart';

class ScrollableCalendar extends StatefulWidget {
  final List<DateTime> activeDays;
  final ValueChanged<DateTime>? onDayPressed;

  const ScrollableCalendar({
    super.key,
    required this.activeDays,
    this.onDayPressed,
  });

  @override
  State<ScrollableCalendar> createState() => _ScrollableCalendarState();
}

class _ScrollableCalendarState extends State<ScrollableCalendar> {
  late PageController _pageController;
  late DateTime _currentWeekStart;
  final int _initialPage = 5000;

  @override
  void initState() {
    super.initState();
    // Start the current week from the Monday of the current week.
    final now = DateTime.now();
    _currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // --- Navigation Handlers ---
  void _goToPreviousWeek() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _goToNextWeek() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          // New Header with Arrows
          _CalendarHeader(
            currentDate:
                _currentWeekStart, // We use start of the week for display logic
            onPreviousPressed: _goToPreviousWeek,
            onNextPressed: _goToNextWeek,
          ),
          const SizedBox(height: 10),

          // Weekdays row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                  .map(
                    (d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 8),

          // PageView for weeks
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  // Calculate the new week start based on the page index difference
                  int weekDifference = index - _initialPage;
                  _currentWeekStart = DateTime.now().subtract(
                    Duration(
                      days: DateTime.now().weekday - 1 - weekDifference * 7,
                    ),
                  );
                });
              },
              itemBuilder: (context, index) {
                // Calculate the start day of the week being viewed
                final weekStart = DateTime.now().subtract(
                  Duration(
                    days:
                        DateTime.now().weekday - 1 - (index - _initialPage) * 7,
                  ),
                );
                return _buildWeek(weekStart);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------- ENTIRE WEEK VIEW ----------
  Widget _buildWeek(DateTime weekStart) {
    List<Widget> weekCells = [];
    // Generate 7 days starting from Monday
    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      weekCells.add(_dayCell(date));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // Display a single row for the current week
      child: Row(children: weekCells),
    );
  }

  // ---------- CELLS ----------
  Widget _dayCell(DateTime date) {
    final bool isActive = _isActive(date);
    final bool isToday = _isSameDay(date, DateTime.now());
    // Check if the day belongs to the month currently shown in the header
    final bool isInCurrentMonth = date.month == _currentWeekStart.month;

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onDayPressed?.call(date),
        child: Container(
          height: 45,
          alignment: Alignment.center,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? Colors.blueAccent.withOpacity(0.9) // Fixed syntax
                  : isToday
                  ? Colors.white.withOpacity(0.1) // Fixed syntax
                  : Colors.transparent,
            ),
            alignment: Alignment.center,
            child: Text(
              "${date.day}",
              style: TextStyle(
                // Dim the color of days not in the active month
                color: Colors.white.withOpacity(isInCurrentMonth ? 1.0 : 0.4),
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- HELPERS ----------
  bool _isActive(DateTime date) {
    return widget.activeDays.any((d) => _isSameDay(d, date));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

// --- New Widget for Header and Arrows ---
class _CalendarHeader extends StatelessWidget {
  final DateTime currentDate;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;

  const _CalendarHeader({
    required this.currentDate,
    required this.onPreviousPressed,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Format the date range to show the current month and year(s) clearly.
    // This example just uses the month of the first day of the week
    final headerText = DateFormat.yMMMM().format(currentDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: onPreviousPressed,
          ),
          Text(
            headerText,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: onNextPressed,
          ),
        ],
      ),
    );
  }
}
