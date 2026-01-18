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
      // height: 300.h,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: buttonBgWhiteColor(context),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: strokeGrayColor(context)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),
            topRight: Radius.circular(15.sp),
          ),
        ),
      ),
      child:
          isLoading
              ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
              : Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Directionality(
                    textDirection:
                        locale!.isDirectionRTL(context)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        model.breakdown.itemsSubtotal == 0
                            ? SizedBox.shrink()
                            : _buildRow(
                              context,
                              locale!.isDirectionRTL(context)
                                  ? "المجموع "
                                  : "Subtotal",
                              model.breakdown.itemsSubtotal.toString(),
                            ),

                        model.breakdown.packageDiscount == 0
                            ? SizedBox.shrink()
                            : _buildRow(
                              context,
                              locale.isDirectionRTL(context)
                                  ? "خصم الباقة"
                                  : "Package Discount",
                              model.breakdown.packageDiscount.toString(),
                            ),
                        model.breakdown.offerDiscount == 0
                            ? SizedBox.shrink()
                            : _buildRow(
                              context,
                              locale.isDirectionRTL(context)
                                  ? "خصم العرض"
                                  : "Offer Discount",
                              model.breakdown.offerDiscount.toString(),
                            ),
                        model.breakdown.pointsRequested == 0
                            ? SizedBox.shrink()
                            : _buildRow(
                              context,
                              locale.isDirectionRTL(context)
                                  ? "النقاط المستخدمة"
                                  : "Points Used",
                              model.breakdown.pointsRequested.toString(),
                            ),
                        model.breakdown.pointsDiscount == 0
                            ? SizedBox.shrink()
                            : _buildRow(
                              context,
                              locale.isDirectionRTL(context)
                                  ? "خصم النقاط"
                                  : "Points Discount",
                              model.breakdown.pointsDiscount.toString(),
                            ),
                        model.breakdown.walletBalanceAfterDeduction == 0
                            ? SizedBox.shrink()
                            : _buildRow(
                              context,
                              locale.isDirectionRTL(context)
                                  ? "الرصيد بعد الخصم"
                                  : "walletBalanceAfterDeduction",
                              model.breakdown.walletBalanceAfterDeduction
                                  .toString(),
                              isTotal: true,
                            ),
                        model.breakdown.totalAfterDiscounts == 0
                            ? SizedBox.shrink()
                            : _buildRow(
                              context,
                              locale.isDirectionRTL(context)
                                  ? "الإجمالي بعد الخصومات"
                                  : "total After Discounts",
                              model.breakdown.totalAfterDiscounts.toString(),
                              isTotal: true,
                            ),

                        model.breakdown.taxAmount == 0
                            ? SizedBox.shrink()
                            : _buildRow(
                              context,
                              locale.isDirectionRTL(context)
                                  ? "مبلغ الضريبة (${model.breakdown.taxRate.toString()}%)"
                                  : "taxAmount (${model.breakdown.taxRate.toString()}%)",
                              model.breakdown.taxAmount.toString(),
                              isTotal: true,
                            ),

                        _buildRow(
                          context,
                          locale.isDirectionRTL(context)
                              ? "المجموع النهائي"
                              : "Total",
                          model.breakdown.total.toString(),
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  //   const Spacer(),
                  GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      width: double.infinity,
                      height: 55.sp,
                      decoration: BoxDecoration(
                        color: typographyMainColor(context),
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        locale.isDirectionRTL(context)
                            ? "تأكيد الطلب"
                            : "Confirm Order",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Graphik Arabic',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: headingColor(context),
              fontSize: 14.sp,
              fontFamily: 'Graphik Arabic',
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: headingColor(context),
              fontFamily: 'Graphik Arabic',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
