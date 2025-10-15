import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "اليوم و التاريخ",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: () async {
            DateTime? date = await showOmniDateTimePicker(
              context: context,
              initialDate: selectedDateTime ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              is24HourMode: true,
              theme: ThemeData(
                brightness: isDark ? Brightness.dark : Brightness.light,
                colorScheme: isDark
                    ? const ColorScheme.dark(primary: Color(0xFFBA1B1B))
                    : const ColorScheme.light(primary: Color(0xFFBA1B1B)),
              ),
            );
            if (date != null) onSelected(date);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade400
                    : Colors.white30,
              ),
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : const Color(0xFF1E1E1E),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDateTime == null
                      ? "اختر اليوم و التاريخ"
                      : "${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year}  "
                      "${selectedDateTime!.hour}:${selectedDateTime!.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black87
                        : Colors.white,
                  ),
                ),
                const Icon(Icons.calendar_today_outlined,
                    size: 20, color: Color(0xFFBA1B1B)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
