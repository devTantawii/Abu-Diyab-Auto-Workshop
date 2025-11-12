import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/language/locale.dart';
import '../../orders/model/payment_preview_model.dart';

class BalanceSection extends StatefulWidget {
  final Function(int)? onApplyPoints;
  final PaymentPreviewModel model;
  final int appliedPoints;

  const BalanceSection({
    super.key,
    this.onApplyPoints,
    required this.model,
    required this.appliedPoints,
  });

  @override
  State<BalanceSection> createState() => _BalanceSectionState();
}

class _BalanceSectionState extends State<BalanceSection> {
  final TextEditingController _pointsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final balance = widget.model.breakdown.walletBalanceAfterDeduction ?? 0;
    final int appliedPoints = widget.appliedPoints;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              locale!.isDirectionRTL(context)
                  ? "استخدم رصيدك المالي:"
                  : "Use your financial balance:",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: headingColor(context),
              ),
            ),
            const Spacer(),
            Text(
              locale.isDirectionRTL(context)
                  ? "رصيدك: $balance"
                  : "Your balance: $balance",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: paragraphColor(context),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          height: 50.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            border: Border.all(color: buttonSecondaryBorderColor(context), width: 1.w),
            color: buttonBgWhiteColor(context),
          ),
          child: Row(
            textDirection: locale.isDirectionRTL(context)
                ? TextDirection.rtl
                : TextDirection.ltr,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _pointsController,
                    keyboardType: TextInputType.number,
                    textAlign: locale.isDirectionRTL(context)
                        ? TextAlign.right
                        : TextAlign.left,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: locale.isDirectionRTL(context)
                          ? "ادخل النقاط"
                          : "Enter your points",
                      hintStyle: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: _applyPoints,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: typographyMainColor(context),
                    borderRadius: BorderRadius.circular(10.sp),
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
              ),
            ],
          ),
        ),
        if (widget.model.breakdown.pointsRequested > 0) ...[
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                locale.isDirectionRTL(context)
                    ? "تم تطبيق $appliedPoints من النقاط ✅"
                    : "$appliedPoints points have been applied ✅",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
              TextButton(
                onPressed: _cancelPoints,
                child: Text(
                  locale.isDirectionRTL(context) ? "إلغاء" : "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  void _applyPoints() {
    final enteredPoints = int.tryParse(_pointsController.text.trim()) ?? 0;
    widget.onApplyPoints?.call(enteredPoints);
  }

  void _cancelPoints() {
    _pointsController.clear();
    widget.onApplyPoints?.call(0);
  }
}
