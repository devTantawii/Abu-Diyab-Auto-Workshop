import 'package:abu_diyab_workshop/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../../../core/language/locale.dart';

class DateTimeSection extends StatelessWidget {
  final DateTime? selectedDateTime;
  final Function(DateTime) onSelected;

  const DateTimeSection({
    super.key,
    required this.selectedDateTime,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale!.isDirectionRTL(context)
              ? 'اليوم و التاريخ'
              : 'The day and the date',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: headingColor(context),
          ),
        ),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: () async {
            DateTime? date = await showOmniDateTimePicker(
              context: context,
              initialDate: selectedDateTime ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(
                DateTime.now().year + 5,
                DateTime.now().month,
                DateTime.now().day,
              ),
              is24HourMode: true,
              theme: ThemeData(
                brightness: isDark ? Brightness.dark : Brightness.light,
                colorScheme:
                    isDark
                        ? const ColorScheme.dark(primary: Color(0xFFBA1B1B))
                        : const ColorScheme.light(primary: Color(0xFFBA1B1B)),

                timePickerTheme: TimePickerThemeData(
                  hourMinuteTextStyle: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  dayPeriodTextStyle: TextStyle(fontSize: 16.sp),
                ),
                textTheme: TextTheme(
                  titleMedium: TextStyle(fontSize: 16.sp),
                  bodyMedium: TextStyle(fontSize: 15.sp),
                  labelLarge: TextStyle(fontSize: 16.sp),
                ),
              ),
            );

            if (date != null) onSelected(date);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.sp),
              border: Border.all(color: buttonSecondaryBorderColor(context), width: 1.5.w),
              color: buttonBgWhiteColor(context),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDateTime == null
                      ? locale.isDirectionRTL(context)
                          ? 'اختر اليوم و التاريخ'
                          : 'Choose the day and date'
                      : "${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year}  "
                          "${selectedDateTime!.hour}:${selectedDateTime!.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: headingColor(context),
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20.sp,
                  color: accentColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
