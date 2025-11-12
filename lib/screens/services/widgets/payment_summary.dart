import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/language/locale.dart';
import '../../orders/model/payment_preview_model.dart';

class PaymentSummary extends StatelessWidget {
  final PaymentPreviewModel model;
  final VoidCallback onConfirm;
  final bool isLoading;

  const PaymentSummary({
    super.key,
    required this.model,
    required this.onConfirm,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Container(
      height: 300.h,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: backgroundColor(context),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.5.w, color: paragraphColor(context)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),
            topRight: Radius.circular(15.sp),
          ),
        ),
      ),
      child: isLoading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
          : Column(
        children: [
          Directionality(
            textDirection: locale!.isDirectionRTL(context)
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Column(
              children: [
                _buildRow(context, "Subtotal",
                    model.breakdown.itemsSubtotal.toString()),
                _buildRow(context, "Package Discount",
                    model.breakdown.packageDiscount.toString()),
                _buildRow(context, "Offer Discount",
                    model.breakdown.offerDiscount.toString()),
                _buildRow(context, "Points Used",
                    model.breakdown.pointsRequested.toString()),
                _buildRow(context, "Points Discount",
                    model.breakdown.pointsDiscount.toString()),
                _buildRow(context, "Total",
                    model.breakdown.total.toString(),
                    isTotal: true),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor:                        typographyMainColor(context),

    minimumSize: Size(double.infinity, 35.sp),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
            ),
            child: Text(
              locale.isDirectionRTL(context)
                  ? "تأكيد الطلب"
                  : "Confirm Order",
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value,
      {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: headingColor(context)),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, color: headingColor(context)),
          ),
        ],
      ),
    );
  }
}
