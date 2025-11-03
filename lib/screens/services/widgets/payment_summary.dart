// lib/screens/final_review/widgets/payment_summary.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/language/locale.dart';
import '../../orders/model/payment_preview_model.dart';

class PaymentSummary extends StatelessWidget {
  final PaymentPreviewModel model;
  final VoidCallback onConfirm;

  const PaymentSummary({
    super.key,
    required this.model,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Positioned(
      left: 0.5.w,
      right: 0.5.w,
      bottom: 0,
      child: Container(
        height: 200.h,
        padding: EdgeInsets.all(16),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: backgroundColor(context),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.5.w, color: borderColor(context)),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.sp),
              topRight: Radius.circular(15.sp),
            ),
          ),
        ),
        child: Column(
          children: [
            Directionality(
              textDirection: locale!.isDirectionRTL(context) ? TextDirection.rtl : TextDirection.ltr,
              child: Column(
                children: [
                  _buildRow(context, "Subtotal", model.breakdown.itemsSubtotal.toString()),
                  _buildRow(context, "Discount", model.breakdown.offerDiscount.toString()),
                  _buildRow(context, "Total", model.breakdown.total.toString(), isTotal: true),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                minimumSize: Size(double.infinity, 35.sp),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
              ),
              child: Text(
                locale.isDirectionRTL(context) ? "تأكيد الطلب" : "Confirm Order",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: isTotal ? borderColor(context) : textColor(context),
            ),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: textColor(context),
            ),
          ),
        ],
      ),
    );
  }
}