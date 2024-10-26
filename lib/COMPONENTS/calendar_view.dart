import 'package:ads_mahem/MODELS/screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ads_mahem/COMPONENTS/button_view.dart';
import 'package:ads_mahem/COMPONENTS/padding_view.dart';
import 'package:ads_mahem/COMPONENTS/text_view.dart';
import 'package:ads_mahem/FUNCTIONS/colors.dart';
import 'package:ads_mahem/FUNCTIONS/date.dart';

class CalendarView extends StatefulWidget {
  final Color backgroundColor;
  final Function(DateTime) onTapDate;
  final Set<DateTime> highlightedDates;
  final Set<DateTime> disabledDates;
  final bool startToday;
  final bool thisMonth;
  final Color selectedColor;
  final Color selectedTextColor;
  final int year;

  CalendarView({
    super.key,
    this.backgroundColor = Colors.black12,
    required this.year,
    required this.onTapDate,
    List<DateTime>? highlightedDates,
    List<DateTime>? disabledDates,
    this.startToday = false,
    this.thisMonth = false,
    this.selectedColor = Colors.black,
    this.selectedTextColor = Colors.white,
  })  : highlightedDates = Set.from(highlightedDates ?? []),
        disabledDates = Set.from(disabledDates ?? []);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    setState(() {
      _pageController = PageController(
        initialPage: _getInitialPage(),
      );
    });
  }

  int _getInitialPage() {
    if (widget.thisMonth) {
      final today = DateTime.now();
      if (today.year == widget.year) {
        return today.month - 1;
      }
    }
    return 0;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onTappedDate(DateTime date) {
    if (!widget.disabledDates.contains(date)) {
      widget.onTapDate(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final months = getMonthsOfYear(widget.year);

    return SizedBox(
      height: getWidth(context),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: months.length,
              itemBuilder: (context, index) {
                final month = months[index];
                final daysInMonth = getDaysOfMonth(index + 1, widget.year);
                final firstDayOfMonth = DateTime(widget.year, index + 1, 1);
                final startingWeekday = firstDayOfMonth.weekday;

                return PaddingView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextView(
                        text: month,
                        weight: FontWeight.w700,
                        size: 26,
                      ),
                      const PaddingView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextView(text: "S"),
                            TextView(text: "M"),
                            TextView(text: "T"),
                            TextView(text: "W"),
                            TextView(text: "T"),
                            TextView(text: "F"),
                            TextView(text: "S"),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: daysInMonth.length + startingWeekday - 1,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            childAspectRatio: 1.2,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                          ),
                          itemBuilder: (context, dayIndex) {
                            if (dayIndex < startingWeekday - 1) {
                              return const SizedBox(); // Empty space
                            }
                            final day =
                                daysInMonth[dayIndex - (startingWeekday - 1)];
                            final date = DateTime(widget.year, index + 1, day);
                            final isHighlighted =
                                widget.highlightedDates.any((highlightedDate) {
                              return highlightedDate.year == date.year &&
                                  highlightedDate.month == date.month &&
                                  highlightedDate.day == date.day;
                            });
                            final isDisabled =
                                widget.disabledDates.contains(date) ||
                                    (widget.startToday &&
                                        date.isBefore(DateTime.now()));

                            return ButtonView(
                              radius: 100,
                              isDisabled: isDisabled,
                              backgroundColor: isHighlighted
                                  ? widget.selectedColor
                                  : widget.backgroundColor,
                              onPress: () => onTappedDate(date),
                              child: Center(
                                child: TextView(
                                  text: day.toString(),
                                  size: 18,
                                  weight: FontWeight.w500,
                                  color: isDisabled
                                      ? Colors.grey
                                      : isHighlighted
                                          ? widget.selectedTextColor
                                          : Colors.black,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: months.length,
            effect: const ScrollingDotsEffect(
              dotWidth: 8,
              dotHeight: 8,
              activeDotScale: 1.5,
              spacing: 12,
              dotColor: Colors.grey,
              activeDotColor: Colors.blue,
            ),
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
