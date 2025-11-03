// lib/screens/final_review/widgets/balance_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/language/locale.dart';

class BalanceSection extends StatelessWidget {
  const BalanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Column(
      children: [
        Row(
          children: [
            Text(
              locale!.isDirectionRTL(context) ? " استخدم رصيدك المالي : " : "Use your financial balance :",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: textColor(context),
              ),
            ),
            Spacer(),
            Text(
              locale.isDirectionRTL(context) ? "  رصيدك: 195 " : "Your balance: 195 ",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: borderColor(context),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          height: 50.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            border: Border.all(color: borderColor(context), width: 1.w),
            color: boxcolor(context),
          ),
          child: Row(
            textDirection: locale.isDirectionRTL(context) ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    textAlign: locale.isDirectionRTL(context) ? TextAlign.right : TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: locale.isDirectionRTL(context) ? "ادخل رصيدك" : "Enter your balance",
                      hintStyle: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFBA1B1B),
                  borderRadius: BorderRadius.only(
                    topLeft: locale.isDirectionRTL(context) ? Radius.circular(8.sp) : Radius.circular(0.sp),
                    topRight: locale.isDirectionRTL(context) ? Radius.circular(12.sp) : Radius.circular(8.sp),
                    bottomLeft: locale.isDirectionRTL(context) ? Radius.circular(8.sp) : Radius.circular(12.sp),
                    bottomRight: locale.isDirectionRTL(context) ? Radius.circular(0.sp) : Radius.circular(8.sp),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  locale.isDirectionRTL(context) ? 'تطبيق' : "Apply",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            locale.isDirectionRTL(context)
                ? " يمكنك إستخدام رصيد محفظتك في دفع رسوم الخدمة "
                : "You can use your wallet balance to pay the service fee",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: borderColor(context),
            ),
          ),
        ),
      ],
    );
  }
}