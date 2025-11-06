import 'package:abu_diyab_workshop/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../core/language/locale.dart';

class NotesAndCarCounterSection extends StatelessWidget {
  final TextEditingController? notesController;
  final TextEditingController? kiloReadController;
  final bool showNotes;
  final bool showCarCounter;

  final String? notesTitle;
  final String? notesHintText;
  final String? carCounterTitle; // عنوان عداد السيارة القابل للتغيير
  final String? carCounterHintText; // الهينت تيكست القابل للتغيير

  const NotesAndCarCounterSection({
    Key? key,
    this.notesController,
    this.kiloReadController,
    this.showNotes = true,
    this.showCarCounter = true,
    this.notesTitle,
    this.notesHintText,
    this.carCounterTitle,
    this.carCounterHintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showNotes) ...[
          Row(
            children: [
              Text(
                 locale.isDirectionRTL(context) ? "الملاحظات:  "  : " notes:  ",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color:headingColor(context),
                  fontSize: 16.sp,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.w600,
                  height: 1.43,
                ),
              ),
              Text(
                locale.isDirectionRTL(context) ? "(اختياري) " : " (optionl)",
                style: TextStyle(
                  color: paragraphColor(context),
                  fontSize: 12.sp,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            decoration: ShapeDecoration(
              color:buttonBgWhiteColor(context),
              shape: RoundedRectangleBorder(
                side:  BorderSide(width: 1.50.w, color:buttonSecondaryBorderColor(context)),
                borderRadius: BorderRadius.circular(12.sp),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: TextField(
                controller: notesController,
                maxLines: null,
                textAlign: locale.isDirectionRTL(context)
                    ? TextAlign.right
                    : TextAlign.left,
                textDirection: locale.isDirectionRTL(context)
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                decoration: InputDecoration(
                  hintText: locale.isDirectionRTL(context)
                      ? "اكتب ملاحظاتك هنا..."
                      : "Write your notes here...",
                  hintTextDirection: locale.isDirectionRTL(context)
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w500,
                    height: 1.2.h,
                    color: paragraphColor(context),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
        ],

        if (showCarCounter) ...[
          Align(
            alignment:
                locale.isDirectionRTL(context)
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            child: Text(
              carCounterTitle ??
                  (locale.isDirectionRTL(context)
                      ? "ممشى السياره"
                      : "Car mileage"),
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color:buttonBgWhiteColor(context),
              borderRadius: BorderRadius.circular(12.sp),
              border: Border.all(color:buttonSecondaryBorderColor(context), width: 1.5.w),
            ),
            child: Row(
              textDirection:
                  locale.isDirectionRTL(context)
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
                          color: paragraphColor(context),
                          fontSize: 13.sp,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w500,
                        ),
                        hintTextDirection:
                            locale.isDirectionRTL(context)
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        border: InputBorder.none,
                      ),
                      textDirection:
                          locale.isDirectionRTL(context)
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
                    color:headingColor(context),
                    fontSize: 15.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
