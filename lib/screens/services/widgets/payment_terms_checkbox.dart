import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/language/locale.dart';
import '../../../core/constant/app_colors.dart';
import '../../more/screen/widget/terms and conditions.dart';

class PaymentTermsCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  const PaymentTermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Row(
      children: [
        Checkbox(
          value: value,
          activeColor: typographyMainColor(context),
          onChanged: (v) => onChanged(v!),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TermsAndConditions(),
                ),
              );
            },
            child: Text(
              locale!.isDirectionRTL(context)
                  ? "أوافق على الشروط والأحكام"
                  : "I agree to the Terms and Conditions",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: typographyMainColor(context),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
