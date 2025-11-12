// lib/screens/final_review/widgets/order_success_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/language/locale.dart';
import '../../../../widgets/commponents.dart';
import '../../../core/constant/app_colors.dart';

class OrderSuccessBottomSheet extends StatelessWidget {
  final int orderId;
  final double amount;

  const OrderSuccessBottomSheet({
    super.key,
    required this.orderId,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: backgroundColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.sp)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),

            Text(
              locale!.isDirectionRTL(context)
                  ? "تم إنشاء الطلب بنجاح! 🎉"
                  : "Order Created Successfully! 🎉",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: typographyMainColor(
                  context,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),

            Image.asset(
              "assets/images/payment_successful.png",
              width: 240.w,
              height: 240.h,
            ),
            SizedBox(height: 8.h),

            Text(
              locale.isDirectionRTL(context)
                  ? "شكراً لإستخدامك تطبيق أبوذياب.\nنحن في طريقنا إليك في الوقت المحدد، لا تقلق!"
                  : "Thank you for using the Abu Diyab app.\nWe are on our way to you on time, don't worry!",
              style: TextStyle(
                fontSize: 18.sp,
                color:  Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white70,
                fontFamily: 'Graphik Arabic',
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),

            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: typographyMainColor(
                  context,
                ),
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.sp),
                ),
              ),
              child: Text(
                locale.isDirectionRTL(context)
                    ? "العودة للرئيسية"
                    : "Back to Home",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
