// lib/screens/final_review/widgets/payment_method_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/language/locale.dart';
import '../../../core/constant/app_colors.dart';
import '../../../widgets/progress_bar.dart';
import '../../orders/model/payment_preview_model.dart';

class PaymentMethodModal extends StatefulWidget {
  final List<PaymentMethod> paymentMethods;
  final String? selectedMethod;
  final Function(String) onSelect;
  final VoidCallback onConfirm;

  const PaymentMethodModal({
    super.key,
    required this.paymentMethods,
    this.selectedMethod,
    required this.onSelect,
    required this.onConfirm,
  });

  @override
  State<PaymentMethodModal> createState() => _PaymentMethodModalState();
}

class _PaymentMethodModalState extends State<PaymentMethodModal> {
  late String? selected = widget.selectedMethod;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.all(16.sp),
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: backgroundColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.sp)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ProgressBarr(),
              ProgressBarr(),
              ProgressBarr(active: true),
            ],
          ),
          SizedBox(height: 15.h),

          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: backgroundColor(context), // خلفية بيضاء
                borderRadius: BorderRadius.circular(16.sp),
                border: Border.all(
                  color: Colors.grey, // بوردر رمادي فاتح
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Bar
                  SizedBox(height: 12.h),

                  // العنوان
                  Text(
                    locale!.isDirectionRTL(context)
                        ? 'طريقة الدفع'
                        : "Payment Options",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor(context),
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // الوصف
                  Text(
                    locale.isDirectionRTL(context)
                        ? 'برجاء إختيار طريقة الدفع المناسبة لك.'
                        : "Choose your preferred payment method.",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: borderColor(context),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                            widget.paymentMethods.map((method) {
                              final isSelected = selected == method.key;
                              return GestureDetector(
                                onTap: () {
                                  setState(() => selected = method.key);
                                  widget.onSelect(method.key);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 60.h,
                                      margin: EdgeInsets.symmetric(vertical: 6),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).brightness == Brightness.light
                                            ? Colors.white
                                            : Colors.black,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: borderColor(context),
                                          width: 1.5.w,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: shadowcolor(context),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        textDirection:
                                            locale.isDirectionRTL(context)
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                        children: [
                                          //    Text(method.key),
                                          Image.asset(
                                            'assets/icons/${method.key}.png',
                                            width: 42.w,
                                            height: 30.h,
                                            fit: BoxFit.contain,
                                          ),
                                          SizedBox(width: 12.w),

                                          // اسم الطريقة
                                          Expanded(
                                            child: Text(
                                              method.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),

                                          // دائرة الاختيار
                                          Container(
                                            width: 26.w,
                                            height: 26.h,
                                            decoration: BoxDecoration(
                                              color:
                                                  isSelected
                                                      ? Color(0xFFBA1B1B)
                                                      : Colors.transparent,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color:
                                                    isSelected
                                                        ? Color(0xFFBA1B1B)
                                                        : Colors.grey,
                                                width: 2,
                                              ),
                                            ),
                                            child:
                                                isSelected
                                                    ? Icon(
                                                      Icons.check,
                                                      size: 14.sp,
                                                      color: Colors.white,
                                                    )
                                                    : SizedBox(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (method.key == "tamara")
                                      Text(
                                        locale.isDirectionRTL(context)
                                            ? 'ادفع جزء من المبلغ الحين والباقي علي دفعات حسب خطة الدفع.'
                                            : "Pay part of the amount now and the rest in installments according to the payment plan.",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: borderColor(context),
                                        ),
                                      )
                                    else if (method.key == "madfu")
                                      Text(
                                        locale.isDirectionRTL(context)
                                            ? 'قسم فاتورتك حتي 4 أقسام بسهولة وأمان مع مدفوع.'
                                            : "Easily and securely divide your bill into up to 4 sections with Madfou.",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: borderColor(context),
                                        ),
                                      )
                                    else if (method.key == "cash")
                                      Text(
                                        locale.isDirectionRTL(context)
                                            ? 'سدد المبلغ نقدًا مباشرة في المركز .'
                                            : "Pay the amount in cash directly at the center.",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: borderColor(context),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // === زرار تأكيد الطلب (خارج الكونتينر الأبيض) ===
          ElevatedButton(
            onPressed: widget.onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              minimumSize: Size(double.infinity, 50.sp),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.sp),
              ),
            ),
            child: Text(
              locale.isDirectionRTL(context) ? "تأكيد الطلب" : "Confirm Order",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressBarr extends StatelessWidget {
  final bool active;

  const ProgressBarr({super.key, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75.w,
      height: 6.h,
      decoration: ShapeDecoration(
        color: active ? const Color(0xFFBA1B1B) : const Color(0xFFAFAFAF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
    );
  }
}
