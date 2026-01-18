import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/language/locale.dart';
import '../../../core/constant/app_colors.dart';
import '../../orders/model/payment_preview_model.dart';

class PaymentMethodTile extends StatelessWidget {
  final PaymentMethod method;
  final String? selected;
  final AppLocalizations locale;
  final Function(String) onSelect;

  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.selected,
    required this.locale,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == method.key;

    return GestureDetector(
      onTap: () => onSelect(method.key),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContainer(context, isSelected),
          if (_description(context).isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 6.w, right: 6.w),
              child: Text(
                _description(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: paragraphColor(context),
                ),
              ),
            ),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildContainer(BuildContext context, bool isSelected) {
    return Container(
      height: 60.h,
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isSelected ? typographyMainColor(context) : Colors.grey,
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/${method.key}.png',
            width: 42.w,
            height: 30.h,
            fit: BoxFit.contain,
             errorBuilder: (context, error, stackTrace) {
              return SizedBox(
                width: 42.w,
                height: 30.h,
              );
            },
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              method.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildRadio(isSelected, context),
        ],
      ),
    );
  }

  Widget _buildRadio(bool isSelected, BuildContext context) {
    return Container(
      width: 26.w,
      height: 26.h,
      decoration: BoxDecoration(
        color: isSelected ? typographyMainColor(context) : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? typographyMainColor(context) : Colors.grey,
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check, size: 14.sp, color: Colors.white)
          : SizedBox(),
    );
  }

  String _description(BuildContext context) {
    switch (method.key) {
      case "tamara":
        return locale.isDirectionRTL(context)
            ? "ادفع جزء من المبلغ الحين والباقي علي دفعات."
            : "Pay part now and the rest in installments.";
      case "madfu":
        return locale.isDirectionRTL(context)
            ? "قسم فاتورتك حتي 4 أقسام بسهولة."
            : "Split your bill into up to 4 easy parts.";
      case "cash":
        return locale.isDirectionRTL(context)
            ? "سدد المبلغ نقدًا في المركز."
            : "Pay in cash at the center.";
      default:
        return "";
    }
  }
}
