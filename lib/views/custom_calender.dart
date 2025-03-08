import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:palkkaran/core/common_widgets/custom_btn.dart';
import 'package:palkkaran/core/common_widgets/custom_toast.dart';
import 'package:palkkaran/core/navigate.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/view_models/order_view_model.dart';
import 'package:palkkaran/core/view_models/profile_view_model.dart';
import 'package:palkkaran/views/bottom_nav/bottom_nav.dart';
import 'package:palkkaran/views/show_subscriptions.dart';
import 'package:table_calendar/table_calendar.dart';

final focusedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedDaysProvider = StateProvider<List<DateTime>>((ref) => []);
final rangeProvider =
    StateProvider<RangeSelectionMode>((ref) => RangeSelectionMode.toggledOff);
final rangeStartProvider = StateProvider<DateTime?>((ref) => null);
final rangeEndProvider = StateProvider<DateTime?>((ref) => null);
Map<String, int> weekDayMap = {
  'Sun': 0,
  'Mon': 1,
  'Tue': 2,
  'Wed': 3,
  'Thu': 4,
  'Fri': 5,
  'Sat': 6,
};

final selectedWeekDaysProvider =
    StateProvider<List<int>>((ref) => [1, 2, 3, 4, 5]);

class CustomCalendar extends ConsumerStatefulWidget {
  final String selectionType; // 'weekly', 'custom', 'monthly'
  final String? orderId;

  const CustomCalendar({super.key, required this.selectionType, this.orderId});

  @override
  CustomCalendarState createState() => CustomCalendarState();
}

class CustomCalendarState extends ConsumerState<CustomCalendar> {
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateTime? selectedDay;

  String? alternateStartDate;
  List selectedWeekDay = [];

  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  List<String> formattedDates = [];
  bool dateRangeEnabled = false;

  Color selectedColor = ColorUtils.kPrimary;
  Color textColor = ColorUtils.white;
  bool selectTwoWeeks = false;

  List weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  void resetDays(WidgetRef ref) {
    ref.read(selectedWeekDaysProvider.notifier).state = [];
    ref.read(selectedDaysProvider.notifier).state = [];
    formattedDates.clear();
  }

