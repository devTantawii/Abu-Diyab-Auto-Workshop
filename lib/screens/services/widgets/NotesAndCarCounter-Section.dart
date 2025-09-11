import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../core/language/locale.dart';

class NotesAndCarCounterSection extends StatelessWidget {
  final TextEditingController? notesController;
  final TextEditingController? kiloReadController;

  const NotesAndCarCounterSection({
    Key? key,
    this.notesController,
    this.kiloReadController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
// هنا جزء الملاحظات يابا
       Text(
          'الملاحظات',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            fontSize: 14.sp,
            fontFamily: 'Graphik Arabic',
            fontWeight: FontWeight.w600,
            height: 1.43,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          decoration: ShapeDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1.50, color: Color(0xFF9B9B9B)),
              borderRadius: BorderRadius.circular(15),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: TextField(
              controller: notesController,
              maxLines: null,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: "اكتب ملاحظاتك هنا...",
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.w500,
                  height: 1.57,
                  color: Colors.black.withOpacity(0.5),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        SizedBox(height: 15.h),

        /// ---------------- ممشى السيارة ----------------
        Align(
          alignment: locale.isDirectionRTL(context)
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Text(
            locale.isDirectionRTL(context) ? "ممشى السياره" : "Car counter",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: Row(
            textDirection: locale.isDirectionRTL(context)
                ? TextDirection.rtl
                : TextDirection.ltr,
            children: [
              Expanded(
                child: DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 1,
                  dashPattern: const [6, 3],
                  borderType: BorderType.RRect,
                  radius: Radius.circular(8.r),
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: TextField(
                    controller: kiloReadController,
                    decoration: InputDecoration(
                      hintText: '0000000',
                      hintStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white38,
                        fontSize: 13.sp,
                        fontFamily: 'Graphik Arabic',
                        fontWeight: FontWeight.w500,
                      ),
                      hintTextDirection: locale.isDirectionRTL(context)
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.h,
                      ),
                      border: InputBorder.none,
                    ),
                    textDirection: locale.isDirectionRTL(context)
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                locale.isDirectionRTL(context) ? 'كم' : 'KM',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  fontSize: 15.sp,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