  @override
  void initState() {
    super.initState();
    if (widget.selectionType == 'alternative') {
      _selectAlternate(ref.read(
          focusedDayProvider)); // Pre-select alternate days when the calendar is first rendered
    } else if (widget.selectionType == 'daily') {
      _selectAllDaysInYear(ref.read(
          focusedDayProvider)); // Pre-select all days if daily selection is chosen
    } else if (widget.selectionType == 'monthly') {
      _selectMonthly(ref.read(
          focusedDayProvider)); // Pre-select all days if daily selection is chosen
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime focusedDay = ref.watch(focusedDayProvider);
    List selectedDays = ref.watch(selectedDaysProvider);
    final rangeSelected = ref.watch(rangeProvider);
    final rangeStart = ref.watch(rangeStartProvider);
    final rangeEnd = ref.watch(rangeEndProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(ColorUtils.lightBlue)),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18.sp,
            )),
        centerTitle: true,
        title: Text(
          'Choose the Dates',
          style: TextStyle(
              color: ColorUtils.black,
              fontWeight: FontWeight.bold,
              fontSize: 17.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (widget.selectionType == 'weekly')
              SizedBox(
                height: 100.h,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: weekDays.length,
                    itemBuilder: (context, index) {
                      final selectedWeekDays =
                          ref.watch(selectedWeekDaysProvider);
                      final dayName = weekDayMap.keys.elementAt(index);
                      final dayNumber =
                          weekDayMap[dayName]!; // Get number for day

                      return GestureDetector(
                        onTap: () {
                          if (selectedWeekDays.contains(dayNumber)) {
                            selectedWeekDays.remove(dayNumber);
                          } else {
                            selectedWeekDays.add(dayNumber);
                          }

                          ref.read(selectedWeekDaysProvider.notifier).state =
                              List.from(selectedWeekDays);
                        },
                        child: Container(
                          width: 80.w,
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 16.h),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedWeekDays.contains(dayNumber)
                                  ? Colors.transparent
                                  : ColorUtils.kPrimary,
                            ),
                            color: selectedWeekDays.contains(dayNumber)
                                ? ColorUtils.kPrimary
                                : ColorUtils.white,
                            borderRadius: BorderRadius.circular(12.sp),
                          ),
                          child: Center(
                            child: Text(
                              dayName,
                              style: TextStyle(
                                color: selectedWeekDays.contains(dayNumber)
                                    ? ColorUtils.white
                                    : ColorUtils.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            if (widget.selectionType != 'weekly')
              TableCalendar(
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                rangeStartDay: rangeStart,
                rangeEndDay: rangeEnd,
                onRangeSelected: _onRangeSelected,
                rangeSelectionMode: rangeSelected,
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: false,
                  outsideDaysVisible: false,
                  rangeStartDecoration:
                      BoxDecoration(color: ColorUtils.kPrimary),
                  rangeEndDecoration: BoxDecoration(
                    color: ColorUtils.kPrimary,
                  ),
                  rangeHighlightColor: ColorUtils.kPrimary,
                  withinRangeTextStyle: TextStyle(color: ColorUtils.white),
                  selectedDecoration: BoxDecoration(color: ColorUtils.kPrimary),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false, // Hides the default format button
                  titleCentered: true, // Center the month/year title
                ),
                focusedDay: focusedDay,
                selectedDayPredicate: (day) {
                  if (widget.selectionType == 'alternative') {
                    return selectedDays.any((selectedDay) =>
                        selectedDay.year == day.year &&
                        selectedDay.month == day.month &&
                        selectedDay.day == day.day);
                  } else if (widget.selectionType == 'custom') {
                    return selectedDays.contains(day);
                  } else if (widget.selectionType == 'monthly') {
                    return selectedDays.any((selectedDay) =>
                        selectedDay.year == day.year &&
                        selectedDay.month == day.month &&
                        selectedDay.day == day.day);
                  } else if (widget.selectionType == 'daily') {
                    return selectedDays.any((selectedDay) =>
                        selectedDay.year == day.year &&
                        selectedDay.month == day.month &&
                        selectedDay.day ==
                            day.day); // Check for daily selection
                  }
                  return false;
                },
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    return Container(
                      margin: EdgeInsets.all(6.sp),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.sp),
                          color: ColorUtils.grey), // Normal day
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                              color: Colors.black), // Normal text color
                        ),
                      ),
                    );
                  },
                ),
                enabledDayPredicate: (day) {
                  // Disable dates before today
                  return day
                      .isAfter(DateTime.now().subtract(Duration(days: 1)));
                },
                onDaySelected: (selectedDay, newFocusedDay) {
                  ref.read(focusedDayProvider.notifier).state = newFocusedDay;

                  if (widget.selectionType == 'weekly') {
                    _selectWeekly(selectedDay);
                  } else if (widget.selectionType == 'custom') {
                    _toggleCustomDay(selectedDay);
                  } else if (widget.selectionType == 'monthly') {
                    _selectMonthly(
                        focusedDay); // Use focusedDay for recalculating.
                  } else if (widget.selectionType == 'alternative') {
                    _selectAlternate(
                        focusedDay); // Mark alternate days from today to end of year
                  } else if (widget.selectionType == 'daily') {
                    _selectAllDaysInYear(
                        focusedDay); // Select all days when daily selection is active
                  }
                },
              ),
            // SizedBox(
            //   height: 30.h,
            // ),
            // if (widget.selectionType == 'custom')
            //   Row(
            //     children: [
            //       Expanded(
            //         child: RadioListTile(
            //             title: Text(
            //               'Custom',
            //               style: TextStyle(color: ColorUtils.black),
            //             ),
            //             value: RangeSelectionMode.toggledOff,
            //             groupValue: rangeSelected,
            //             onChanged: (RangeSelectionMode? value) {
            //               ref.read(rangeEndProvider.notifier).state = null;
            //               ref.read(rangeStartProvider.notifier).state = null;
            //               ref.read(rangeProvider.notifier).state = value!;
            //             }),
            //       ),
            //       Expanded(
            //         child: RadioListTile(
            //             title: Text(
            //               'Select Range',
            //               style: TextStyle(color: ColorUtils.black),
            //             ),
            //             value: RangeSelectionMode.toggledOn,
            //             groupValue: rangeSelected,
            //             onChanged: (RangeSelectionMode? value) {
            //               selectedDays.clear();
            //               ref.read(rangeProvider.notifier).state = value!;
            //             }),
            //       )
            //     ],
            //   ),
            // Consumer(
            //   builder: (context, ref, child) {
            //     final model = ref.watch(profileProvider);
            //     if (model.loadingState == ViewState.loading) {
            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     } else if (model.addressModel == null ||
            //         model.addressModel!.data.isEmpty) {
            //       return SizedBox.shrink();
            //     } else {
            //       return ListView.builder(
            //           shrinkWrap: true,
            //           itemCount: model.addressModel!.data.length,
            //           itemBuilder: (contex, index) {
            //             return ListTile(
            //               title:
            //                   Text(model.addressModel!.data[index].streetAddress),
            //             );
            //           });
            //     }
            //   },
            // )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: CustomBtn(
            color: ColorUtils.kPrimary,
            btnText: 'Complete your order',
            padH: 5.w,
            padV: 5.h,
            height: 62.h,
            onTap: () async {
              if (widget.selectionType == 'alternative') {
                DateTime tomorrow = DateTime.now().add(Duration(days: 1));
                alternateStartDate = DateFormat('yyyy-MM-dd').format(tomorrow);
              }

              await ref.read(orderProvider.notifier).changePlan({
                'orderId': ref.read(orderIdProvider.notifier).state,
                'newPlanType': widget.selectionType,
                if (widget.selectionType == 'alternative')
                  'startDate': alternateStartDate,
                if (widget.selectionType == 'alternative') 'interval': 2,
                if (widget.selectionType == 'custom')
                  "customDates": formattedDates,
                if (widget.selectionType == 'weekly')
                  'weeklyDays':
                      ref.read(selectedWeekDaysProvider.notifier).state,
              }).then((response) {
                if (response!.success == true) {
                  resetDays(ref);
                  Go.to(context, BottomNav());
                }
                customToast(response.message);
              });
            }),
      ),
    );
  }

  void _selectWeekly(DateTime selectedDay) {
    List selectedDays = ref.watch(selectedDaysProvider);
    ref.read(selectedDaysProvider).clear();
    int daysToSelect = selectTwoWeeks ? 14 : 7; // Choose 7 or 14 days
    for (int i = 0; i < daysToSelect; i++) {
      final day = selectedDay.add(Duration(days: i));
      selectedDays.add(day);
      ref.read(selectedDaysProvider.notifier).state = List.from(selectedDays);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime? focusedDay) {
    ref.read(rangeStartProvider.notifier).state = start;
    ref.read(rangeEndProvider.notifier).state = end;
    ref.read(focusedDayProvider.notifier).state = focusedDay!;
  }

  void _toggleCustomDay(DateTime selectedDay) {
    if (ref.read(selectedDaysProvider).contains(selectedDay)) {
      ref.read(selectedDaysProvider).remove(selectedDay);
      formattedDates = ref
          .read(selectedDaysProvider)
          .map((date) => dateFormat.format(date))
          .toList();
      log(formattedDates.toString());
    } else {
      ref.read(selectedDaysProvider).add(selectedDay);
      formattedDates = ref
          .read(selectedDaysProvider)
          .map((date) => dateFormat.format(date))
          .toList();
      log(formattedDates.toString());
    }
  }

  void _selectMonthly(DateTime focusedDay) {
    ref.read(selectedDaysProvider).clear();

    // Start from the focused day (current day)
    DateTime startDate =
        DateTime(focusedDay.year, focusedDay.month, focusedDay.day);

    // Select the next 30 days
    for (int i = 0; i < 30; i++) {
      final currentDay = startDate.add(Duration(days: i));
      ref
          .read(selectedDaysProvider)
          .add(DateTime(currentDay.year, currentDay.month, currentDay.day));
    }
  }

  void _selectAlternate(DateTime focusedDay) {
    final today = DateTime.now();
    final lastDayOfYear = DateTime(focusedDay.year, 12, 31);
    ref.read(selectedDaysProvider).clear();

    // Loop through all days from today to the end of the year
    for (int i = 0; i <= lastDayOfYear.difference(today).inDays; i++) {
      final currentDay = today.add(Duration(days: i));

      // Select alternate days (every other day)
      if (i % 2 == 0) {
        ref.read(selectedDaysProvider).add(currentDay);
      }
    }

    // formattedDates = ref
    //     .read(selectedDaysProvider)
    //     .map((date) => dateFormat.format(date))
    //     .toList();
    // // log(formattedDates.toString());
  }

  void _selectAllDaysInYear(DateTime focusedDay) {
    final firstDayOfYear = DateTime(focusedDay.year, 1, 1);
    final lastDayOfYear = DateTime(focusedDay.year, 12, 31);
    ref.read(selectedDaysProvider).clear();

    // Loop through all days from the first to the last day of the year
    for (int i = 0; i <= lastDayOfYear.difference(firstDayOfYear).inDays; i++) {
      final currentDay = firstDayOfYear.add(Duration(days: i));
      ref.read(selectedDaysProvider).add(currentDay);
    }
  }
}
